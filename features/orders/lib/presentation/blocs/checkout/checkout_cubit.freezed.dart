// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CheckoutState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CheckoutState()';
}


}

/// @nodoc
class $CheckoutStateCopyWith<$Res>  {
$CheckoutStateCopyWith(CheckoutState _, $Res Function(CheckoutState) __);
}


/// Adds pattern-matching-related methods to [CheckoutState].
extension CheckoutStatePatterns on CheckoutState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( CheckoutSelecting value)?  selecting,TResult Function( _Processing value)?  processing,TResult Function( CheckoutSuccess value)?  success,TResult Function( _Failure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case CheckoutSelecting() when selecting != null:
return selecting(_that);case _Processing() when processing != null:
return processing(_that);case CheckoutSuccess() when success != null:
return success(_that);case _Failure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( CheckoutSelecting value)  selecting,required TResult Function( _Processing value)  processing,required TResult Function( CheckoutSuccess value)  success,required TResult Function( _Failure value)  failure,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case CheckoutSelecting():
return selecting(_that);case _Processing():
return processing(_that);case CheckoutSuccess():
return success(_that);case _Failure():
return failure(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( CheckoutSelecting value)?  selecting,TResult? Function( _Processing value)?  processing,TResult? Function( CheckoutSuccess value)?  success,TResult? Function( _Failure value)?  failure,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case CheckoutSelecting() when selecting != null:
return selecting(_that);case _Processing() when processing != null:
return processing(_that);case CheckoutSuccess() when success != null:
return success(_that);case _Failure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( Order order,  PaymentMethod method,  int tenderedCents)?  selecting,TResult Function( Order order,  PaymentMethod method,  int tenderedCents)?  processing,TResult Function( Order order,  PaymentMethod method,  int tenderedCents,  Receipt? receipt,  PrintStatus printStatus)?  success,TResult Function( String message,  Order order,  PaymentMethod method,  int tenderedCents)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case CheckoutSelecting() when selecting != null:
return selecting(_that.order,_that.method,_that.tenderedCents);case _Processing() when processing != null:
return processing(_that.order,_that.method,_that.tenderedCents);case CheckoutSuccess() when success != null:
return success(_that.order,_that.method,_that.tenderedCents,_that.receipt,_that.printStatus);case _Failure() when failure != null:
return failure(_that.message,_that.order,_that.method,_that.tenderedCents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( Order order,  PaymentMethod method,  int tenderedCents)  selecting,required TResult Function( Order order,  PaymentMethod method,  int tenderedCents)  processing,required TResult Function( Order order,  PaymentMethod method,  int tenderedCents,  Receipt? receipt,  PrintStatus printStatus)  success,required TResult Function( String message,  Order order,  PaymentMethod method,  int tenderedCents)  failure,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case CheckoutSelecting():
return selecting(_that.order,_that.method,_that.tenderedCents);case _Processing():
return processing(_that.order,_that.method,_that.tenderedCents);case CheckoutSuccess():
return success(_that.order,_that.method,_that.tenderedCents,_that.receipt,_that.printStatus);case _Failure():
return failure(_that.message,_that.order,_that.method,_that.tenderedCents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( Order order,  PaymentMethod method,  int tenderedCents)?  selecting,TResult? Function( Order order,  PaymentMethod method,  int tenderedCents)?  processing,TResult? Function( Order order,  PaymentMethod method,  int tenderedCents,  Receipt? receipt,  PrintStatus printStatus)?  success,TResult? Function( String message,  Order order,  PaymentMethod method,  int tenderedCents)?  failure,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case CheckoutSelecting() when selecting != null:
return selecting(_that.order,_that.method,_that.tenderedCents);case _Processing() when processing != null:
return processing(_that.order,_that.method,_that.tenderedCents);case CheckoutSuccess() when success != null:
return success(_that.order,_that.method,_that.tenderedCents,_that.receipt,_that.printStatus);case _Failure() when failure != null:
return failure(_that.message,_that.order,_that.method,_that.tenderedCents);case _:
  return null;

}
}

}

/// @nodoc


class _Initial extends CheckoutState {
  const _Initial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CheckoutState.initial()';
}


}




