// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'combo_line_component.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ComboLineComponent {

 int get productId; String get productName; int get quantity;// Per one unit of the combo
 int get unitCostPriceCents;// Product.costCents at add-to-cart time
 String? get prepStation;
/// Create a copy of ComboLineComponent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComboLineComponentCopyWith<ComboLineComponent> get copyWith => _$ComboLineComponentCopyWithImpl<ComboLineComponent>(this as ComboLineComponent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComboLineComponent&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitCostPriceCents, unitCostPriceCents) || other.unitCostPriceCents == unitCostPriceCents)&&(identical(other.prepStation, prepStation) || other.prepStation == prepStation));
}


@override
int get hashCode => Object.hash(runtimeType,productId,productName,quantity,unitCostPriceCents,prepStation);

@override
String toString() {
  return 'ComboLineComponent(productId: $productId, productName: $productName, quantity: $quantity, unitCostPriceCents: $unitCostPriceCents, prepStation: $prepStation)';
}


}

/// @nodoc
abstract mixin class $ComboLineComponentCopyWith<$Res>  {
  factory $ComboLineComponentCopyWith(ComboLineComponent value, $Res Function(ComboLineComponent) _then) = _$ComboLineComponentCopyWithImpl;
@useResult
$Res call({
 int productId, String productName, int quantity, int unitCostPriceCents, String? prepStation
});




}
/// @nodoc
class _$ComboLineComponentCopyWithImpl<$Res>
    implements $ComboLineComponentCopyWith<$Res> {
  _$ComboLineComponentCopyWithImpl(this._self, this._then);

  final ComboLineComponent _self;
  final $Res Function(ComboLineComponent) _then;

/// Create a copy of ComboLineComponent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? productName = null,Object? quantity = null,Object? unitCostPriceCents = null,Object? prepStation = freezed,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitCostPriceCents: null == unitCostPriceCents ? _self.unitCostPriceCents : unitCostPriceCents // ignore: cast_nullable_to_non_nullable
as int,prepStation: freezed == prepStation ? _self.prepStation : prepStation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ComboLineComponent].
extension ComboLineComponentPatterns on ComboLineComponent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComboLineComponent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComboLineComponent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComboLineComponent value)  $default,){
final _that = this;
switch (_that) {
case _ComboLineComponent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComboLineComponent value)?  $default,){
final _that = this;
switch (_that) {
case _ComboLineComponent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int productId,  String productName,  int quantity,  int unitCostPriceCents,  String? prepStation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComboLineComponent() when $default != null:
return $default(_that.productId,_that.productName,_that.quantity,_that.unitCostPriceCents,_that.prepStation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int productId,  String productName,  int quantity,  int unitCostPriceCents,  String? prepStation)  $default,) {final _that = this;
switch (_that) {
case _ComboLineComponent():
return $default(_that.productId,_that.productName,_that.quantity,_that.unitCostPriceCents,_that.prepStation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int productId,  String productName,  int quantity,  int unitCostPriceCents,  String? prepStation)?  $default,) {final _that = this;
switch (_that) {
case _ComboLineComponent() when $default != null:
return $default(_that.productId,_that.productName,_that.quantity,_that.unitCostPriceCents,_that.prepStation);case _:
  return null;

}
}

}

/// @nodoc


class _ComboLineComponent extends ComboLineComponent {
  const _ComboLineComponent({required this.productId, required this.productName, this.quantity = 1, this.unitCostPriceCents = 0, this.prepStation}): super._();
  

@override final  int productId;
@override final  String productName;
@override@JsonKey() final  int quantity;
// Per one unit of the combo
@override@JsonKey() final  int unitCostPriceCents;
// Product.costCents at add-to-cart time
@override final  String? prepStation;

/// Create a copy of ComboLineComponent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComboLineComponentCopyWith<_ComboLineComponent> get copyWith => __$ComboLineComponentCopyWithImpl<_ComboLineComponent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComboLineComponent&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitCostPriceCents, unitCostPriceCents) || other.unitCostPriceCents == unitCostPriceCents)&&(identical(other.prepStation, prepStation) || other.prepStation == prepStation));
}


@override
int get hashCode => Object.hash(runtimeType,productId,productName,quantity,unitCostPriceCents,prepStation);

@override
String toString() {
  return 'ComboLineComponent(productId: $productId, productName: $productName, quantity: $quantity, unitCostPriceCents: $unitCostPriceCents, prepStation: $prepStation)';
}


}

/// @nodoc
abstract mixin class _$ComboLineComponentCopyWith<$Res> implements $ComboLineComponentCopyWith<$Res> {
  factory _$ComboLineComponentCopyWith(_ComboLineComponent value, $Res Function(_ComboLineComponent) _then) = __$ComboLineComponentCopyWithImpl;
@override @useResult
$Res call({
 int productId, String productName, int quantity, int unitCostPriceCents, String? prepStation
});




}
/// @nodoc
class __$ComboLineComponentCopyWithImpl<$Res>
    implements _$ComboLineComponentCopyWith<$Res> {
  __$ComboLineComponentCopyWithImpl(this._self, this._then);

  final _ComboLineComponent _self;
  final $Res Function(_ComboLineComponent) _then;

/// Create a copy of ComboLineComponent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? productName = null,Object? quantity = null,Object? unitCostPriceCents = null,Object? prepStation = freezed,}) {
  return _then(_ComboLineComponent(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitCostPriceCents: null == unitCostPriceCents ? _self.unitCostPriceCents : unitCostPriceCents // ignore: cast_nullable_to_non_nullable
as int,prepStation: freezed == prepStation ? _self.prepStation : prepStation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
