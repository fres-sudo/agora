// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderDetailState()';
}


}

/// @nodoc
class $OrderDetailStateCopyWith<$Res>  {
$OrderDetailStateCopyWith(OrderDetailState _, $Res Function(OrderDetailState) __);
}


/// Adds pattern-matching-related methods to [OrderDetailState].
extension OrderDetailStatePatterns on OrderDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( OrderDetailLoaded value)?  loaded,TResult Function( _Completing value)?  completing,TResult Function( _Voiding value)?  voiding,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case OrderDetailLoaded() when loaded != null:
return loaded(_that);case _Completing() when completing != null:
return completing(_that);case _Voiding() when voiding != null:
return voiding(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( OrderDetailLoaded value)  loaded,required TResult Function( _Completing value)  completing,required TResult Function( _Voiding value)  voiding,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case OrderDetailLoaded():
return loaded(_that);case _Completing():
return completing(_that);case _Voiding():
return voiding(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( OrderDetailLoaded value)?  loaded,TResult? Function( _Completing value)?  completing,TResult? Function( _Voiding value)?  voiding,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case OrderDetailLoaded() when loaded != null:
return loaded(_that);case _Completing() when completing != null:
return completing(_that);case _Voiding() when voiding != null:
return voiding(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( Order order)?  loaded,TResult Function( Order order)?  completing,TResult Function( Order order)?  voiding,TResult Function( String message,  Order? order)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case OrderDetailLoaded() when loaded != null:
return loaded(_that.order);case _Completing() when completing != null:
return completing(_that.order);case _Voiding() when voiding != null:
return voiding(_that.order);case _Error() when error != null:
return error(_that.message,_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( Order order)  loaded,required TResult Function( Order order)  completing,required TResult Function( Order order)  voiding,required TResult Function( String message,  Order? order)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case OrderDetailLoaded():
return loaded(_that.order);case _Completing():
return completing(_that.order);case _Voiding():
return voiding(_that.order);case _Error():
return error(_that.message,_that.order);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( Order order)?  loaded,TResult? Function( Order order)?  completing,TResult? Function( Order order)?  voiding,TResult? Function( String message,  Order? order)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case OrderDetailLoaded() when loaded != null:
return loaded(_that.order);case _Completing() when completing != null:
return completing(_that.order);case _Voiding() when voiding != null:
return voiding(_that.order);case _Error() when error != null:
return error(_that.message,_that.order);case _:
  return null;

}
}

}

/// @nodoc


class _Initial extends OrderDetailState {
  const _Initial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderDetailState.initial()';
}


}




/// @nodoc


class _Loading extends OrderDetailState {
  const _Loading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OrderDetailState.loading()';
}


}




/// @nodoc


class OrderDetailLoaded extends OrderDetailState {
  const OrderDetailLoaded({required this.order}): super._();
  

 final  Order order;

/// Create a copy of OrderDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderDetailLoadedCopyWith<OrderDetailLoaded> get copyWith => _$OrderDetailLoadedCopyWithImpl<OrderDetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderDetailLoaded&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,order);

@override
String toString() {
  return 'OrderDetailState.loaded(order: $order)';
}


}

/// @nodoc
abstract mixin class $OrderDetailLoadedCopyWith<$Res> implements $OrderDetailStateCopyWith<$Res> {
  factory $OrderDetailLoadedCopyWith(OrderDetailLoaded value, $Res Function(OrderDetailLoaded) _then) = _$OrderDetailLoadedCopyWithImpl;
@useResult
$Res call({
 Order order
});


$OrderCopyWith<$Res> get order;

}
/// @nodoc
class _$OrderDetailLoadedCopyWithImpl<$Res>
    implements $OrderDetailLoadedCopyWith<$Res> {
  _$OrderDetailLoadedCopyWithImpl(this._self, this._then);

  final OrderDetailLoaded _self;
  final $Res Function(OrderDetailLoaded) _then;

/// Create a copy of OrderDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? order = null,}) {
  return _then(OrderDetailLoaded(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as Order,
  ));
}

/// Create a copy of OrderDetailState
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


class _Completing extends OrderDetailState {
  const _Completing({required this.order}): super._();
  

 final  Order order;

/// Create a copy of OrderDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompletingCopyWith<_Completing> get copyWith => __$CompletingCopyWithImpl<_Completing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Completing&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,order);

@override
String toString() {
  return 'OrderDetailState.completing(order: $order)';
}


}

/// @nodoc
abstract mixin class _$CompletingCopyWith<$Res> implements $OrderDetailStateCopyWith<$Res> {
  factory _$CompletingCopyWith(_Completing value, $Res Function(_Completing) _then) = __$CompletingCopyWithImpl;
@useResult
$Res call({
 Order order
});


$OrderCopyWith<$Res> get order;

}
/// @nodoc
class __$CompletingCopyWithImpl<$Res>
    implements _$CompletingCopyWith<$Res> {
  __$CompletingCopyWithImpl(this._self, this._then);

  final _Completing _self;
  final $Res Function(_Completing) _then;

/// Create a copy of OrderDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? order = null,}) {
  return _then(_Completing(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as Order,
  ));
}

/// Create a copy of OrderDetailState
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


class _Voiding extends OrderDetailState {
  const _Voiding({required this.order}): super._();
  

 final  Order order;

/// Create a copy of OrderDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VoidingCopyWith<_Voiding> get copyWith => __$VoidingCopyWithImpl<_Voiding>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Voiding&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,order);

@override
String toString() {
  return 'OrderDetailState.voiding(order: $order)';
}


}

/// @nodoc
abstract mixin class _$VoidingCopyWith<$Res> implements $OrderDetailStateCopyWith<$Res> {
  factory _$VoidingCopyWith(_Voiding value, $Res Function(_Voiding) _then) = __$VoidingCopyWithImpl;
@useResult
$Res call({
 Order order
});


$OrderCopyWith<$Res> get order;

}
/// @nodoc
class __$VoidingCopyWithImpl<$Res>
    implements _$VoidingCopyWith<$Res> {
  __$VoidingCopyWithImpl(this._self, this._then);

  final _Voiding _self;
  final $Res Function(_Voiding) _then;

/// Create a copy of OrderDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? order = null,}) {
  return _then(_Voiding(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as Order,
  ));
}

/// Create a copy of OrderDetailState
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


class _Error extends OrderDetailState {
  const _Error({required this.message, this.order}): super._();
  

 final  String message;
 final  Order? order;

/// Create a copy of OrderDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message)&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,message,order);

@override
String toString() {
  return 'OrderDetailState.error(message: $message, order: $order)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $OrderDetailStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message, Order? order
});


$OrderCopyWith<$Res>? get order;

}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of OrderDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? order = freezed,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as Order?,
  ));
}

/// Create a copy of OrderDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderCopyWith<$Res>? get order {
    if (_self.order == null) {
    return null;
  }

  return $OrderCopyWith<$Res>(_self.order!, (value) {
    return _then(_self.copyWith(order: value));
  });
}
}

// dart format on
