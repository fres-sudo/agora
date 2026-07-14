// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TicketItem {

 int get orderItemId; String get productName; int get quantity; List<String> get modifiers;
/// Create a copy of TicketItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketItemCopyWith<TicketItem> get copyWith => _$TicketItemCopyWithImpl<TicketItem>(this as TicketItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketItem&&(identical(other.orderItemId, orderItemId) || other.orderItemId == orderItemId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&const DeepCollectionEquality().equals(other.modifiers, modifiers));
}


@override
int get hashCode => Object.hash(runtimeType,orderItemId,productName,quantity,const DeepCollectionEquality().hash(modifiers));

@override
String toString() {
  return 'TicketItem(orderItemId: $orderItemId, productName: $productName, quantity: $quantity, modifiers: $modifiers)';
}


}

/// @nodoc
abstract mixin class $TicketItemCopyWith<$Res>  {
  factory $TicketItemCopyWith(TicketItem value, $Res Function(TicketItem) _then) = _$TicketItemCopyWithImpl;
@useResult
$Res call({
 int orderItemId, String productName, int quantity, List<String> modifiers
});




}
/// @nodoc
class _$TicketItemCopyWithImpl<$Res>
    implements $TicketItemCopyWith<$Res> {
  _$TicketItemCopyWithImpl(this._self, this._then);

  final TicketItem _self;
  final $Res Function(TicketItem) _then;

/// Create a copy of TicketItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderItemId = null,Object? productName = null,Object? quantity = null,Object? modifiers = null,}) {
  return _then(_self.copyWith(
orderItemId: null == orderItemId ? _self.orderItemId : orderItemId // ignore: cast_nullable_to_non_nullable
as int,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,modifiers: null == modifiers ? _self.modifiers : modifiers // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [TicketItem].
extension TicketItemPatterns on TicketItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TicketItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TicketItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TicketItem value)  $default,){
final _that = this;
switch (_that) {
case _TicketItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TicketItem value)?  $default,){
final _that = this;
switch (_that) {
case _TicketItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int orderItemId,  String productName,  int quantity,  List<String> modifiers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TicketItem() when $default != null:
return $default(_that.orderItemId,_that.productName,_that.quantity,_that.modifiers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int orderItemId,  String productName,  int quantity,  List<String> modifiers)  $default,) {final _that = this;
switch (_that) {
case _TicketItem():
return $default(_that.orderItemId,_that.productName,_that.quantity,_that.modifiers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int orderItemId,  String productName,  int quantity,  List<String> modifiers)?  $default,) {final _that = this;
switch (_that) {
case _TicketItem() when $default != null:
return $default(_that.orderItemId,_that.productName,_that.quantity,_that.modifiers);case _:
  return null;

}
}

}

/// @nodoc


class _TicketItem extends TicketItem {
  const _TicketItem({required this.orderItemId, required this.productName, required this.quantity, final  List<String> modifiers = const []}): _modifiers = modifiers,super._();
  

@override final  int orderItemId;
@override final  String productName;
@override final  int quantity;
 final  List<String> _modifiers;
@override@JsonKey() List<String> get modifiers {
  if (_modifiers is EqualUnmodifiableListView) return _modifiers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_modifiers);
}


/// Create a copy of TicketItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketItemCopyWith<_TicketItem> get copyWith => __$TicketItemCopyWithImpl<_TicketItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TicketItem&&(identical(other.orderItemId, orderItemId) || other.orderItemId == orderItemId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&const DeepCollectionEquality().equals(other._modifiers, _modifiers));
}


@override
int get hashCode => Object.hash(runtimeType,orderItemId,productName,quantity,const DeepCollectionEquality().hash(_modifiers));

@override
String toString() {
  return 'TicketItem(orderItemId: $orderItemId, productName: $productName, quantity: $quantity, modifiers: $modifiers)';
}


}

/// @nodoc
abstract mixin class _$TicketItemCopyWith<$Res> implements $TicketItemCopyWith<$Res> {
  factory _$TicketItemCopyWith(_TicketItem value, $Res Function(_TicketItem) _then) = __$TicketItemCopyWithImpl;
@override @useResult
$Res call({
 int orderItemId, String productName, int quantity, List<String> modifiers
});




}
/// @nodoc
class __$TicketItemCopyWithImpl<$Res>
    implements _$TicketItemCopyWith<$Res> {
  __$TicketItemCopyWithImpl(this._self, this._then);

  final _TicketItem _self;
  final $Res Function(_TicketItem) _then;

/// Create a copy of TicketItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderItemId = null,Object? productName = null,Object? quantity = null,Object? modifiers = null,}) {
  return _then(_TicketItem(
orderItemId: null == orderItemId ? _self.orderItemId : orderItemId // ignore: cast_nullable_to_non_nullable
as int,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,modifiers: null == modifiers ? _self._modifiers : modifiers // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$Ticket {

 int get orderId; String? get orderSyncId; String get orderNumber; String get station; DateTime get createdAt; TicketStatus get status; List<TicketItem> get items;
/// Create a copy of Ticket
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketCopyWith<Ticket> get copyWith => _$TicketCopyWithImpl<Ticket>(this as Ticket, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Ticket&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.orderSyncId, orderSyncId) || other.orderSyncId == orderSyncId)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.station, station) || other.station == station)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items));
}


