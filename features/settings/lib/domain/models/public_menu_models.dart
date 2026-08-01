import 'dart:convert';

/// A server-owned presentation template. Its HTML is never downloaded or run
/// by the app; only the renderer receives this identifier and version.
class MenuTemplate {
  const MenuTemplate({
    required this.id,
    required this.version,
    required this.name,
    required this.description,
    required this.thumbnailUrl,
    required this.options,
  });

  final String id;
  final int version;
  final String name;
  final String description;
  final String? thumbnailUrl;
  final List<String> options;

  factory MenuTemplate.fromJson(Map<String, dynamic> json) => MenuTemplate(
    id: json['id'] as String,
    version: (json['version'] as num).toInt(),
    name: json['name'] as String,
    description: json['description'] as String? ?? '',
    thumbnailUrl: json['thumbnailUrl'] as String?,
    options: (json['options'] as List<dynamic>? ?? const [])
        .whereType<String>()
        .toList(growable: false),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'version': version,
    'name': name,
    'description': description,
    if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
    'options': options,
  };
}

/// Presentation choices that belong specifically to a published menu rather
/// than to the POS store profile.
class PublicMenuConfiguration {
  const PublicMenuConfiguration({
    required this.title,
    this.subtitle = '',
    this.disclaimer = '',
    this.templateId,
    this.templateVersion,
    this.showDescriptions = true,
    this.showCategoryIcons = true,
  });

  final String title;
  final String subtitle;
  final String disclaimer;
  final String? templateId;
  final int? templateVersion;
  final bool showDescriptions;
  final bool showCategoryIcons;

  bool get canPublish =>
      title.trim().isNotEmpty && templateId != null && templateVersion != null;

  PublicMenuConfiguration copyWith({
    String? title,
    String? subtitle,
    String? disclaimer,
    String? templateId,
    int? templateVersion,
    bool? showDescriptions,
    bool? showCategoryIcons,
    bool clearTemplate = false,
  }) => PublicMenuConfiguration(
    title: title ?? this.title,
    subtitle: subtitle ?? this.subtitle,
    disclaimer: disclaimer ?? this.disclaimer,
    templateId: clearTemplate ? null : templateId ?? this.templateId,
    templateVersion: clearTemplate
        ? null
        : templateVersion ?? this.templateVersion,
    showDescriptions: showDescriptions ?? this.showDescriptions,
    showCategoryIcons: showCategoryIcons ?? this.showCategoryIcons,
  );

  factory PublicMenuConfiguration.fromJson(Map<String, dynamic> json) =>
      PublicMenuConfiguration(
        title: json['title'] as String? ?? '',
        subtitle: json['subtitle'] as String? ?? '',
        disclaimer: json['disclaimer'] as String? ?? '',
        templateId: json['templateId'] as String?,
        templateVersion: (json['templateVersion'] as num?)?.toInt(),
        showDescriptions: json['showDescriptions'] as bool? ?? true,
        showCategoryIcons: json['showCategoryIcons'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
    'title': title,
    'subtitle': subtitle,
    'disclaimer': disclaimer,
    'templateId': templateId,
    'templateVersion': templateVersion,
    'showDescriptions': showDescriptions,
    'showCategoryIcons': showCategoryIcons,
  };
}

/// Non-secret local metadata about the one currently published public menu.
/// The corresponding owner capability deliberately lives only in secure
/// storage, keyed by [remoteMenuId].
class MenuPublication {
  const MenuPublication({
    required this.remoteMenuId,
    required this.publicUrl,
    required this.templateId,
    required this.templateVersion,
    required this.snapshotHash,
    required this.publishedAt,
  });

  final String remoteMenuId;
  final String publicUrl;
  final String templateId;
  final int templateVersion;
  final String snapshotHash;
  final DateTime publishedAt;

  factory MenuPublication.fromJson(Map<String, dynamic> json) =>
      MenuPublication(
        remoteMenuId: json['menuId'] as String,
        publicUrl: json['publicUrl'] as String,
        templateId: json['templateId'] as String,
        templateVersion: (json['templateVersion'] as num).toInt(),
        snapshotHash: json['snapshotHash'] as String,
        publishedAt: DateTime.parse(json['publishedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
    'menuId': remoteMenuId,
    'publicUrl': publicUrl,
    'templateId': templateId,
    'templateVersion': templateVersion,
    'snapshotHash': snapshotHash,
    'publishedAt': publishedAt.toUtc().toIso8601String(),
  };
}

/// Explicit, privacy-safe wire model. It intentionally has no SKU, cost,
/// stock, tax, station, modifier, image-path, or order information.
class PublicMenuSnapshot {
  const PublicMenuSnapshot({
    required this.menu,
    required this.categories,
    required this.combos,
  });

  final Map<String, dynamic> menu;
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> combos;

  bool get hasVisibleItems =>
      categories.any((category) => (category['items'] as List).isNotEmpty) ||
      combos.isNotEmpty;

  Map<String, dynamic> toJson() => {
    'schemaVersion': 1,
    'menu': menu,
    'categories': categories,
    'combos': combos,
  };

  /// Stable encoded representation used only for change detection. The source
  /// lists are sorted by the builder, so ordinary reordering does not force an
  /// unnecessary republish.
  String get canonicalJson => jsonEncode(toJson());
}

class PublicMenuData {
  const PublicMenuData({
    required this.configuration,
    required this.templates,
    required this.publication,
    required this.hasUpdate,
  });

  final PublicMenuConfiguration configuration;
  final List<MenuTemplate> templates;
  final MenuPublication? publication;
  final bool hasUpdate;
}
