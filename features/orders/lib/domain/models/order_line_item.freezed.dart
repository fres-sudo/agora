// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_line_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderLineItem {

 int? get productId;// Nullable in case product was deleted later
 String get productName;// Snapshot name
 int get quantity; int get unitPriceCents;// Snapshot price
 List<SelectedModifiers> get selectedModifiers;
/// Create a copy of OrderLineItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderLineItemCopyWith<OrderLineItem> get copyWith => _$OrderLineItemCopyWithImpl<OrderLineItem>(this as OrderLineItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderLineItem&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPriceCents, unitPriceCents) || other.unitPriceCents == unitPriceCents)&&const DeepCollectionEquality().equals(other.selectedModifiers, selectedModifiers));
}


@override
int get hashCode => Object.hash(runtimeType,productId,productName,quantity,unitPriceCents,const DeepCollectionEquality().hash(selectedModifiers));

@override
String toString() {
  return 'OrderLineItem(productId: $productId, productName: $productName, quantity: $quantity, unitPriceCents: $unitPriceCents, selectedModifiers: $selectedModifiers)';
}


}

/// @nodoc
abstract mixin class $OrderLineItemCopyWith<$Res>  {
  factory $OrderLineItemCopyWith(OrderLineItem value, $Res Function(OrderLineItem) _then) = _$OrderLineItemCopyWithImpl;
@useResult
$Res call({
 int? productId, String productName, int quantity, int unitPriceCents, List<SelectedModifiers> selectedModifiers
});




}
/// @nodoc
class _$OrderLineItemCopyWithImpl<$Res>
    implements $OrderLineItemCopyWith<$Res> {
  _$OrderLineItemCopyWithImpl(this._self, this._then);

  final OrderLineItem _self;
  final $Res Function(OrderLineItem) _then;

/// Create a copy of OrderLineItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = freezed,Object? productName = null,Object? quantity = null,Object? unitPriceCents = null,Object? selectedModifiers = null,}) {
  return _then(_self.copyWith(
productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int?,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPriceCents: null == unitPriceCents ? _self.unitPriceCents : unitPriceCents // ignore: cast_nullable_to_non_nullable
as int,selectedModifiers: null == selectedModifiers ? _self.selectedModifiers : selectedModifiers // ignore: cast_nullable_to_non_nullable
as List<SelectedModifiers>,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderLineItem].
extension OrderLineItemPatterns on OrderLineItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderLineItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderLineItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderLineItem value)  $default,){
final _that = this;
switch (_that) {
case _OrderLineItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderLineItem value)?  $default,){
final _that = this;
switch (_that) {
case _OrderLineItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? productId,  String productName,  int quantity,  int unitPriceCents,  List<SelectedModifiers> selectedModifiers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderLineItem() when $default != null:
return $default(_that.productId,_that.productName,_that.quantity,_that.unitPriceCents,_that.selectedModifiers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? productId,  String productName,  int quantity,  int unitPriceCents,  List<SelectedModifiers> selectedModifiers)  $default,) {final _that = this;
switch (_that) {
case _OrderLineItem():
return $default(_that.productId,_that.productName,_that.quantity,_that.unitPriceCents,_that.selectedModifiers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? productId,  String productName,  int quantity,  int unitPriceCents,  List<SelectedModifiers> selectedModifiers)?  $default,) {final _that = this;
switch (_that) {
case _OrderLineItem() when $default != null:
return $default(_that.productId,_that.productName,_that.quantity,_that.unitPriceCents,_that.selectedModifiers);case _:
  return null;

}
}

}

/// @nodoc


class _OrderLineItem extends OrderLineItem {
  const _OrderLineItem({this.productId, required this.productName, required this.quantity, required this.unitPriceCents, required final  List<SelectedModifiers> selectedModifiers}): _selectedModifiers = selectedModifiers,super._();
  

@override final  int? productId;
// Nullable in case product was deleted later
@override final  String productName;
// Snapshot name
@override final  int quantity;
@override final  int unitPriceCents;
// Snapshot price
 final  List<SelectedModifiers> _selectedModifiers;
// Snapshot price
@override List<SelectedModifiers> get selectedModifiers {
  if (_selectedModifiers is EqualUnmodifiableListView) return _selectedModifiers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedModifiers);
}


/// Create a copy of OrderLineItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderLineItemCopyWith<_OrderLineItem> get copyWith => __$OrderLineItemCopyWithImpl<_OrderLineItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderLineItem&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPriceCents, unitPriceCents) || other.unitPriceCents == unitPriceCents)&&const DeepCollectionEquality().equals(other._selectedModifiers, _selectedModifiers));
}


@override
int get hashCode => Object.hash(runtimeType,productId,productName,quantity,unitPriceCents,const DeepCollectionEquality().hash(_selectedModifiers));

@override
String toString() {
  return 'OrderLineItem(productId: $productId, productName: $productName, quantity: $quantity, unitPriceCents: $unitPriceCents, selectedModifiers: $selectedModifiers)';
}


}

/// @nodoc
abstract mixin class _$OrderLineItemCopyWith<$Res> implements $OrderLineItemCopyWith<$Res> {
  factory _$OrderLineItemCopyWith(_OrderLineItem value, $Res Function(_OrderLineItem) _then) = __$OrderLineItemCopyWithImpl;
@override @useResult
$Res call({
 int? productId, String productName, int quantity, int unitPriceCents, List<SelectedModifiers> selectedModifiers
});




}
/// @nodoc
class __$OrderLineItemCopyWithImpl<$Res>
    implements _$OrderLineItemCopyWith<$Res> {
  __$OrderLineItemCopyWithImpl(this._self, this._then);

  final _OrderLineItem _self;
  final $Res Function(_OrderLineItem) _then;

/// Create a copy of OrderLineItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = freezed,Object? productName = null,Object? quantity = null,Object? unitPriceCents = null,Object? selectedModifiers = null,}) {
  return _then(_OrderLineItem(
productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int?,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPriceCents: null == unitPriceCents ? _self.unitPriceCents : unitPriceCents // ignore: cast_nullable_to_non_nullable
as int,selectedModifiers: null == selectedModifiers ? _self._selectedModifiers : selectedModifiers // ignore: cast_nullable_to_non_nullable
as List<SelectedModifiers>,
  ));
}


}

// dart format on