@override
int get hashCode => Object.hash(runtimeType,orderId,orderSyncId,orderNumber,station,createdAt,status,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'Ticket(orderId: $orderId, orderSyncId: $orderSyncId, orderNumber: $orderNumber, station: $station, createdAt: $createdAt, status: $status, items: $items)';
}


}

/// @nodoc
abstract mixin class $TicketCopyWith<$Res>  {
  factory $TicketCopyWith(Ticket value, $Res Function(Ticket) _then) = _$TicketCopyWithImpl;
@useResult
$Res call({
 int orderId, String? orderSyncId, String orderNumber, String station, DateTime createdAt, TicketStatus status, List<TicketItem> items
});




}
/// @nodoc
class _$TicketCopyWithImpl<$Res>
    implements $TicketCopyWith<$Res> {
  _$TicketCopyWithImpl(this._self, this._then);

  final Ticket _self;
  final $Res Function(Ticket) _then;

/// Create a copy of Ticket
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? orderId = null,Object? orderSyncId = freezed,Object? orderNumber = null,Object? station = null,Object? createdAt = null,Object? status = null,Object? items = null,}) {
  return _then(_self.copyWith(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,orderSyncId: freezed == orderSyncId ? _self.orderSyncId : orderSyncId // ignore: cast_nullable_to_non_nullable
as String?,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,station: null == station ? _self.station : station // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TicketStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<TicketItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [Ticket].
extension TicketPatterns on Ticket {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Ticket value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Ticket() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Ticket value)  $default,){
final _that = this;
switch (_that) {
case _Ticket():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Ticket value)?  $default,){
final _that = this;
switch (_that) {
case _Ticket() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int orderId,  String? orderSyncId,  String orderNumber,  String station,  DateTime createdAt,  TicketStatus status,  List<TicketItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Ticket() when $default != null:
return $default(_that.orderId,_that.orderSyncId,_that.orderNumber,_that.station,_that.createdAt,_that.status,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int orderId,  String? orderSyncId,  String orderNumber,  String station,  DateTime createdAt,  TicketStatus status,  List<TicketItem> items)  $default,) {final _that = this;
switch (_that) {
case _Ticket():
return $default(_that.orderId,_that.orderSyncId,_that.orderNumber,_that.station,_that.createdAt,_that.status,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int orderId,  String? orderSyncId,  String orderNumber,  String station,  DateTime createdAt,  TicketStatus status,  List<TicketItem> items)?  $default,) {final _that = this;
switch (_that) {
case _Ticket() when $default != null:
return $default(_that.orderId,_that.orderSyncId,_that.orderNumber,_that.station,_that.createdAt,_that.status,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _Ticket extends Ticket {
  const _Ticket({required this.orderId, this.orderSyncId, required this.orderNumber, required this.station, required this.createdAt, required this.status, required final  List<TicketItem> items}): _items = items,super._();
  

@override final  int orderId;
@override final  String? orderSyncId;
@override final  String orderNumber;
@override final  String station;
@override final  DateTime createdAt;
@override final  TicketStatus status;
 final  List<TicketItem> _items;
@override List<TicketItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of Ticket
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketCopyWith<_Ticket> get copyWith => __$TicketCopyWithImpl<_Ticket>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ticket&&(identical(other.orderId, orderId) || other.orderId == orderId)&&(identical(other.orderSyncId, orderSyncId) || other.orderSyncId == orderSyncId)&&(identical(other.orderNumber, orderNumber) || other.orderNumber == orderNumber)&&(identical(other.station, station) || other.station == station)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,orderId,orderSyncId,orderNumber,station,createdAt,status,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'Ticket(orderId: $orderId, orderSyncId: $orderSyncId, orderNumber: $orderNumber, station: $station, createdAt: $createdAt, status: $status, items: $items)';
}


}

/// @nodoc
abstract mixin class _$TicketCopyWith<$Res> implements $TicketCopyWith<$Res> {
  factory _$TicketCopyWith(_Ticket value, $Res Function(_Ticket) _then) = __$TicketCopyWithImpl;
@override @useResult
$Res call({
 int orderId, String? orderSyncId, String orderNumber, String station, DateTime createdAt, TicketStatus status, List<TicketItem> items
});




}
/// @nodoc
class __$TicketCopyWithImpl<$Res>
    implements _$TicketCopyWith<$Res> {
  __$TicketCopyWithImpl(this._self, this._then);

  final _Ticket _self;
  final $Res Function(_Ticket) _then;

/// Create a copy of Ticket
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? orderId = null,Object? orderSyncId = freezed,Object? orderNumber = null,Object? station = null,Object? createdAt = null,Object? status = null,Object? items = null,}) {
  return _then(_Ticket(
orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as int,orderSyncId: freezed == orderSyncId ? _self.orderSyncId : orderSyncId // ignore: cast_nullable_to_non_nullable
as String?,orderNumber: null == orderNumber ? _self.orderNumber : orderNumber // ignore: cast_nullable_to_non_nullable
as String,station: null == station ? _self.station : station // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TicketStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TicketItem>,
  ));
}


}

// dart format on
