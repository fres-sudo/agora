// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pin_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PinEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinEvent()';
}


}

/// @nodoc
class $PinEventCopyWith<$Res>  {
$PinEventCopyWith(PinEvent _, $Res Function(PinEvent) __);
}


/// Adds pattern-matching-related methods to [PinEvent].
extension PinEventPatterns on PinEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SetPinEvent value)?  set,TResult Function( ValidatePinEvent value)?  validate,TResult Function( ChangePinEvent value)?  change,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SetPinEvent() when set != null:
return set(_that);case ValidatePinEvent() when validate != null:
return validate(_that);case ChangePinEvent() when change != null:
return change(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SetPinEvent value)  set,required TResult Function( ValidatePinEvent value)  validate,required TResult Function( ChangePinEvent value)  change,}){
final _that = this;
switch (_that) {
case SetPinEvent():
return set(_that);case ValidatePinEvent():
return validate(_that);case ChangePinEvent():
return change(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SetPinEvent value)?  set,TResult? Function( ValidatePinEvent value)?  validate,TResult? Function( ChangePinEvent value)?  change,}){
final _that = this;
switch (_that) {
case SetPinEvent() when set != null:
return set(_that);case ValidatePinEvent() when validate != null:
return validate(_that);case ChangePinEvent() when change != null:
return change(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String pin)?  set,TResult Function( String pin)?  validate,TResult Function( String oldPin,  String newPin)?  change,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SetPinEvent() when set != null:
return set(_that.pin);case ValidatePinEvent() when validate != null:
return validate(_that.pin);case ChangePinEvent() when change != null:
return change(_that.oldPin,_that.newPin);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String pin)  set,required TResult Function( String pin)  validate,required TResult Function( String oldPin,  String newPin)  change,}) {final _that = this;
switch (_that) {
case SetPinEvent():
return set(_that.pin);case ValidatePinEvent():
return validate(_that.pin);case ChangePinEvent():
return change(_that.oldPin,_that.newPin);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String pin)?  set,TResult? Function( String pin)?  validate,TResult? Function( String oldPin,  String newPin)?  change,}) {final _that = this;
switch (_that) {
case SetPinEvent() when set != null:
return set(_that.pin);case ValidatePinEvent() when validate != null:
return validate(_that.pin);case ChangePinEvent() when change != null:
return change(_that.oldPin,_that.newPin);case _:
  return null;

}
}

}

/// @nodoc


class SetPinEvent implements PinEvent {
  const SetPinEvent({required this.pin});
  

 final  String pin;

/// Create a copy of PinEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetPinEventCopyWith<SetPinEvent> get copyWith => _$SetPinEventCopyWithImpl<SetPinEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetPinEvent&&(identical(other.pin, pin) || other.pin == pin));
}


@override
int get hashCode => Object.hash(runtimeType,pin);

@override
String toString() {
  return 'PinEvent.set(pin: $pin)';
}


}

