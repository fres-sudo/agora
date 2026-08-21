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
 DateTime get createdAt; OrderStatus get status; OrderType get orderType; List<OrderLineItem> get items; String? get note;// Cross-station identity for LAN sync (uuid v4). Null for orders never
// synced (pre-migration, or a station that has never paired) — see
// OrdersTable.syncId and docs/features/01-lan-sync.md.
 String? get syncId;// Payment
 String? get paymentMethod;// "Cash", "Card", etc. Null until paid.
 String? get paymentProvider; PaymentStatus? get paymentStatus; String? get paymentAttemptId; String? get paymentTransactionCode; String? get paymentError;// Volunteer who took the order, for shift cash reconciliation
// (docs/features/04-volunteer-shift-accountability.md). Nullable
// defensively — checkout shouldn't crash if session state is ever
// momentarily absent — and never populated on orders applied from a
// peer station via LAN sync (employee records aren't synced).
 int? get employeeId;// Financials
 int get subtotalCents; int get taxCents; int get discountCents; int get grandTotalCents;
/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderCopyWith<Order> get copyWith => _$OrderCopyWithImpl<Order>(this as Order, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Order&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.orderType, orderType) || other.orderType == orderType)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.note, note) || other.note == note)&&(identical(other.syncId, syncId) || other.syncId == syncId)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.paymentProvider, paymentProvider) || other.paymentProvider == paymentProvider)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paymentAttemptId, paymentAttemptId) || other.paymentAttemptId == paymentAttemptId)&&(identical(other.paymentTransactionCode, paymentTransactionCode) || other.paymentTransactionCode == paymentTransactionCode)&&(identical(other.paymentError, paymentError) || other.paymentError == paymentError)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.subtotalCents, subtotalCents) || other.subtotalCents == subtotalCents)&&(identical(other.taxCents, taxCents) || other.taxCents == taxCents)&&(identical(other.discountCents, discountCents) || other.discountCents == discountCents)&&(identical(other.grandTotalCents, grandTotalCents) || other.grandTotalCents == grandTotalCents));
}


@override
int get hashCode => Object.hash(runtimeType,id,createdAt,status,orderType,const DeepCollectionEquality().hash(items),note,syncId,paymentMethod,paymentProvider,paymentStatus,paymentAttemptId,paymentTransactionCode,paymentError,employeeId,subtotalCents,taxCents,discountCents,grandTotalCents);

