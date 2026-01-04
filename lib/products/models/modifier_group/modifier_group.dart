import 'package:agora/products/models/modifier_option/modifier_option.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