/// @nodoc


class CheckoutSelecting extends CheckoutState {
  const CheckoutSelecting({required this.order, required this.method, this.tenderedCents = 0}): super._();
  

 final  Order order;
 final  PaymentMethod method;
@JsonKey() final  int tenderedCents;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutSelectingCopyWith<CheckoutSelecting> get copyWith => _$CheckoutSelectingCopyWithImpl<CheckoutSelecting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutSelecting&&(identical(other.order, order) || other.order == order)&&(identical(other.method, method) || other.method == method)&&(identical(other.tenderedCents, tenderedCents) || other.tenderedCents == tenderedCents));
}


@override
int get hashCode => Object.hash(runtimeType,order,method,tenderedCents);

@override
String toString() {
  return 'CheckoutState.selecting(order: $order, method: $method, tenderedCents: $tenderedCents)';
}


}

/// @nodoc
abstract mixin class $CheckoutSelectingCopyWith<$Res> implements $CheckoutStateCopyWith<$Res> {
  factory $CheckoutSelectingCopyWith(CheckoutSelecting value, $Res Function(CheckoutSelecting) _then) = _$CheckoutSelectingCopyWithImpl;
@useResult
$Res call({
 Order order, PaymentMethod method, int tenderedCents
});


$OrderCopyWith<$Res> get order;

}
/// @nodoc
class _$CheckoutSelectingCopyWithImpl<$Res>
    implements $CheckoutSelectingCopyWith<$Res> {
  _$CheckoutSelectingCopyWithImpl(this._self, this._then);

  final CheckoutSelecting _self;
  final $Res Function(CheckoutSelecting) _then;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? order = null,Object? method = null,Object? tenderedCents = null,}) {
  return _then(CheckoutSelecting(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as Order,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,tenderedCents: null == tenderedCents ? _self.tenderedCents : tenderedCents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderCopyWith<$Res> get order {
  
  return $OrderCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}
}

/// @nodoc


class _Processing extends CheckoutState {
  const _Processing({required this.order, required this.method, this.tenderedCents = 0}): super._();
  

 final  Order order;
 final  PaymentMethod method;
@JsonKey() final  int tenderedCents;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProcessingCopyWith<_Processing> get copyWith => __$ProcessingCopyWithImpl<_Processing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Processing&&(identical(other.order, order) || other.order == order)&&(identical(other.method, method) || other.method == method)&&(identical(other.tenderedCents, tenderedCents) || other.tenderedCents == tenderedCents));
}


@override
int get hashCode => Object.hash(runtimeType,order,method,tenderedCents);

@override
String toString() {
  return 'CheckoutState.processing(order: $order, method: $method, tenderedCents: $tenderedCents)';
}


}

/// @nodoc
abstract mixin class _$ProcessingCopyWith<$Res> implements $CheckoutStateCopyWith<$Res> {
  factory _$ProcessingCopyWith(_Processing value, $Res Function(_Processing) _then) = __$ProcessingCopyWithImpl;
@useResult
$Res call({
 Order order, PaymentMethod method, int tenderedCents
});


$OrderCopyWith<$Res> get order;

}
/// @nodoc
class __$ProcessingCopyWithImpl<$Res>
    implements _$ProcessingCopyWith<$Res> {
  __$ProcessingCopyWithImpl(this._self, this._then);

  final _Processing _self;
  final $Res Function(_Processing) _then;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? order = null,Object? method = null,Object? tenderedCents = null,}) {
  return _then(_Processing(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as Order,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,tenderedCents: null == tenderedCents ? _self.tenderedCents : tenderedCents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderCopyWith<$Res> get order {
  
  return $OrderCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}
}

/// @nodoc


class CheckoutSuccess extends CheckoutState {
  const CheckoutSuccess({required this.order, required this.method, this.tenderedCents = 0, this.receipt, this.printStatus = PrintStatus.idle}): super._();
  

 final  Order order;
 final  PaymentMethod method;
@JsonKey() final  int tenderedCents;
 final  Receipt? receipt;
@JsonKey() final  PrintStatus printStatus;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckoutSuccessCopyWith<CheckoutSuccess> get copyWith => _$CheckoutSuccessCopyWithImpl<CheckoutSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutSuccess&&(identical(other.order, order) || other.order == order)&&(identical(other.method, method) || other.method == method)&&(identical(other.tenderedCents, tenderedCents) || other.tenderedCents == tenderedCents)&&(identical(other.receipt, receipt) || other.receipt == receipt)&&(identical(other.printStatus, printStatus) || other.printStatus == printStatus));
}


@override
int get hashCode => Object.hash(runtimeType,order,method,tenderedCents,receipt,printStatus);

@override
String toString() {
  return 'CheckoutState.success(order: $order, method: $method, tenderedCents: $tenderedCents, receipt: $receipt, printStatus: $printStatus)';
}


}

