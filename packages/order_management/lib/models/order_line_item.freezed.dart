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

/// Cart-local unique identifier (assigned by [ActiveOrderBloc] when the
/// line is added). Not persisted as-is — `OrderItemsTable` assigns its
/// own DB id on insert — but needed so the cart can address a specific
/// line (remove/quantity-change) once more than one line can share the
/// same [productId] (e.g. the same product added with different
/// modifier selections).
 int get id; int? get productId;// Nullable in case product was deleted later
 String get productName;// Snapshot name
 int get quantity; int get unitPriceCents;// Snapshot price
 List<SelectedModifiers> get selectedModifiers;/// Prep-station snapshot (from `Product.prepStation` at the moment this
/// line was added). Null = never ticketed, stays on the customer
/// receipt only (docs/features/02-kitchen-ticket-routing.md).
 String? get prepStation;// Combo support (docs/features/03-combo-modifier-pricing.md). A combo
// is one cart line pre-persist (productId null, comboComponents
// populated) that fans out into one OrderItemsTable row per constituent
// at persist time — see OrdersRepositoryImpl._insertComboLine. Once
// persisted/rehydrated, each constituent is its own OrderLineItem with
// a real productId, comboComponents empty, and a shared comboLineId.
 int? get comboId; String? get comboName;// Snapshot of the combo's name
 List<ComboLineComponent> get comboComponents;// Pre-persist only
 int? get comboLineId;// Non-null only post-persist; groups sibling rows
// Lead row only, non-null only post-persist: how many combo units were
// sold on this line, as opposed to `quantity` (how many of *this*
// constituent to make) — the two diverge once a combo's own constituent
// quantities aren't all 1. Read by the receipt mapper's grouping pass.
 int? get comboSaleQuantity;
/// Create a copy of OrderLineItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderLineItemCopyWith<OrderLineItem> get copyWith => _$OrderLineItemCopyWithImpl<OrderLineItem>(this as OrderLineItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderLineItem&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPriceCents, unitPriceCents) || other.unitPriceCents == unitPriceCents)&&const DeepCollectionEquality().equals(other.selectedModifiers, selectedModifiers)&&(identical(other.prepStation, prepStation) || other.prepStation == prepStation)&&(identical(other.comboId, comboId) || other.comboId == comboId)&&(identical(other.comboName, comboName) || other.comboName == comboName)&&const DeepCollectionEquality().equals(other.comboComponents, comboComponents)&&(identical(other.comboLineId, comboLineId) || other.comboLineId == comboLineId)&&(identical(other.comboSaleQuantity, comboSaleQuantity) || other.comboSaleQuantity == comboSaleQuantity));
}


@override
int get hashCode => Object.hash(runtimeType,id,productId,productName,quantity,unitPriceCents,const DeepCollectionEquality().hash(selectedModifiers),prepStation,comboId,comboName,const DeepCollectionEquality().hash(comboComponents),comboLineId,comboSaleQuantity);

@override
String toString() {
  return 'OrderLineItem(id: $id, productId: $productId, productName: $productName, quantity: $quantity, unitPriceCents: $unitPriceCents, selectedModifiers: $selectedModifiers, prepStation: $prepStation, comboId: $comboId, comboName: $comboName, comboComponents: $comboComponents, comboLineId: $comboLineId, comboSaleQuantity: $comboSaleQuantity)';
}


}

