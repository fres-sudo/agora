// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Order {

 int? get id;// Null if it's a new cart not yet saved to DB
 DateTime get createdAt; OrderStatus get status; OrderType get orderType; List<OrderLineItem> get items; String? get note;// Payment
 String? get paymentMethod;// "Cash", "Card", etc. Null until paid.
// Financials
 int get subtotalCents; int get taxCents; int get discountCents; int get grandTotalCents;
/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderCopyWith<Order> get copyWith => _$OrderCopyWithImpl<Order>(this as Order, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Order&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.orderType, orderType) || other.orderType == orderType)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.note, note) || other.note == note)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.subtotalCents, subtotalCents) || other.subtotalCents == subtotalCents)&&(identical(other.taxCents, taxCents) || other.taxCents == taxCents)&&(identical(other.discountCents, discountCents) || other.discountCents == discountCents)&&(identical(other.grandTotalCents, grandTotalCents) || other.grandTotalCents == grandTotalCents));
}


@override
int get hashCode => Object.hash(runtimeType,id,createdAt,status,orderType,const DeepCollectionEquality().hash(items),note,paymentMethod,subtotalCents,taxCents,discountCents,grandTotalCents);

@override
String toString() {
  return 'Order(id: $id, createdAt: $createdAt, status: $status, orderType: $orderType, items: $items, note: $note, paymentMethod: $paymentMethod, subtotalCents: $subtotalCents, taxCents: $taxCents, discountCents: $discountCents, grandTotalCents: $grandTotalCents)';
}


}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res>  {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) = _$OrderCopyWithImpl;
@useResult
$Res call({
 int? id, DateTime createdAt, OrderStatus status, OrderType orderType, List<OrderLineItem> items, String? note, String? paymentMethod, int subtotalCents, int taxCents, int discountCents, int grandTotalCents
});




}
/// @nodoc
class _$OrderCopyWithImpl<$Res>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._self, this._then);

  final Order _self;
  final $Res Function(Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? createdAt = null,Object? status = null,Object? orderType = null,Object? items = null,Object? note = freezed,Object? paymentMethod = freezed,Object? subtotalCents = null,Object? taxCents = null,Object? discountCents = null,Object? grandTotalCents = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,orderType: null == orderType ? _self.orderType : orderType // ignore: cast_nullable_to_non_nullable
as OrderType,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderLineItem>,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,subtotalCents: null == subtotalCents ? _self.subtotalCents : subtotalCents // ignore: cast_nullable_to_non_nullable
as int,taxCents: null == taxCents ? _self.taxCents : taxCents // ignore: cast_nullable_to_non_nullable
as int,discountCents: null == discountCents ? _self.discountCents : discountCents // ignore: cast_nullable_to_non_nullable
as int,grandTotalCents: null == grandTotalCents ? _self.grandTotalCents : grandTotalCents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Order].
extension OrderPatterns on Order {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Order value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Order() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Order value)  $default,){
final _that = this;
switch (_that) {
case _Order():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Order value)?  $default,){
final _that = this;
switch (_that) {
case _Order() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  DateTime createdAt,  OrderStatus status,  OrderType orderType,  List<OrderLineItem> items,  String? note,  String? paymentMethod,  int subtotalCents,  int taxCents,  int discountCents,  int grandTotalCents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.createdAt,_that.status,_that.orderType,_that.items,_that.note,_that.paymentMethod,_that.subtotalCents,_that.taxCents,_that.discountCents,_that.grandTotalCents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  DateTime createdAt,  OrderStatus status,  OrderType orderType,  List<OrderLineItem> items,  String? note,  String? paymentMethod,  int subtotalCents,  int taxCents,  int discountCents,  int grandTotalCents)  $default,) {final _that = this;
switch (_that) {
case _Order():
return $default(_that.id,_that.createdAt,_that.status,_that.orderType,_that.items,_that.note,_that.paymentMethod,_that.subtotalCents,_that.taxCents,_that.discountCents,_that.grandTotalCents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  DateTime createdAt,  OrderStatus status,  OrderType orderType,  List<OrderLineItem> items,  String? note,  String? paymentMethod,  int subtotalCents,  int taxCents,  int discountCents,  int grandTotalCents)?  $default,) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.createdAt,_that.status,_that.orderType,_that.items,_that.note,_that.paymentMethod,_that.subtotalCents,_that.taxCents,_that.discountCents,_that.grandTotalCents);case _:
  return null;

}
}

}

