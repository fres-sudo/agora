import 'package:feature_settings/domain/models/public_menu_models.dart';
import 'package:result/result.dart';

abstract interface class PublicMenuRepository {
  Future<Result<PublicMenuData>> load();
  Future<Result<List<MenuTemplate>>> refreshTemplates();
  Future<Result<PublicMenuConfiguration>> saveConfiguration(
    PublicMenuConfiguration configuration,
  );
  Future<Result<String>> preview(PublicMenuConfiguration configuration);
  Future<Result<MenuPublication>> publish(
    PublicMenuConfiguration configuration,
  );
  Future<Result<void>> unpublish();
}