/// @nodoc
abstract mixin class $OrderLineItemCopyWith<$Res>  {
  factory $OrderLineItemCopyWith(OrderLineItem value, $Res Function(OrderLineItem) _then) = _$OrderLineItemCopyWithImpl;
@useResult
$Res call({
 int id, int? productId, String productName, int quantity, int unitPriceCents, List<SelectedModifiers> selectedModifiers, String? prepStation, int? comboId, String? comboName, List<ComboLineComponent> comboComponents, int? comboLineId, int? comboSaleQuantity
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = freezed,Object? productName = null,Object? quantity = null,Object? unitPriceCents = null,Object? selectedModifiers = null,Object? prepStation = freezed,Object? comboId = freezed,Object? comboName = freezed,Object? comboComponents = null,Object? comboLineId = freezed,Object? comboSaleQuantity = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int?,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPriceCents: null == unitPriceCents ? _self.unitPriceCents : unitPriceCents // ignore: cast_nullable_to_non_nullable
as int,selectedModifiers: null == selectedModifiers ? _self.selectedModifiers : selectedModifiers // ignore: cast_nullable_to_non_nullable
as List<SelectedModifiers>,prepStation: freezed == prepStation ? _self.prepStation : prepStation // ignore: cast_nullable_to_non_nullable
as String?,comboId: freezed == comboId ? _self.comboId : comboId // ignore: cast_nullable_to_non_nullable
as int?,comboName: freezed == comboName ? _self.comboName : comboName // ignore: cast_nullable_to_non_nullable
as String?,comboComponents: null == comboComponents ? _self.comboComponents : comboComponents // ignore: cast_nullable_to_non_nullable
as List<ComboLineComponent>,comboLineId: freezed == comboLineId ? _self.comboLineId : comboLineId // ignore: cast_nullable_to_non_nullable
as int?,comboSaleQuantity: freezed == comboSaleQuantity ? _self.comboSaleQuantity : comboSaleQuantity // ignore: cast_nullable_to_non_nullable
as int?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int? productId,  String productName,  int quantity,  int unitPriceCents,  List<SelectedModifiers> selectedModifiers,  String? prepStation,  int? comboId,  String? comboName,  List<ComboLineComponent> comboComponents,  int? comboLineId,  int? comboSaleQuantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderLineItem() when $default != null:
return $default(_that.id,_that.productId,_that.productName,_that.quantity,_that.unitPriceCents,_that.selectedModifiers,_that.prepStation,_that.comboId,_that.comboName,_that.comboComponents,_that.comboLineId,_that.comboSaleQuantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int? productId,  String productName,  int quantity,  int unitPriceCents,  List<SelectedModifiers> selectedModifiers,  String? prepStation,  int? comboId,  String? comboName,  List<ComboLineComponent> comboComponents,  int? comboLineId,  int? comboSaleQuantity)  $default,) {final _that = this;
switch (_that) {
case _OrderLineItem():
return $default(_that.id,_that.productId,_that.productName,_that.quantity,_that.unitPriceCents,_that.selectedModifiers,_that.prepStation,_that.comboId,_that.comboName,_that.comboComponents,_that.comboLineId,_that.comboSaleQuantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int? productId,  String productName,  int quantity,  int unitPriceCents,  List<SelectedModifiers> selectedModifiers,  String? prepStation,  int? comboId,  String? comboName,  List<ComboLineComponent> comboComponents,  int? comboLineId,  int? comboSaleQuantity)?  $default,) {final _that = this;
switch (_that) {
case _OrderLineItem() when $default != null:
return $default(_that.id,_that.productId,_that.productName,_that.quantity,_that.unitPriceCents,_that.selectedModifiers,_that.prepStation,_that.comboId,_that.comboName,_that.comboComponents,_that.comboLineId,_that.comboSaleQuantity);case _:
  return null;

}
}

}

/// @nodoc


class _OrderLineItem extends OrderLineItem {
  const _OrderLineItem({required this.id, this.productId, required this.productName, required this.quantity, required this.unitPriceCents, required final  List<SelectedModifiers> selectedModifiers, this.prepStation, this.comboId, this.comboName, final  List<ComboLineComponent> comboComponents = const [], this.comboLineId, this.comboSaleQuantity}): _selectedModifiers = selectedModifiers,_comboComponents = comboComponents,super._();
  

/// Cart-local unique identifier (assigned by [ActiveOrderBloc] when the
/// line is added). Not persisted as-is — `OrderItemsTable` assigns its
/// own DB id on insert — but needed so the cart can address a specific
/// line (remove/quantity-change) once more than one line can share the
/// same [productId] (e.g. the same product added with different
/// modifier selections).
@override final  int id;
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

/// Prep-station snapshot (from `Product.prepStation` at the moment this
/// line was added). Null = never ticketed, stays on the customer
/// receipt only (docs/features/02-kitchen-ticket-routing.md).
@override final  String? prepStation;
// Combo support (docs/features/03-combo-modifier-pricing.md). A combo
// is one cart line pre-persist (productId null, comboComponents
// populated) that fans out into one OrderItemsTable row per constituent
// at persist time — see OrdersRepositoryImpl._insertComboLine. Once
// persisted/rehydrated, each constituent is its own OrderLineItem with
// a real productId, comboComponents empty, and a shared comboLineId.
@override final  int? comboId;
@override final  String? comboName;
// Snapshot of the combo's name
 final  List<ComboLineComponent> _comboComponents;
// Snapshot of the combo's name
@override@JsonKey() List<ComboLineComponent> get comboComponents {
  if (_comboComponents is EqualUnmodifiableListView) return _comboComponents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comboComponents);
}

// Pre-persist only
@override final  int? comboLineId;
// Non-null only post-persist; groups sibling rows
// Lead row only, non-null only post-persist: how many combo units were
// sold on this line, as opposed to `quantity` (how many of *this*
// constituent to make) — the two diverge once a combo's own constituent
// quantities aren't all 1. Read by the receipt mapper's grouping pass.
@override final  int? comboSaleQuantity;

/// Create a copy of OrderLineItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderLineItemCopyWith<_OrderLineItem> get copyWith => __$OrderLineItemCopyWithImpl<_OrderLineItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderLineItem&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPriceCents, unitPriceCents) || other.unitPriceCents == unitPriceCents)&&const DeepCollectionEquality().equals(other._selectedModifiers, _selectedModifiers)&&(identical(other.prepStation, prepStation) || other.prepStation == prepStation)&&(identical(other.comboId, comboId) || other.comboId == comboId)&&(identical(other.comboName, comboName) || other.comboName == comboName)&&const DeepCollectionEquality().equals(other._comboComponents, _comboComponents)&&(identical(other.comboLineId, comboLineId) || other.comboLineId == comboLineId)&&(identical(other.comboSaleQuantity, comboSaleQuantity) || other.comboSaleQuantity == comboSaleQuantity));
}


@override
int get hashCode => Object.hash(runtimeType,id,productId,productName,quantity,unitPriceCents,const DeepCollectionEquality().hash(_selectedModifiers),prepStation,comboId,comboName,const DeepCollectionEquality().hash(_comboComponents),comboLineId,comboSaleQuantity);

@override
String toString() {
  return 'OrderLineItem(id: $id, productId: $productId, productName: $productName, quantity: $quantity, unitPriceCents: $unitPriceCents, selectedModifiers: $selectedModifiers, prepStation: $prepStation, comboId: $comboId, comboName: $comboName, comboComponents: $comboComponents, comboLineId: $comboLineId, comboSaleQuantity: $comboSaleQuantity)';
}


}

