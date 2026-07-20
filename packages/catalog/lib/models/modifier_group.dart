import 'package:catalog/models/modifier_option.dart';
import 'package:bloc_exports/bloc_exports.dart';

part 'modifier_group.freezed.dart';
part 'modifier_group.g.dart';

@freezed
abstract class ModifierGroup with _$ModifierGroup {
  const factory ModifierGroup({
    required int id,
    required String name, // e.g., "Milk Option"
    required bool isMultiSelect,
    @Default([]) List<ModifierOption> options,
  }) = _ModifierGroup;

  factory ModifierGroup.fromJson(Map<String, dynamic> json) =>
      _$ModifierGroupFromJson(json);

  const ModifierGroup._();
}
