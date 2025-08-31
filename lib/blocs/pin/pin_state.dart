part of 'pin_bloc.dart';

@freezed
sealed class PinState with _$PinState {
  
  const factory PinState.setted() = SettedPinState;
  
  const factory PinState.valid() = ValidPinState;
  
  const factory PinState.invalid() = InvalidPinState;
  
  const factory PinState.changed() = ChangedPinState;
  
  const factory PinState.error() = ErrorPinState;
  
}
