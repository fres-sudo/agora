// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discount_validation_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiscountValidationState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscountValidationState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DiscountValidationState()';
}


}

/// @nodoc
class $DiscountValidationStateCopyWith<$Res>  {
$DiscountValidationStateCopyWith(DiscountValidationState _, $Res Function(DiscountValidationState) __);
}


/// Adds pattern-matching-related methods to [DiscountValidationState].
extension DiscountValidationStatePatterns on DiscountValidationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Validating value)?  validating,TResult Function( DiscountValidationValid value)?  valid,TResult Function( _Invalid value)?  invalid,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Validating() when validating != null:
return validating(_that);case DiscountValidationValid() when valid != null:
return valid(_that);case _Invalid() when invalid != null:
return invalid(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Validating value)  validating,required TResult Function( DiscountValidationValid value)  valid,required TResult Function( _Invalid value)  invalid,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Validating():
return validating(_that);case DiscountValidationValid():
return valid(_that);case _Invalid():
return invalid(_that);case _Error():
return error(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Validating value)?  validating,TResult? Function( DiscountValidationValid value)?  valid,TResult? Function( _Invalid value)?  invalid,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Validating() when validating != null:
return validating(_that);case DiscountValidationValid() when valid != null:
return valid(_that);case _Invalid() when invalid != null:
return invalid(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  validating,TResult Function( Discount discount)?  valid,TResult Function( String reason)?  invalid,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Validating() when validating != null:
return validating();case DiscountValidationValid() when valid != null:
return valid(_that.discount);case _Invalid() when invalid != null:
return invalid(_that.reason);case _Error() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  validating,required TResult Function( Discount discount)  valid,required TResult Function( String reason)  invalid,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Validating():
return validating();case DiscountValidationValid():
return valid(_that.discount);case _Invalid():
return invalid(_that.reason);case _Error():
return error(_that.message);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  validating,TResult? Function( Discount discount)?  valid,TResult? Function( String reason)?  invalid,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Validating() when validating != null:
return validating();case DiscountValidationValid() when valid != null:
return valid(_that.discount);case _Invalid() when invalid != null:
return invalid(_that.reason);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial extends DiscountValidationState {
  const _Initial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DiscountValidationState.initial()';
}


}




/// @nodoc


class _Validating extends DiscountValidationState {
  const _Validating(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Validating);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DiscountValidationState.validating()';
}


}




/// @nodoc


class DiscountValidationValid extends DiscountValidationState {
  const DiscountValidationValid({required this.discount}): super._();
  

 final  Discount discount;

/// Create a copy of DiscountValidationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscountValidationValidCopyWith<DiscountValidationValid> get copyWith => _$DiscountValidationValidCopyWithImpl<DiscountValidationValid>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscountValidationValid&&(identical(other.discount, discount) || other.discount == discount));
}


@override
int get hashCode => Object.hash(runtimeType,discount);

@override
String toString() {
  return 'DiscountValidationState.valid(discount: $discount)';
}


}

/// @nodoc
abstract mixin class $DiscountValidationValidCopyWith<$Res> implements $DiscountValidationStateCopyWith<$Res> {
  factory $DiscountValidationValidCopyWith(DiscountValidationValid value, $Res Function(DiscountValidationValid) _then) = _$DiscountValidationValidCopyWithImpl;
@useResult
$Res call({
 Discount discount
});


$DiscountCopyWith<$Res> get discount;

}
/// @nodoc
class _$DiscountValidationValidCopyWithImpl<$Res>
    implements $DiscountValidationValidCopyWith<$Res> {
  _$DiscountValidationValidCopyWithImpl(this._self, this._then);

  final DiscountValidationValid _self;
  final $Res Function(DiscountValidationValid) _then;

/// Create a copy of DiscountValidationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? discount = null,}) {
  return _then(DiscountValidationValid(
discount: null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as Discount,
  ));
}

/// Create a copy of DiscountValidationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiscountCopyWith<$Res> get discount {
  
  return $DiscountCopyWith<$Res>(_self.discount, (value) {
    return _then(_self.copyWith(discount: value));
  });
}
}

/// @nodoc


class _Invalid extends DiscountValidationState {
  const _Invalid({required this.reason}): super._();
  

 final  String reason;

/// Create a copy of DiscountValidationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvalidCopyWith<_Invalid> get copyWith => __$InvalidCopyWithImpl<_Invalid>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Invalid&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'DiscountValidationState.invalid(reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$InvalidCopyWith<$Res> implements $DiscountValidationStateCopyWith<$Res> {
  factory _$InvalidCopyWith(_Invalid value, $Res Function(_Invalid) _then) = __$InvalidCopyWithImpl;
@useResult
$Res call({
 String reason
});




}
/// @nodoc
class __$InvalidCopyWithImpl<$Res>
    implements _$InvalidCopyWith<$Res> {
  __$InvalidCopyWithImpl(this._self, this._then);

  final _Invalid _self;
  final $Res Function(_Invalid) _then;

/// Create a copy of DiscountValidationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = null,}) {
  return _then(_Invalid(
reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Error extends DiscountValidationState {
  const _Error({required this.message}): super._();
  

 final  String message;

/// Create a copy of DiscountValidationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'DiscountValidationState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $DiscountValidationStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of DiscountValidationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