/// @nodoc
abstract mixin class $CheckoutSuccessCopyWith<$Res> implements $CheckoutStateCopyWith<$Res> {
  factory $CheckoutSuccessCopyWith(CheckoutSuccess value, $Res Function(CheckoutSuccess) _then) = _$CheckoutSuccessCopyWithImpl;
@useResult
$Res call({
 Order order, PaymentMethod method, int tenderedCents, Receipt? receipt, PrintStatus printStatus
});


$OrderCopyWith<$Res> get order;

}
/// @nodoc
class _$CheckoutSuccessCopyWithImpl<$Res>
    implements $CheckoutSuccessCopyWith<$Res> {
  _$CheckoutSuccessCopyWithImpl(this._self, this._then);

  final CheckoutSuccess _self;
  final $Res Function(CheckoutSuccess) _then;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? order = null,Object? method = null,Object? tenderedCents = null,Object? receipt = freezed,Object? printStatus = null,}) {
  return _then(CheckoutSuccess(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as Order,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,tenderedCents: null == tenderedCents ? _self.tenderedCents : tenderedCents // ignore: cast_nullable_to_non_nullable
as int,receipt: freezed == receipt ? _self.receipt : receipt // ignore: cast_nullable_to_non_nullable
as Receipt?,printStatus: null == printStatus ? _self.printStatus : printStatus // ignore: cast_nullable_to_non_nullable
as PrintStatus,
  ));
}

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderCopyWith<$Res> get order {
  
  return $OrderCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}
}

/// @nodoc


class _Failure extends CheckoutState {
  const _Failure({required this.message, required this.order, required this.method, this.tenderedCents = 0}): super._();
  

 final  String message;
 final  Order order;
 final  PaymentMethod method;
@JsonKey() final  int tenderedCents;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FailureCopyWith<_Failure> get copyWith => __$FailureCopyWithImpl<_Failure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Failure&&(identical(other.message, message) || other.message == message)&&(identical(other.order, order) || other.order == order)&&(identical(other.method, method) || other.method == method)&&(identical(other.tenderedCents, tenderedCents) || other.tenderedCents == tenderedCents));
}


@override
int get hashCode => Object.hash(runtimeType,message,order,method,tenderedCents);

@override
String toString() {
  return 'CheckoutState.failure(message: $message, order: $order, method: $method, tenderedCents: $tenderedCents)';
}


}

/// @nodoc
abstract mixin class _$FailureCopyWith<$Res> implements $CheckoutStateCopyWith<$Res> {
  factory _$FailureCopyWith(_Failure value, $Res Function(_Failure) _then) = __$FailureCopyWithImpl;
@useResult
$Res call({
 String message, Order order, PaymentMethod method, int tenderedCents
});


$OrderCopyWith<$Res> get order;

}
/// @nodoc
class __$FailureCopyWithImpl<$Res>
    implements _$FailureCopyWith<$Res> {
  __$FailureCopyWithImpl(this._self, this._then);

  final _Failure _self;
  final $Res Function(_Failure) _then;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? order = null,Object? method = null,Object? tenderedCents = null,}) {
  return _then(_Failure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as Order,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod,tenderedCents: null == tenderedCents ? _self.tenderedCents : tenderedCents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderCopyWith<$Res> get order {
  
  return $OrderCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}
}

// dart format on
