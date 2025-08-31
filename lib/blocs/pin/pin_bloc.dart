import 'package:agora/services/storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:async';
import 'package:flutter/material.dart';

part 'pin_event.dart';

part 'pin_state.dart';

part 'pin_bloc.freezed.dart';

/// The PinBloc
class PinBloc extends Bloc<PinEvent, PinState> {
  final StorageService storageService;

  /// Create a new instance of [PinBloc].
  PinBloc({required this.storageService}) : super(const PinState.setted()) {
    on<SetPinEvent>(_onSet);
    on<ValidatePinEvent>(_onValidate);
    on<ChangePinEvent>(_onChange);
  }

  /// Method used to add the [SetPinEvent] event
  void set({required String pin}) => add(PinEvent.set(pin: pin));

  /// Method used to add the [ValidatePinEvent] event
  void validate({required String pin}) => add(PinEvent.validate(pin: pin));

  /// Method used to add the [ChangePinEvent] event
  void change({required String oldPin, required String newPin}) =>
      add(PinEvent.change(oldPin: oldPin, newPin: newPin));

  FutureOr<void> _onSet(SetPinEvent event, Emitter<PinState> emit) async {
    try {
      await storageService.setPin(event.pin);
      emit(PinState.setted());
    } catch (e) {
      emit(PinState.error());
    }
  }

  FutureOr<void> _onValidate(
    ValidatePinEvent event,
    Emitter<PinState> emit,
  ) async {
    final isValidPin = await _validatePin(event.pin);
    emit(isValidPin ? PinState.valid() : PinState.invalid());
  }

  FutureOr<void> _onChange(ChangePinEvent event, Emitter<PinState> emit) async {
    try {
      final isValidPin = await _validatePin(event.oldPin);
      if (!isValidPin) {
        emit(PinState.error());
        return;
      }
      await storageService.setPin(event.newPin);
      emit(PinState.changed());
    } catch (e) {
      emit(PinState.error());
    }
  }

  Future<bool> _validatePin(String pin) async {
    try {
      final extPin = await storageService.getPin();
      return extPin == pin;
    } catch (e) {
      rethrow;
    }
  }
}

extension PinBlocExtension on BuildContext {
  /// Extension method used to get the [PinBloc] instance
  PinBloc get pinBloc => read<PinBloc>();

  /// Extension method used to watch the [PinBloc] instance
  PinBloc get watchPinBloc => watch<PinBloc>();
}