/// @nodoc
abstract mixin class _$OrderLineItemCopyWith<$Res> implements $OrderLineItemCopyWith<$Res> {
  factory _$OrderLineItemCopyWith(_OrderLineItem value, $Res Function(_OrderLineItem) _then) = __$OrderLineItemCopyWithImpl;
@override @useResult
$Res call({
 int id, int? productId, String productName, int quantity, int unitPriceCents, List<SelectedModifiers> selectedModifiers, String? prepStation, int? comboId, String? comboName, List<ComboLineComponent> comboComponents, int? comboLineId, int? comboSaleQuantity
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = freezed,Object? productName = null,Object? quantity = null,Object? unitPriceCents = null,Object? selectedModifiers = null,Object? prepStation = freezed,Object? comboId = freezed,Object? comboName = freezed,Object? comboComponents = null,Object? comboLineId = freezed,Object? comboSaleQuantity = freezed,}) {
  return _then(_OrderLineItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int?,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPriceCents: null == unitPriceCents ? _self.unitPriceCents : unitPriceCents // ignore: cast_nullable_to_non_nullable
as int,selectedModifiers: null == selectedModifiers ? _self._selectedModifiers : selectedModifiers // ignore: cast_nullable_to_non_nullable
as List<SelectedModifiers>,prepStation: freezed == prepStation ? _self.prepStation : prepStation // ignore: cast_nullable_to_non_nullable
as String?,comboId: freezed == comboId ? _self.comboId : comboId // ignore: cast_nullable_to_non_nullable
as int?,comboName: freezed == comboName ? _self.comboName : comboName // ignore: cast_nullable_to_non_nullable
as String?,comboComponents: null == comboComponents ? _self._comboComponents : comboComponents // ignore: cast_nullable_to_non_nullable
as List<ComboLineComponent>,comboLineId: freezed == comboLineId ? _self.comboLineId : comboLineId // ignore: cast_nullable_to_non_nullable
as int?,comboSaleQuantity: freezed == comboSaleQuantity ? _self.comboSaleQuantity : comboSaleQuantity // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
