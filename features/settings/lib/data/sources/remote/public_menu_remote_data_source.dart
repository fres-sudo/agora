import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:feature_settings/domain/models/public_menu_models.dart';

class PublicMenuRemoteDataSource {
  PublicMenuRemoteDataSource({required Dio dio, required String baseUrl})
    : _dio = dio,
      _baseUrl = baseUrl.replaceFirst(RegExp(r'/+$'), '');

  final Dio _dio;
  final String _baseUrl;

  void _ensureConfigured() {
    if (_baseUrl.isEmpty) {
      throw PublicMenuRemoteException(
        'Public menu publishing is not configured for this build.',
      );
    }
  }

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  Future<List<MenuTemplate>> getTemplates() async {
    _ensureConfigured();
    try {
      final response = await _dio.getUri(_uri('/v1/menu-templates'));
      final body = response.data;
      final templates = body is Map<String, dynamic>
          ? body['templates'] as List<dynamic>? ?? const []
          : body as List<dynamic>;
      return templates
          .whereType<Map<String, dynamic>>()
          .map(MenuTemplate.fromJson)
          .toList(growable: false);
    } on DioException catch (error) {
      throw PublicMenuRemoteException.fromDio(error);
    }
  }

  Future<String> createPreview({
    required PublicMenuConfiguration configuration,
    required PublicMenuSnapshot snapshot,
  }) async {
    _ensureConfigured();
    try {
      final response = await _dio.postUri(
        _uri('/v1/menu-previews'),
        data: _publicationBody(configuration, snapshot),
      );
      final data = _map(response.data);
      final url = data['previewUrl'] as String? ?? data['url'] as String?;
      if (url == null || Uri.tryParse(url)?.hasScheme != true) {
        throw const PublicMenuRemoteException('Invalid preview response.');
      }
      return url;
    } on DioException catch (error) {
      throw PublicMenuRemoteException.fromDio(error);
    }
  }

  Future<MenuPublication> createMenu({
    required PublicMenuConfiguration configuration,
    required PublicMenuSnapshot snapshot,
    required String ownerCapability,
    required String snapshotHash,
  }) async {
    _ensureConfigured();
    try {
      final response = await _dio.postUri(
        _uri('/v1/menus'),
        data: _publicationBody(configuration, snapshot),
        options: Options(headers: _authorization(ownerCapability)),
      );
      return _publicationFromResponse(
        _map(response.data),
        configuration: configuration,
        snapshotHash: snapshotHash,
      );
    } on DioException catch (error) {
      throw PublicMenuRemoteException.fromDio(error);
    }
  }

  Future<MenuPublication> updateMenu({
    required MenuPublication publication,
    required PublicMenuConfiguration configuration,
    required PublicMenuSnapshot snapshot,
    required String ownerCapability,
    required String snapshotHash,
  }) async {
    _ensureConfigured();
    try {
      final response = await _dio.putUri(
        _uri('/v1/menus/${Uri.encodeComponent(publication.remoteMenuId)}'),
        data: _publicationBody(configuration, snapshot),
        options: Options(headers: _authorization(ownerCapability)),
      );
      return _publicationFromResponse(
        _map(response.data),
        configuration: configuration,
        snapshotHash: snapshotHash,
        fallbackMenuId: publication.remoteMenuId,
        fallbackPublicUrl: publication.publicUrl,
      );
    } on DioException catch (error) {
      throw PublicMenuRemoteException.fromDio(error);
    }
  }

  Future<void> deleteMenu({
    required String menuId,
    required String ownerCapability,
  }) async {
    _ensureConfigured();
    try {
      await _dio.deleteUri(
        _uri('/v1/menus/${Uri.encodeComponent(menuId)}'),
        options: Options(headers: _authorization(ownerCapability)),
      );
    } on DioException catch (error) {
      throw PublicMenuRemoteException.fromDio(error);
    }
  }

  Map<String, dynamic> _publicationBody(
    PublicMenuConfiguration configuration,
    PublicMenuSnapshot snapshot,
  ) => {
    'templateId': configuration.templateId,
    'templateVersion': configuration.templateVersion,
    'snapshot': snapshot.toJson(),
  };

  Map<String, String> _authorization(String capability) => {
    'Authorization': 'Bearer $capability',
  };

  Map<String, dynamic> _map(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is String) {
      final decoded = jsonDecode(value);
      if (decoded is Map<String, dynamic>) return decoded;
    }
    throw const PublicMenuRemoteException('Unexpected server response.');
  }

  MenuPublication _publicationFromResponse(
    Map<String, dynamic> data, {
    required PublicMenuConfiguration configuration,
    required String snapshotHash,
    String? fallbackMenuId,
    String? fallbackPublicUrl,
  }) {
    final menuId = data['menuId'] as String? ?? fallbackMenuId;
    final publicUrl = data['publicUrl'] as String? ?? fallbackPublicUrl;
    if (menuId == null || publicUrl == null) {
      throw const PublicMenuRemoteException('Invalid publication response.');
    }
    return MenuPublication(
      remoteMenuId: menuId,
      publicUrl: publicUrl,
      templateId: configuration.templateId!,
      templateVersion: configuration.templateVersion!,
      snapshotHash: snapshotHash,
      publishedAt:
          DateTime.tryParse(data['publishedAt'] as String? ?? '') ??
          DateTime.now().toUtc(),
    );
  }
}

class PublicMenuRemoteException implements Exception {
  const PublicMenuRemoteException(this.message);

  final String message;

  factory PublicMenuRemoteException.fromDio(DioException error) {
    final data = error.response?.data;
    final message = data is Map<String, dynamic>
        ? data['message'] as String? ?? data['error'] as String?
        : null;
    return PublicMenuRemoteException(
      message ??
          'Could not reach the public menu service. Check your connection.',
    );
  }

  @override
  String toString() => message;
}