@override
String toString() {
  return 'Order(id: $id, createdAt: $createdAt, status: $status, orderType: $orderType, items: $items, note: $note, syncId: $syncId, paymentMethod: $paymentMethod, paymentProvider: $paymentProvider, paymentStatus: $paymentStatus, paymentAttemptId: $paymentAttemptId, paymentTransactionCode: $paymentTransactionCode, paymentError: $paymentError, employeeId: $employeeId, subtotalCents: $subtotalCents, taxCents: $taxCents, discountCents: $discountCents, grandTotalCents: $grandTotalCents)';
}


}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res>  {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) = _$OrderCopyWithImpl;
@useResult
$Res call({
 int? id, DateTime createdAt, OrderStatus status, OrderType orderType, List<OrderLineItem> items, String? note, String? syncId, String? paymentMethod, String? paymentProvider, PaymentStatus? paymentStatus, String? paymentAttemptId, String? paymentTransactionCode, String? paymentError, int? employeeId, int subtotalCents, int taxCents, int discountCents, int grandTotalCents
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? createdAt = null,Object? status = null,Object? orderType = null,Object? items = null,Object? note = freezed,Object? syncId = freezed,Object? paymentMethod = freezed,Object? paymentProvider = freezed,Object? paymentStatus = freezed,Object? paymentAttemptId = freezed,Object? paymentTransactionCode = freezed,Object? paymentError = freezed,Object? employeeId = freezed,Object? subtotalCents = null,Object? taxCents = null,Object? discountCents = null,Object? grandTotalCents = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,orderType: null == orderType ? _self.orderType : orderType // ignore: cast_nullable_to_non_nullable
as OrderType,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderLineItem>,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,syncId: freezed == syncId ? _self.syncId : syncId // ignore: cast_nullable_to_non_nullable
as String?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,paymentProvider: freezed == paymentProvider ? _self.paymentProvider : paymentProvider // ignore: cast_nullable_to_non_nullable
as String?,paymentStatus: freezed == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as PaymentStatus?,paymentAttemptId: freezed == paymentAttemptId ? _self.paymentAttemptId : paymentAttemptId // ignore: cast_nullable_to_non_nullable
as String?,paymentTransactionCode: freezed == paymentTransactionCode ? _self.paymentTransactionCode : paymentTransactionCode // ignore: cast_nullable_to_non_nullable
as String?,paymentError: freezed == paymentError ? _self.paymentError : paymentError // ignore: cast_nullable_to_non_nullable
as String?,employeeId: freezed == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as int?,subtotalCents: null == subtotalCents ? _self.subtotalCents : subtotalCents // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  DateTime createdAt,  OrderStatus status,  OrderType orderType,  List<OrderLineItem> items,  String? note,  String? syncId,  String? paymentMethod,  String? paymentProvider,  PaymentStatus? paymentStatus,  String? paymentAttemptId,  String? paymentTransactionCode,  String? paymentError,  int? employeeId,  int subtotalCents,  int taxCents,  int discountCents,  int grandTotalCents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.createdAt,_that.status,_that.orderType,_that.items,_that.note,_that.syncId,_that.paymentMethod,_that.paymentProvider,_that.paymentStatus,_that.paymentAttemptId,_that.paymentTransactionCode,_that.paymentError,_that.employeeId,_that.subtotalCents,_that.taxCents,_that.discountCents,_that.grandTotalCents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  DateTime createdAt,  OrderStatus status,  OrderType orderType,  List<OrderLineItem> items,  String? note,  String? syncId,  String? paymentMethod,  String? paymentProvider,  PaymentStatus? paymentStatus,  String? paymentAttemptId,  String? paymentTransactionCode,  String? paymentError,  int? employeeId,  int subtotalCents,  int taxCents,  int discountCents,  int grandTotalCents)  $default,) {final _that = this;
switch (_that) {
case _Order():
return $default(_that.id,_that.createdAt,_that.status,_that.orderType,_that.items,_that.note,_that.syncId,_that.paymentMethod,_that.paymentProvider,_that.paymentStatus,_that.paymentAttemptId,_that.paymentTransactionCode,_that.paymentError,_that.employeeId,_that.subtotalCents,_that.taxCents,_that.discountCents,_that.grandTotalCents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  DateTime createdAt,  OrderStatus status,  OrderType orderType,  List<OrderLineItem> items,  String? note,  String? syncId,  String? paymentMethod,  String? paymentProvider,  PaymentStatus? paymentStatus,  String? paymentAttemptId,  String? paymentTransactionCode,  String? paymentError,  int? employeeId,  int subtotalCents,  int taxCents,  int discountCents,  int grandTotalCents)?  $default,) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.createdAt,_that.status,_that.orderType,_that.items,_that.note,_that.syncId,_that.paymentMethod,_that.paymentProvider,_that.paymentStatus,_that.paymentAttemptId,_that.paymentTransactionCode,_that.paymentError,_that.employeeId,_that.subtotalCents,_that.taxCents,_that.discountCents,_that.grandTotalCents);case _:
  return null;

}
}

}

/// @nodoc


class _Order extends Order {
  const _Order({required this.id, required this.createdAt, required this.status, this.orderType = OrderType.dineIn, required final  List<OrderLineItem> items, required this.note, this.syncId, this.paymentMethod, this.paymentProvider, this.paymentStatus, this.paymentAttemptId, this.paymentTransactionCode, this.paymentError, this.employeeId, required this.subtotalCents, required this.taxCents, required this.discountCents, required this.grandTotalCents}): _items = items,super._();
  

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
// Cross-station identity for LAN sync (uuid v4). Null for orders never
// synced (pre-migration, or a station that has never paired) — see
// OrdersTable.syncId and docs/features/01-lan-sync.md.
@override final  String? syncId;
// Payment
@override final  String? paymentMethod;
// "Cash", "Card", etc. Null until paid.
@override final  String? paymentProvider;
@override final  PaymentStatus? paymentStatus;
@override final  String? paymentAttemptId;
@override final  String? paymentTransactionCode;
@override final  String? paymentError;
// Volunteer who took the order, for shift cash reconciliation
// (docs/features/04-volunteer-shift-accountability.md). Nullable
// defensively — checkout shouldn't crash if session state is ever
// momentarily absent — and never populated on orders applied from a
// peer station via LAN sync (employee records aren't synced).
@override final  int? employeeId;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Order&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.orderType, orderType) || other.orderType == orderType)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.note, note) || other.note == note)&&(identical(other.syncId, syncId) || other.syncId == syncId)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.paymentProvider, paymentProvider) || other.paymentProvider == paymentProvider)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paymentAttemptId, paymentAttemptId) || other.paymentAttemptId == paymentAttemptId)&&(identical(other.paymentTransactionCode, paymentTransactionCode) || other.paymentTransactionCode == paymentTransactionCode)&&(identical(other.paymentError, paymentError) || other.paymentError == paymentError)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.subtotalCents, subtotalCents) || other.subtotalCents == subtotalCents)&&(identical(other.taxCents, taxCents) || other.taxCents == taxCents)&&(identical(other.discountCents, discountCents) || other.discountCents == discountCents)&&(identical(other.grandTotalCents, grandTotalCents) || other.grandTotalCents == grandTotalCents));
}