/// @nodoc


class _Order extends Order {
  const _Order({required this.id, required this.createdAt, required this.status, this.orderType = OrderType.dineIn, required final  List<OrderLineItem> items, required this.note, this.paymentMethod, required this.subtotalCents, required this.taxCents, required this.discountCents, required this.grandTotalCents}): _items = items,super._();
  

@override final  int? id;
// Null if it's a new cart not yet saved to DB
@override final  DateTime createdAt;
@override final  OrderStatus status;
@override@JsonKey() final  OrderType orderType;
 final  List<OrderLineItem> _items;
@override List<OrderLineItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  String? note;
// Payment
@override final  String? paymentMethod;
// "Cash", "Card", etc. Null until paid.
// Financials
@override final  int subtotalCents;
@override final  int taxCents;
@override final  int discountCents;
@override final  int grandTotalCents;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderCopyWith<_Order> get copyWith => __$OrderCopyWithImpl<_Order>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Order&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.orderType, orderType) || other.orderType == orderType)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.note, note) || other.note == note)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.subtotalCents, subtotalCents) || other.subtotalCents == subtotalCents)&&(identical(other.taxCents, taxCents) || other.taxCents == taxCents)&&(identical(other.discountCents, discountCents) || other.discountCents == discountCents)&&(identical(other.grandTotalCents, grandTotalCents) || other.grandTotalCents == grandTotalCents));
}


@override
int get hashCode => Object.hash(runtimeType,id,createdAt,status,orderType,const DeepCollectionEquality().hash(_items),note,paymentMethod,subtotalCents,taxCents,discountCents,grandTotalCents);

@override
String toString() {
  return 'Order(id: $id, createdAt: $createdAt, status: $status, orderType: $orderType, items: $items, note: $note, paymentMethod: $paymentMethod, subtotalCents: $subtotalCents, taxCents: $taxCents, discountCents: $discountCents, grandTotalCents: $grandTotalCents)';
}


}

/// @nodoc
abstract mixin class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) _then) = __$OrderCopyWithImpl;
@override @useResult
$Res call({
 int? id, DateTime createdAt, OrderStatus status, OrderType orderType, List<OrderLineItem> items, String? note, String? paymentMethod, int subtotalCents, int taxCents, int discountCents, int grandTotalCents
});




}
/// @nodoc
class __$OrderCopyWithImpl<$Res>
    implements _$OrderCopyWith<$Res> {
  __$OrderCopyWithImpl(this._self, this._then);

  final _Order _self;
  final $Res Function(_Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? createdAt = null,Object? status = null,Object? orderType = null,Object? items = null,Object? note = freezed,Object? paymentMethod = freezed,Object? subtotalCents = null,Object? taxCents = null,Object? discountCents = null,Object? grandTotalCents = null,}) {
  return _then(_Order(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,orderType: null == orderType ? _self.orderType : orderType // ignore: cast_nullable_to_non_nullable
as OrderType,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderLineItem>,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,subtotalCents: null == subtotalCents ? _self.subtotalCents : subtotalCents // ignore: cast_nullable_to_non_nullable
as int,taxCents: null == taxCents ? _self.taxCents : taxCents // ignore: cast_nullable_to_non_nullable
as int,discountCents: null == discountCents ? _self.discountCents : discountCents // ignore: cast_nullable_to_non_nullable
as int,grandTotalCents: null == grandTotalCents ? _self.grandTotalCents : grandTotalCents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
