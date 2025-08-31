part of 'pin_bloc.dart';

@freezed
sealed class PinEvent with _$PinEvent {
  const factory PinEvent.set({required String pin}) = SetPinEvent;

  const factory PinEvent.validate({required String pin}) = ValidatePinEvent;

  const factory PinEvent.change({
    required String oldPin,
    required String newPin,
  }) = ChangePinEvent;
}
