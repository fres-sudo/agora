// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_adjustment_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StockAdjustmentState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockAdjustmentState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StockAdjustmentState()';
}


}

/// @nodoc
class $StockAdjustmentStateCopyWith<$Res>  {
$StockAdjustmentStateCopyWith(StockAdjustmentState _, $Res Function(StockAdjustmentState) __);
}


/// Adds pattern-matching-related methods to [StockAdjustmentState].
extension StockAdjustmentStatePatterns on StockAdjustmentState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Adjusting value)?  adjusting,TResult Function( _Adjusted value)?  adjusted,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Adjusting() when adjusting != null:
return adjusting(_that);case _Adjusted() when adjusted != null:
return adjusted(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Adjusting value)  adjusting,required TResult Function( _Adjusted value)  adjusted,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Adjusting():
return adjusting(_that);case _Adjusted():
return adjusted(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Adjusting value)?  adjusting,TResult? Function( _Adjusted value)?  adjusted,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Adjusting() when adjusting != null:
return adjusting(_that);case _Adjusted() when adjusted != null:
return adjusted(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( int productId,  int previousQuantity,  int newQuantity)?  adjusting,TResult Function( int productId,  int quantity)?  adjusted,TResult Function( String message,  int productId,  int previousQuantity)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Adjusting() when adjusting != null:
return adjusting(_that.productId,_that.previousQuantity,_that.newQuantity);case _Adjusted() when adjusted != null:
return adjusted(_that.productId,_that.quantity);case _Error() when error != null:
return error(_that.message,_that.productId,_that.previousQuantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( int productId,  int previousQuantity,  int newQuantity)  adjusting,required TResult Function( int productId,  int quantity)  adjusted,required TResult Function( String message,  int productId,  int previousQuantity)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Adjusting():
return adjusting(_that.productId,_that.previousQuantity,_that.newQuantity);case _Adjusted():
return adjusted(_that.productId,_that.quantity);case _Error():
return error(_that.message,_that.productId,_that.previousQuantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( int productId,  int previousQuantity,  int newQuantity)?  adjusting,TResult? Function( int productId,  int quantity)?  adjusted,TResult? Function( String message,  int productId,  int previousQuantity)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Adjusting() when adjusting != null:
return adjusting(_that.productId,_that.previousQuantity,_that.newQuantity);case _Adjusted() when adjusted != null:
return adjusted(_that.productId,_that.quantity);case _Error() when error != null:
return error(_that.message,_that.productId,_that.previousQuantity);case _:
  return null;

}
}

}

/// @nodoc


class _Initial extends StockAdjustmentState {
  const _Initial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StockAdjustmentState.initial()';
}


}




/// @nodoc


class _Adjusting extends StockAdjustmentState {
  const _Adjusting({required this.productId, required this.previousQuantity, required this.newQuantity}): super._();
  

 final  int productId;
 final  int previousQuantity;
 final  int newQuantity;

/// Create a copy of StockAdjustmentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdjustingCopyWith<_Adjusting> get copyWith => __$AdjustingCopyWithImpl<_Adjusting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Adjusting&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.previousQuantity, previousQuantity) || other.previousQuantity == previousQuantity)&&(identical(other.newQuantity, newQuantity) || other.newQuantity == newQuantity));
}


@override
int get hashCode => Object.hash(runtimeType,productId,previousQuantity,newQuantity);

@override
String toString() {
  return 'StockAdjustmentState.adjusting(productId: $productId, previousQuantity: $previousQuantity, newQuantity: $newQuantity)';
}


}

/// @nodoc
abstract mixin class _$AdjustingCopyWith<$Res> implements $StockAdjustmentStateCopyWith<$Res> {
  factory _$AdjustingCopyWith(_Adjusting value, $Res Function(_Adjusting) _then) = __$AdjustingCopyWithImpl;
@useResult
$Res call({
 int productId, int previousQuantity, int newQuantity
});




}
/// @nodoc
class __$AdjustingCopyWithImpl<$Res>
    implements _$AdjustingCopyWith<$Res> {
  __$AdjustingCopyWithImpl(this._self, this._then);

  final _Adjusting _self;
  final $Res Function(_Adjusting) _then;

/// Create a copy of StockAdjustmentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? previousQuantity = null,Object? newQuantity = null,}) {
  return _then(_Adjusting(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,previousQuantity: null == previousQuantity ? _self.previousQuantity : previousQuantity // ignore: cast_nullable_to_non_nullable
as int,newQuantity: null == newQuantity ? _self.newQuantity : newQuantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _Adjusted extends StockAdjustmentState {
  const _Adjusted({required this.productId, required this.quantity}): super._();
  

 final  int productId;
 final  int quantity;

/// Create a copy of StockAdjustmentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdjustedCopyWith<_Adjusted> get copyWith => __$AdjustedCopyWithImpl<_Adjusted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Adjusted&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,productId,quantity);

@override
String toString() {
  return 'StockAdjustmentState.adjusted(productId: $productId, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$AdjustedCopyWith<$Res> implements $StockAdjustmentStateCopyWith<$Res> {
  factory _$AdjustedCopyWith(_Adjusted value, $Res Function(_Adjusted) _then) = __$AdjustedCopyWithImpl;
@useResult
$Res call({
 int productId, int quantity
});




}
/// @nodoc
class __$AdjustedCopyWithImpl<$Res>
    implements _$AdjustedCopyWith<$Res> {
  __$AdjustedCopyWithImpl(this._self, this._then);

  final _Adjusted _self;
  final $Res Function(_Adjusted) _then;

/// Create a copy of StockAdjustmentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? quantity = null,}) {
  return _then(_Adjusted(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _Error extends StockAdjustmentState {
  const _Error({required this.message, required this.productId, required this.previousQuantity}): super._();
  

 final  String message;
 final  int productId;
 final  int previousQuantity;

/// Create a copy of StockAdjustmentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.previousQuantity, previousQuantity) || other.previousQuantity == previousQuantity));
}


@override
int get hashCode => Object.hash(runtimeType,message,productId,previousQuantity);

@override
String toString() {
  return 'StockAdjustmentState.error(message: $message, productId: $productId, previousQuantity: $previousQuantity)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $StockAdjustmentStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message, int productId, int previousQuantity
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of StockAdjustmentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? productId = null,Object? previousQuantity = null,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,previousQuantity: null == previousQuantity ? _self.previousQuantity : previousQuantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
