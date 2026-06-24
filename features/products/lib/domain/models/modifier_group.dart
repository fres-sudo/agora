import 'package:feature_products/domain/models/modifier_option.dart';
import 'package:bloc_exports/bloc_exports.dart';

part 'modifier_group.freezed.dart';

@freezed
abstract class ModifierGroup with _$ModifierGroup {
  const factory ModifierGroup({
    required int id,
    required String name, // e.g., "Milk Option"
    required bool isMultiSelect,
    @Default([]) List<ModifierOption> options,
  }) = _ModifierGroup;

  const ModifierGroup._();
}
