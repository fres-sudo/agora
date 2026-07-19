// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'combo_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ComboItem {

 int get productId; String get productName;// Denormalized for display without a join
 int get quantity;
/// Create a copy of ComboItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComboItemCopyWith<ComboItem> get copyWith => _$ComboItemCopyWithImpl<ComboItem>(this as ComboItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComboItem&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,productId,productName,quantity);

@override
String toString() {
  return 'ComboItem(productId: $productId, productName: $productName, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $ComboItemCopyWith<$Res>  {
  factory $ComboItemCopyWith(ComboItem value, $Res Function(ComboItem) _then) = _$ComboItemCopyWithImpl;
@useResult
$Res call({
 int productId, String productName, int quantity
});




}
/// @nodoc
class _$ComboItemCopyWithImpl<$Res>
    implements $ComboItemCopyWith<$Res> {
  _$ComboItemCopyWithImpl(this._self, this._then);

  final ComboItem _self;
  final $Res Function(ComboItem) _then;

/// Create a copy of ComboItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? productName = null,Object? quantity = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ComboItem].
extension ComboItemPatterns on ComboItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComboItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComboItem() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComboItem value)  $default,){
final _that = this;
switch (_that) {
case _ComboItem():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComboItem value)?  $default,){
final _that = this;
switch (_that) {
case _ComboItem() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int productId,  String productName,  int quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComboItem() when $default != null:
return $default(_that.productId,_that.productName,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int productId,  String productName,  int quantity)  $default,) {final _that = this;
switch (_that) {
case _ComboItem():
return $default(_that.productId,_that.productName,_that.quantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int productId,  String productName,  int quantity)?  $default,) {final _that = this;
switch (_that) {
case _ComboItem() when $default != null:
return $default(_that.productId,_that.productName,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc


class _ComboItem extends ComboItem {
  const _ComboItem({required this.productId, required this.productName, this.quantity = 1}): super._();
  

@override final  int productId;
@override final  String productName;
// Denormalized for display without a join
@override@JsonKey() final  int quantity;

/// Create a copy of ComboItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComboItemCopyWith<_ComboItem> get copyWith => __$ComboItemCopyWithImpl<_ComboItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComboItem&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,productId,productName,quantity);

@override
String toString() {
  return 'ComboItem(productId: $productId, productName: $productName, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$ComboItemCopyWith<$Res> implements $ComboItemCopyWith<$Res> {
  factory _$ComboItemCopyWith(_ComboItem value, $Res Function(_ComboItem) _then) = __$ComboItemCopyWithImpl;
@override @useResult
$Res call({
 int productId, String productName, int quantity
});




}
/// @nodoc
class __$ComboItemCopyWithImpl<$Res>
    implements _$ComboItemCopyWith<$Res> {
  __$ComboItemCopyWithImpl(this._self, this._then);

  final _ComboItem _self;
  final $Res Function(_ComboItem) _then;

/// Create a copy of ComboItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? productName = null,Object? quantity = null,}) {
  return _then(_ComboItem(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