@override
int get hashCode => Object.hash(runtimeType,id,createdAt,status,orderType,const DeepCollectionEquality().hash(_items),note,syncId,paymentMethod,paymentProvider,paymentStatus,paymentAttemptId,paymentTransactionCode,paymentError,employeeId,subtotalCents,taxCents,discountCents,grandTotalCents);

@override
String toString() {
  return 'Order(id: $id, createdAt: $createdAt, status: $status, orderType: $orderType, items: $items, note: $note, syncId: $syncId, paymentMethod: $paymentMethod, paymentProvider: $paymentProvider, paymentStatus: $paymentStatus, paymentAttemptId: $paymentAttemptId, paymentTransactionCode: $paymentTransactionCode, paymentError: $paymentError, employeeId: $employeeId, subtotalCents: $subtotalCents, taxCents: $taxCents, discountCents: $discountCents, grandTotalCents: $grandTotalCents)';
}


}

/// @nodoc
abstract mixin class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) _then) = __$OrderCopyWithImpl;
@override @useResult
$Res call({
 int? id, DateTime createdAt, OrderStatus status, OrderType orderType, List<OrderLineItem> items, String? note, String? syncId, String? paymentMethod, String? paymentProvider, PaymentStatus? paymentStatus, String? paymentAttemptId, String? paymentTransactionCode, String? paymentError, int? employeeId, int subtotalCents, int taxCents, int discountCents, int grandTotalCents
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? createdAt = null,Object? status = null,Object? orderType = null,Object? items = null,Object? note = freezed,Object? syncId = freezed,Object? paymentMethod = freezed,Object? paymentProvider = freezed,Object? paymentStatus = freezed,Object? paymentAttemptId = freezed,Object? paymentTransactionCode = freezed,Object? paymentError = freezed,Object? employeeId = freezed,Object? subtotalCents = null,Object? taxCents = null,Object? discountCents = null,Object? grandTotalCents = null,}) {
  return _then(_Order(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,orderType: null == orderType ? _self.orderType : orderType // ignore: cast_nullable_to_non_nullable
as OrderType,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderLineItem>,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,syncId: freezed == syncId ? _self.syncId : syncId // ignore: cast_nullable_to_non_nullable
as String?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,paymentProvider: freezed == paymentProvider ? _self.paymentProvider : paymentProvider // ignore: cast_nullable_to_non_nullable
as String?,paymentStatus: freezed == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as PaymentStatus?,paymentAttemptId: freezed == paymentAttemptId ? _self.paymentAttemptId : paymentAttemptId // ignore: cast_nullable_to_non_nullable
as String?,paymentTransactionCode: freezed == paymentTransactionCode ? _self.paymentTransactionCode : paymentTransactionCode // ignore: cast_nullable_to_non_nullable
as String?,paymentError: freezed == paymentError ? _self.paymentError : paymentError // ignore: cast_nullable_to_non_nullable
as String?,employeeId: freezed == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as int?,subtotalCents: null == subtotalCents ? _self.subtotalCents : subtotalCents // ignore: cast_nullable_to_non_nullable
as int,taxCents: null == taxCents ? _self.taxCents : taxCents // ignore: cast_nullable_to_non_nullable
as int,discountCents: null == discountCents ? _self.discountCents : discountCents // ignore: cast_nullable_to_non_nullable
as int,grandTotalCents: null == grandTotalCents ? _self.grandTotalCents : grandTotalCents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