/// @nodoc
abstract mixin class $SetPinEventCopyWith<$Res> implements $PinEventCopyWith<$Res> {
  factory $SetPinEventCopyWith(SetPinEvent value, $Res Function(SetPinEvent) _then) = _$SetPinEventCopyWithImpl;
@useResult
$Res call({
 String pin
});




}
/// @nodoc
class _$SetPinEventCopyWithImpl<$Res>
    implements $SetPinEventCopyWith<$Res> {
  _$SetPinEventCopyWithImpl(this._self, this._then);

  final SetPinEvent _self;
  final $Res Function(SetPinEvent) _then;

/// Create a copy of PinEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? pin = null,}) {
  return _then(SetPinEvent(
pin: null == pin ? _self.pin : pin // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ValidatePinEvent implements PinEvent {
  const ValidatePinEvent({required this.pin});
  

 final  String pin;

/// Create a copy of PinEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ValidatePinEventCopyWith<ValidatePinEvent> get copyWith => _$ValidatePinEventCopyWithImpl<ValidatePinEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ValidatePinEvent&&(identical(other.pin, pin) || other.pin == pin));
}


@override
int get hashCode => Object.hash(runtimeType,pin);

@override
String toString() {
  return 'PinEvent.validate(pin: $pin)';
}


}

/// @nodoc
abstract mixin class $ValidatePinEventCopyWith<$Res> implements $PinEventCopyWith<$Res> {
  factory $ValidatePinEventCopyWith(ValidatePinEvent value, $Res Function(ValidatePinEvent) _then) = _$ValidatePinEventCopyWithImpl;
@useResult
$Res call({
 String pin
});




}
/// @nodoc
class _$ValidatePinEventCopyWithImpl<$Res>
    implements $ValidatePinEventCopyWith<$Res> {
  _$ValidatePinEventCopyWithImpl(this._self, this._then);

  final ValidatePinEvent _self;
  final $Res Function(ValidatePinEvent) _then;

/// Create a copy of PinEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? pin = null,}) {
  return _then(ValidatePinEvent(
pin: null == pin ? _self.pin : pin // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ChangePinEvent implements PinEvent {
  const ChangePinEvent({required this.oldPin, required this.newPin});
  

 final  String oldPin;
 final  String newPin;

/// Create a copy of PinEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangePinEventCopyWith<ChangePinEvent> get copyWith => _$ChangePinEventCopyWithImpl<ChangePinEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangePinEvent&&(identical(other.oldPin, oldPin) || other.oldPin == oldPin)&&(identical(other.newPin, newPin) || other.newPin == newPin));
}


@override
int get hashCode => Object.hash(runtimeType,oldPin,newPin);

@override
String toString() {
  return 'PinEvent.change(oldPin: $oldPin, newPin: $newPin)';
}


}

/// @nodoc
abstract mixin class $ChangePinEventCopyWith<$Res> implements $PinEventCopyWith<$Res> {
  factory $ChangePinEventCopyWith(ChangePinEvent value, $Res Function(ChangePinEvent) _then) = _$ChangePinEventCopyWithImpl;
@useResult
$Res call({
 String oldPin, String newPin
});




}
/// @nodoc
class _$ChangePinEventCopyWithImpl<$Res>
    implements $ChangePinEventCopyWith<$Res> {
  _$ChangePinEventCopyWithImpl(this._self, this._then);

  final ChangePinEvent _self;
  final $Res Function(ChangePinEvent) _then;

/// Create a copy of PinEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? oldPin = null,Object? newPin = null,}) {
  return _then(ChangePinEvent(
oldPin: null == oldPin ? _self.oldPin : oldPin // ignore: cast_nullable_to_non_nullable
as String,newPin: null == newPin ? _self.newPin : newPin // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$PinState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinState()';
}


}

/// @nodoc
class $PinStateCopyWith<$Res>  {
$PinStateCopyWith(PinState _, $Res Function(PinState) __);
}


/// Adds pattern-matching-related methods to [PinState].
extension PinStatePatterns on PinState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SettedPinState value)?  setted,TResult Function( ValidPinState value)?  valid,TResult Function( InvalidPinState value)?  invalid,TResult Function( ChangedPinState value)?  changed,TResult Function( ErrorPinState value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SettedPinState() when setted != null:
return setted(_that);case ValidPinState() when valid != null:
return valid(_that);case InvalidPinState() when invalid != null:
return invalid(_that);case ChangedPinState() when changed != null:
return changed(_that);case ErrorPinState() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SettedPinState value)  setted,required TResult Function( ValidPinState value)  valid,required TResult Function( InvalidPinState value)  invalid,required TResult Function( ChangedPinState value)  changed,required TResult Function( ErrorPinState value)  error,}){
final _that = this;
switch (_that) {
case SettedPinState():
return setted(_that);case ValidPinState():
return valid(_that);case InvalidPinState():
return invalid(_that);case ChangedPinState():
return changed(_that);case ErrorPinState():
return error(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SettedPinState value)?  setted,TResult? Function( ValidPinState value)?  valid,TResult? Function( InvalidPinState value)?  invalid,TResult? Function( ChangedPinState value)?  changed,TResult? Function( ErrorPinState value)?  error,}){
final _that = this;
switch (_that) {
case SettedPinState() when setted != null:
return setted(_that);case ValidPinState() when valid != null:
return valid(_that);case InvalidPinState() when invalid != null:
return invalid(_that);case ChangedPinState() when changed != null:
return changed(_that);case ErrorPinState() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  setted,TResult Function()?  valid,TResult Function()?  invalid,TResult Function()?  changed,TResult Function()?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SettedPinState() when setted != null:
return setted();case ValidPinState() when valid != null:
return valid();case InvalidPinState() when invalid != null:
return invalid();case ChangedPinState() when changed != null:
return changed();case ErrorPinState() when error != null:
return error();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  setted,required TResult Function()  valid,required TResult Function()  invalid,required TResult Function()  changed,required TResult Function()  error,}) {final _that = this;
switch (_that) {
case SettedPinState():
return setted();case ValidPinState():
return valid();case InvalidPinState():
return invalid();case ChangedPinState():
return changed();case ErrorPinState():
return error();}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  setted,TResult? Function()?  valid,TResult? Function()?  invalid,TResult? Function()?  changed,TResult? Function()?  error,}) {final _that = this;
switch (_that) {
case SettedPinState() when setted != null:
return setted();case ValidPinState() when valid != null:
return valid();case InvalidPinState() when invalid != null:
return invalid();case ChangedPinState() when changed != null:
return changed();case ErrorPinState() when error != null:
return error();case _:
  return null;

}
}

}

/// @nodoc


class SettedPinState implements PinState {
  const SettedPinState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettedPinState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinState.setted()';
}


}




/// @nodoc


class ValidPinState implements PinState {
  const ValidPinState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ValidPinState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinState.valid()';
}


}




/// @nodoc


class InvalidPinState implements PinState {
  const InvalidPinState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvalidPinState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinState.invalid()';
}


}




/// @nodoc


class ChangedPinState implements PinState {
  const ChangedPinState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangedPinState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinState.changed()';
}


}




/// @nodoc


class ErrorPinState implements PinState {
  const ErrorPinState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorPinState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinState.error()';
}


}




// dart format on
