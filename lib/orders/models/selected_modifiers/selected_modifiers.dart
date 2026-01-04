import 'package:freezed_annotation/freezed_annotation.dart';

part 'selected_modifiers.freezed.dart';

@freezed
abstract class SelectedModifiers with _$SelectedModifiers {
  const factory SelectedModifiers({
    required String groupName, // e.g., "Size"
    required String optionName, // e.g., "Large"
    required int priceChangeCents,
  }) = _SelectedModifiers;

  const SelectedModifiers._();
}
