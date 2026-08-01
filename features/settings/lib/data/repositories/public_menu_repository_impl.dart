import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:app_settings/repositories/settings_repository.dart';
import 'package:catalog/repositories/categories_repository.dart';
import 'package:catalog/repositories/combos_repository.dart';
import 'package:catalog/repositories/products_repository.dart';
import 'package:crypto/crypto.dart';
import 'package:feature_settings/data/sources/remote/public_menu_remote_data_source.dart';
import 'package:feature_settings/domain/models/public_menu_models.dart';
import 'package:feature_settings/domain/repositories/public_menu_repository.dart';
import 'package:feature_settings/domain/services/public_menu_snapshot_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:result/result.dart';
import 'package:talker/talker.dart';

const _configurationKey = 'public_menu.configuration';
const _publicationKey = 'public_menu.publication';
const _templateManifestKey = 'public_menu.template_manifest';
const _capabilityKeyPrefix = 'public_menu.owner_capability.';
const _businessNameKey = 'business_name';

class PublicMenuRepositoryImpl extends Repository
    implements PublicMenuRepository {
  PublicMenuRepositoryImpl({
    required SettingsRepository settingsRepository,
    required CategoriesRepository categoriesRepository,
    required ProductsRepository productsRepository,
    required CombosRepository combosRepository,
    required FlutterSecureStorage secureStorage,
    required PublicMenuRemoteDataSource remoteDataSource,
    Talker? logger,
  }) : _settingsRepository = settingsRepository,
       _categoriesRepository = categoriesRepository,
       _productsRepository = productsRepository,
       _combosRepository = combosRepository,
       _secureStorage = secureStorage,
       _remoteDataSource = remoteDataSource,
       _snapshotBuilder = const PublicMenuSnapshotBuilder(),
       super(logger);

  final SettingsRepository _settingsRepository;
  final CategoriesRepository _categoriesRepository;
  final ProductsRepository _productsRepository;
  final CombosRepository _combosRepository;
  final FlutterSecureStorage _secureStorage;
  final PublicMenuRemoteDataSource _remoteDataSource;
  final PublicMenuSnapshotBuilder _snapshotBuilder;

  @override
  Future<Result<PublicMenuData>> load() => safe('loadPublicMenu', () async {
    final configuration = await _readConfiguration();
    final publication = await _readPublication();
    final templates = await _readCachedTemplates();
    final hasUpdate = publication == null
        ? false
        : (await _buildSnapshot(configuration)).$2 != publication.snapshotHash;
    return PublicMenuData(
      configuration: configuration,
      templates: templates,
      publication: publication,
      hasUpdate: hasUpdate,
    );
  });

  @override
  Future<Result<List<MenuTemplate>>> refreshTemplates() =>
      safe('refreshPublicMenuTemplates', () async {
        final templates = await _remoteDataSource.getTemplates();
        await _writeJson(
          _templateManifestKey,
          templates.map((template) => template.toJson()).toList(),
        );
        return templates;
      });

  @override
  Future<Result<PublicMenuConfiguration>> saveConfiguration(
    PublicMenuConfiguration configuration,
  ) => safe('savePublicMenuConfiguration', () async {
    await _writeJson(_configurationKey, configuration.toJson());
    return configuration;
  });

  @override
  Future<Result<String>> preview(PublicMenuConfiguration configuration) =>
      safe('previewPublicMenu', () async {
        final snapshot = await _validatedSnapshot(configuration);
        return _remoteDataSource.createPreview(
          configuration: configuration,
          snapshot: snapshot,
        );
      });

  @override
  Future<Result<MenuPublication>> publish(
    PublicMenuConfiguration configuration,
  ) => safe('publishPublicMenu', () async {
    final snapshotAndHash = await _buildSnapshot(configuration);
    final snapshot = snapshotAndHash.$1;
    if (!configuration.canPublish) {
      throw const PublicMenuValidationException(
        'Choose a template and enter a menu title before publishing.',
      );
    }
    if (!snapshot.hasVisibleItems) {
      throw const PublicMenuValidationException(
        'Add an active product in an enabled category or an enabled combo first.',
      );
    }

    final existing = await _readPublication();
    final publication = existing == null
        ? await _createPublication(configuration, snapshot, snapshotAndHash.$2)
        : await _updatePublication(
            existing,
            configuration,
            snapshot,
            snapshotAndHash.$2,
          );
    await _writeJson(_publicationKey, publication.toJson());
    await _writeJson(_configurationKey, configuration.toJson());
    return publication;
  });

  @override
  Future<Result<void>> unpublish() => safe('unpublishPublicMenu', () async {
    final publication = await _readPublication();
    if (publication == null) return;
    final capability = await _secureStorage.read(
      key: _capabilityKey(publication.remoteMenuId),
    );
    if (capability == null) {
      throw const PublicMenuValidationException(
        'This device no longer has the owner capability needed to unpublish this menu.',
      );
    }
    await _remoteDataSource.deleteMenu(
      menuId: publication.remoteMenuId,
      ownerCapability: capability,
    );
    await _settingsRepository.deleteSetting(_publicationKey).unwrapAsync();
    await _secureStorage.delete(key: _capabilityKey(publication.remoteMenuId));
  });

  Future<MenuPublication> _createPublication(
    PublicMenuConfiguration configuration,
    PublicMenuSnapshot snapshot,
    String snapshotHash,
  ) async {
    final capability = _newCapability();
    final publication = await _remoteDataSource.createMenu(
      configuration: configuration,
      snapshot: snapshot,
      ownerCapability: capability,
      snapshotHash: snapshotHash,
    );
    // Persist the secret only after creation succeeds, and never include it in
    // repository logging, settings, payload metadata, URLs, or share text.
    await _secureStorage.write(
      key: _capabilityKey(publication.remoteMenuId),
      value: capability,
    );
    return publication;
  }

  Future<MenuPublication> _updatePublication(
    MenuPublication existing,
    PublicMenuConfiguration configuration,
    PublicMenuSnapshot snapshot,
    String snapshotHash,
  ) async {
    final capability = await _secureStorage.read(
      key: _capabilityKey(existing.remoteMenuId),
    );
    if (capability == null) {
      throw const PublicMenuValidationException(
        'This device no longer has the owner capability needed to update this menu.',
      );
    }
    return _remoteDataSource.updateMenu(
      publication: existing,
      configuration: configuration,
      snapshot: snapshot,
      ownerCapability: capability,
      snapshotHash: snapshotHash,
    );
  }

  Future<PublicMenuSnapshot> _validatedSnapshot(
    PublicMenuConfiguration configuration,
  ) async {
    if (!configuration.canPublish) {
      throw const PublicMenuValidationException(
        'Choose a template and enter a menu title before previewing.',
      );
    }
    final snapshot = (await _buildSnapshot(configuration)).$1;
    if (!snapshot.hasVisibleItems) {
      throw const PublicMenuValidationException(
        'Add an active product in an enabled category or an enabled combo first.',
      );
    }
    return snapshot;
  }

  Future<(PublicMenuSnapshot, String)> _buildSnapshot(
    PublicMenuConfiguration configuration,
  ) async {
    final results = await Future.wait([
      _categoriesRepository.watchAllCategories().first,
      _productsRepository.watchAllProducts().first,
      _combosRepository.watchAllCombos().first,
    ]);
    final snapshot = _snapshotBuilder.build(
      configuration: configuration,
      categories: results[0] as dynamic,
      products: results[1] as dynamic,
      combos: results[2] as dynamic,
    );
    return (
      snapshot,
      sha256.convert(utf8.encode(snapshot.canonicalJson)).toString(),
    );
  }

  Future<PublicMenuConfiguration> _readConfiguration() async {
    final data = await _readJson(_configurationKey);
    if (data is Map<String, dynamic>) {
      return PublicMenuConfiguration.fromJson(data);
    }
    final businessName = await _settingsRepository
        .getString(_businessNameKey)
        .unwrapAsync();
    return PublicMenuConfiguration(title: businessName?.trim() ?? '');
  }

  Future<MenuPublication?> _readPublication() async {
    final data = await _readJson(_publicationKey);
    return data is Map<String, dynamic> ? MenuPublication.fromJson(data) : null;
  }

  Future<List<MenuTemplate>> _readCachedTemplates() async {
    final data = await _readJson(_templateManifestKey);
    if (data is! List<dynamic>) return const [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(MenuTemplate.fromJson)
        .toList(growable: false);
  }

  Future<Object?> _readJson(String key) async {
    final raw = await _settingsRepository.getString(key).unwrapAsync();
    if (raw == null || raw.isEmpty) return null;
    try {
      return jsonDecode(raw);
    } on FormatException {
      logger?.warning('[PublicMenu] Ignoring corrupt local $key value');
      return null;
    }
  }

  Future<void> _writeJson(String key, Object data) async {
    await _settingsRepository.setString(key, jsonEncode(data)).unwrapAsync();
  }

  String _newCapability() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64UrlEncode(bytes).replaceAll('=', '');
  }

  String _capabilityKey(String menuId) => '$_capabilityKeyPrefix$menuId';
}

class PublicMenuValidationException implements Exception {
  const PublicMenuValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}
