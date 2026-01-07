// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'active_order_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActiveOrderEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActiveOrderEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ActiveOrderEvent()';
}


}

/// @nodoc
class $ActiveOrderEventCopyWith<$Res>  {
$ActiveOrderEventCopyWith(ActiveOrderEvent _, $Res Function(ActiveOrderEvent) __);
}


/// Adds pattern-matching-related methods to [ActiveOrderEvent].
extension ActiveOrderEventPatterns on ActiveOrderEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _ItemAdded value)?  itemAdded,TResult Function( _ItemRemoved value)?  itemRemoved,TResult Function( _ItemQuantityChanged value)?  itemQuantityChanged,TResult Function( _DiscountApplied value)?  discountApplied,TResult Function( _DiscountRemoved value)?  discountRemoved,TResult Function( _NoteUpdated value)?  noteUpdated,TResult Function( _Submitted value)?  submitted,TResult Function( _Cleared value)?  cleared,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _ItemAdded() when itemAdded != null:
return itemAdded(_that);case _ItemRemoved() when itemRemoved != null:
return itemRemoved(_that);case _ItemQuantityChanged() when itemQuantityChanged != null:
return itemQuantityChanged(_that);case _DiscountApplied() when discountApplied != null:
return discountApplied(_that);case _DiscountRemoved() when discountRemoved != null:
return discountRemoved(_that);case _NoteUpdated() when noteUpdated != null:
return noteUpdated(_that);case _Submitted() when submitted != null:
return submitted(_that);case _Cleared() when cleared != null:
return cleared(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _ItemAdded value)  itemAdded,required TResult Function( _ItemRemoved value)  itemRemoved,required TResult Function( _ItemQuantityChanged value)  itemQuantityChanged,required TResult Function( _DiscountApplied value)  discountApplied,required TResult Function( _DiscountRemoved value)  discountRemoved,required TResult Function( _NoteUpdated value)  noteUpdated,required TResult Function( _Submitted value)  submitted,required TResult Function( _Cleared value)  cleared,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _ItemAdded():
return itemAdded(_that);case _ItemRemoved():
return itemRemoved(_that);case _ItemQuantityChanged():
return itemQuantityChanged(_that);case _DiscountApplied():
return discountApplied(_that);case _DiscountRemoved():
return discountRemoved(_that);case _NoteUpdated():
return noteUpdated(_that);case _Submitted():
return submitted(_that);case _Cleared():
return cleared(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _ItemAdded value)?  itemAdded,TResult? Function( _ItemRemoved value)?  itemRemoved,TResult? Function( _ItemQuantityChanged value)?  itemQuantityChanged,TResult? Function( _DiscountApplied value)?  discountApplied,TResult? Function( _DiscountRemoved value)?  discountRemoved,TResult? Function( _NoteUpdated value)?  noteUpdated,TResult? Function( _Submitted value)?  submitted,TResult? Function( _Cleared value)?  cleared,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _ItemAdded() when itemAdded != null:
return itemAdded(_that);case _ItemRemoved() when itemRemoved != null:
return itemRemoved(_that);case _ItemQuantityChanged() when itemQuantityChanged != null:
return itemQuantityChanged(_that);case _DiscountApplied() when discountApplied != null:
return discountApplied(_that);case _DiscountRemoved() when discountRemoved != null:
return discountRemoved(_that);case _NoteUpdated() when noteUpdated != null:
return noteUpdated(_that);case _Submitted() when submitted != null:
return submitted(_that);case _Cleared() when cleared != null:
return cleared(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( Product product,  int quantity,  List<ModifierOption> modifiers)?  itemAdded,TResult Function( int productId)?  itemRemoved,TResult Function( int productId,  int quantity)?  itemQuantityChanged,TResult Function( Discount discount)?  discountApplied,TResult Function()?  discountRemoved,TResult Function( String note)?  noteUpdated,TResult Function()?  submitted,TResult Function()?  cleared,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _ItemAdded() when itemAdded != null:
return itemAdded(_that.product,_that.quantity,_that.modifiers);case _ItemRemoved() when itemRemoved != null:
return itemRemoved(_that.productId);case _ItemQuantityChanged() when itemQuantityChanged != null:
return itemQuantityChanged(_that.productId,_that.quantity);case _DiscountApplied() when discountApplied != null:
return discountApplied(_that.discount);case _DiscountRemoved() when discountRemoved != null:
return discountRemoved();case _NoteUpdated() when noteUpdated != null:
return noteUpdated(_that.note);case _Submitted() when submitted != null:
return submitted();case _Cleared() when cleared != null:
return cleared();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( Product product,  int quantity,  List<ModifierOption> modifiers)  itemAdded,required TResult Function( int productId)  itemRemoved,required TResult Function( int productId,  int quantity)  itemQuantityChanged,required TResult Function( Discount discount)  discountApplied,required TResult Function()  discountRemoved,required TResult Function( String note)  noteUpdated,required TResult Function()  submitted,required TResult Function()  cleared,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _ItemAdded():
return itemAdded(_that.product,_that.quantity,_that.modifiers);case _ItemRemoved():
return itemRemoved(_that.productId);case _ItemQuantityChanged():
return itemQuantityChanged(_that.productId,_that.quantity);case _DiscountApplied():
return discountApplied(_that.discount);case _DiscountRemoved():
return discountRemoved();case _NoteUpdated():
return noteUpdated(_that.note);case _Submitted():
return submitted();case _Cleared():
return cleared();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( Product product,  int quantity,  List<ModifierOption> modifiers)?  itemAdded,TResult? Function( int productId)?  itemRemoved,TResult? Function( int productId,  int quantity)?  itemQuantityChanged,TResult? Function( Discount discount)?  discountApplied,TResult? Function()?  discountRemoved,TResult? Function( String note)?  noteUpdated,TResult? Function()?  submitted,TResult? Function()?  cleared,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _ItemAdded() when itemAdded != null:
return itemAdded(_that.product,_that.quantity,_that.modifiers);case _ItemRemoved() when itemRemoved != null:
return itemRemoved(_that.productId);case _ItemQuantityChanged() when itemQuantityChanged != null:
return itemQuantityChanged(_that.productId,_that.quantity);case _DiscountApplied() when discountApplied != null:
return discountApplied(_that.discount);case _DiscountRemoved() when discountRemoved != null:
return discountRemoved();case _NoteUpdated() when noteUpdated != null:
return noteUpdated(_that.note);case _Submitted() when submitted != null:
return submitted();case _Cleared() when cleared != null:
return cleared();case _:
  return null;

}
}

}

/// @nodoc


class _Started implements ActiveOrderEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ActiveOrderEvent.started()';
}


}




/// @nodoc


class _ItemAdded implements ActiveOrderEvent {
  const _ItemAdded({required this.product, this.quantity = 1, final  List<ModifierOption> modifiers = const []}): _modifiers = modifiers;
  

 final  Product product;
@JsonKey() final  int quantity;
 final  List<ModifierOption> _modifiers;
@JsonKey() List<ModifierOption> get modifiers {
  if (_modifiers is EqualUnmodifiableListView) return _modifiers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_modifiers);
}


/// Create a copy of ActiveOrderEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemAddedCopyWith<_ItemAdded> get copyWith => __$ItemAddedCopyWithImpl<_ItemAdded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemAdded&&(identical(other.product, product) || other.product == product)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&const DeepCollectionEquality().equals(other._modifiers, _modifiers));
}


@override
int get hashCode => Object.hash(runtimeType,product,quantity,const DeepCollectionEquality().hash(_modifiers));

@override
String toString() {
  return 'ActiveOrderEvent.itemAdded(product: $product, quantity: $quantity, modifiers: $modifiers)';
}


}

/// @nodoc
abstract mixin class _$ItemAddedCopyWith<$Res> implements $ActiveOrderEventCopyWith<$Res> {
  factory _$ItemAddedCopyWith(_ItemAdded value, $Res Function(_ItemAdded) _then) = __$ItemAddedCopyWithImpl;
@useResult
$Res call({
 Product product, int quantity, List<ModifierOption> modifiers
});


$ProductCopyWith<$Res> get product;

}
/// @nodoc
class __$ItemAddedCopyWithImpl<$Res>
    implements _$ItemAddedCopyWith<$Res> {
  __$ItemAddedCopyWithImpl(this._self, this._then);

  final _ItemAdded _self;
  final $Res Function(_ItemAdded) _then;

/// Create a copy of ActiveOrderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? product = null,Object? quantity = null,Object? modifiers = null,}) {
  return _then(_ItemAdded(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as Product,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,modifiers: null == modifiers ? _self._modifiers : modifiers // ignore: cast_nullable_to_non_nullable
as List<ModifierOption>,
  ));
}

/// Create a copy of ActiveOrderEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCopyWith<$Res> get product {
  
  return $ProductCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}

/// @nodoc


class _ItemRemoved implements ActiveOrderEvent {
  const _ItemRemoved(this.productId);
  

 final  int productId;

/// Create a copy of ActiveOrderEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemRemovedCopyWith<_ItemRemoved> get copyWith => __$ItemRemovedCopyWithImpl<_ItemRemoved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemRemoved&&(identical(other.productId, productId) || other.productId == productId));
}


@override
int get hashCode => Object.hash(runtimeType,productId);

@override
String toString() {
  return 'ActiveOrderEvent.itemRemoved(productId: $productId)';
}


}

/// @nodoc
abstract mixin class _$ItemRemovedCopyWith<$Res> implements $ActiveOrderEventCopyWith<$Res> {
  factory _$ItemRemovedCopyWith(_ItemRemoved value, $Res Function(_ItemRemoved) _then) = __$ItemRemovedCopyWithImpl;
@useResult
$Res call({
 int productId
});




}
/// @nodoc
class __$ItemRemovedCopyWithImpl<$Res>
    implements _$ItemRemovedCopyWith<$Res> {
  __$ItemRemovedCopyWithImpl(this._self, this._then);

  final _ItemRemoved _self;
  final $Res Function(_ItemRemoved) _then;

/// Create a copy of ActiveOrderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? productId = null,}) {
  return _then(_ItemRemoved(
null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _ItemQuantityChanged implements ActiveOrderEvent {
  const _ItemQuantityChanged({required this.productId, required this.quantity});
  

 final  int productId;
 final  int quantity;

/// Create a copy of ActiveOrderEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemQuantityChangedCopyWith<_ItemQuantityChanged> get copyWith => __$ItemQuantityChangedCopyWithImpl<_ItemQuantityChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemQuantityChanged&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,productId,quantity);

@override
String toString() {
  return 'ActiveOrderEvent.itemQuantityChanged(productId: $productId, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$ItemQuantityChangedCopyWith<$Res> implements $ActiveOrderEventCopyWith<$Res> {
  factory _$ItemQuantityChangedCopyWith(_ItemQuantityChanged value, $Res Function(_ItemQuantityChanged) _then) = __$ItemQuantityChangedCopyWithImpl;
@useResult
$Res call({
 int productId, int quantity
});




}
/// @nodoc
class __$ItemQuantityChangedCopyWithImpl<$Res>
    implements _$ItemQuantityChangedCopyWith<$Res> {
  __$ItemQuantityChangedCopyWithImpl(this._self, this._then);

  final _ItemQuantityChanged _self;
  final $Res Function(_ItemQuantityChanged) _then;

/// Create a copy of ActiveOrderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? quantity = null,}) {
  return _then(_ItemQuantityChanged(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _DiscountApplied implements ActiveOrderEvent {
  const _DiscountApplied(this.discount);
  

 final  Discount discount;

/// Create a copy of ActiveOrderEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscountAppliedCopyWith<_DiscountApplied> get copyWith => __$DiscountAppliedCopyWithImpl<_DiscountApplied>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscountApplied&&(identical(other.discount, discount) || other.discount == discount));
}


@override
int get hashCode => Object.hash(runtimeType,discount);

@override
String toString() {
  return 'ActiveOrderEvent.discountApplied(discount: $discount)';
}


}

/// @nodoc
abstract mixin class _$DiscountAppliedCopyWith<$Res> implements $ActiveOrderEventCopyWith<$Res> {
  factory _$DiscountAppliedCopyWith(_DiscountApplied value, $Res Function(_DiscountApplied) _then) = __$DiscountAppliedCopyWithImpl;
@useResult
$Res call({
 Discount discount
});


$DiscountCopyWith<$Res> get discount;

}
/// @nodoc
class __$DiscountAppliedCopyWithImpl<$Res>
    implements _$DiscountAppliedCopyWith<$Res> {
  __$DiscountAppliedCopyWithImpl(this._self, this._then);

  final _DiscountApplied _self;
  final $Res Function(_DiscountApplied) _then;

/// Create a copy of ActiveOrderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? discount = null,}) {
  return _then(_DiscountApplied(
null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as Discount,
  ));
}

/// Create a copy of ActiveOrderEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiscountCopyWith<$Res> get discount {
  
  return $DiscountCopyWith<$Res>(_self.discount, (value) {
    return _then(_self.copyWith(discount: value));
  });
}
}

/// @nodoc


class _DiscountRemoved implements ActiveOrderEvent {
  const _DiscountRemoved();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscountRemoved);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ActiveOrderEvent.discountRemoved()';
}


}




/// @nodoc


class _NoteUpdated implements ActiveOrderEvent {
  const _NoteUpdated(this.note);
  

 final  String note;

/// Create a copy of ActiveOrderEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoteUpdatedCopyWith<_NoteUpdated> get copyWith => __$NoteUpdatedCopyWithImpl<_NoteUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoteUpdated&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,note);

@override
String toString() {
  return 'ActiveOrderEvent.noteUpdated(note: $note)';
}


}

/// @nodoc
abstract mixin class _$NoteUpdatedCopyWith<$Res> implements $ActiveOrderEventCopyWith<$Res> {
  factory _$NoteUpdatedCopyWith(_NoteUpdated value, $Res Function(_NoteUpdated) _then) = __$NoteUpdatedCopyWithImpl;
@useResult
$Res call({
 String note
});




}
/// @nodoc
class __$NoteUpdatedCopyWithImpl<$Res>
    implements _$NoteUpdatedCopyWith<$Res> {
  __$NoteUpdatedCopyWithImpl(this._self, this._then);

  final _NoteUpdated _self;
  final $Res Function(_NoteUpdated) _then;

/// Create a copy of ActiveOrderEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? note = null,}) {
  return _then(_NoteUpdated(
null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Submitted implements ActiveOrderEvent {
  const _Submitted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Submitted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ActiveOrderEvent.submitted()';
}


}




/// @nodoc


class _Cleared implements ActiveOrderEvent {
  const _Cleared();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Cleared);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ActiveOrderEvent.cleared()';
}


}




/// @nodoc
mixin _$ActiveOrderState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActiveOrderState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ActiveOrderState()';
}


}

/// @nodoc
class $ActiveOrderStateCopyWith<$Res>  {
$ActiveOrderStateCopyWith(ActiveOrderState _, $Res Function(ActiveOrderState) __);
}


/// Adds pattern-matching-related methods to [ActiveOrderState].
extension ActiveOrderStatePatterns on ActiveOrderState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Empty value)?  empty,TResult Function( ActiveOrderBuilding value)?  building,TResult Function( _Submitting value)?  submitting,TResult Function( OrderSubmitted value)?  submitted,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Empty() when empty != null:
return empty(_that);case ActiveOrderBuilding() when building != null:
return building(_that);case _Submitting() when submitting != null:
return submitting(_that);case OrderSubmitted() when submitted != null:
return submitted(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Empty value)  empty,required TResult Function( ActiveOrderBuilding value)  building,required TResult Function( _Submitting value)  submitting,required TResult Function( OrderSubmitted value)  submitted,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Empty():
return empty(_that);case ActiveOrderBuilding():
return building(_that);case _Submitting():
return submitting(_that);case OrderSubmitted():
return submitted(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Empty value)?  empty,TResult? Function( ActiveOrderBuilding value)?  building,TResult? Function( _Submitting value)?  submitting,TResult? Function( OrderSubmitted value)?  submitted,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Empty() when empty != null:
return empty(_that);case ActiveOrderBuilding() when building != null:
return building(_that);case _Submitting() when submitting != null:
return submitting(_that);case OrderSubmitted() when submitted != null:
return submitted(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  empty,TResult Function( Order order,  Discount? appliedDiscount)?  building,TResult Function( Order order)?  submitting,TResult Function( Order order)?  submitted,TResult Function( String message,  Order? order)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Empty() when empty != null:
return empty();case ActiveOrderBuilding() when building != null:
return building(_that.order,_that.appliedDiscount);case _Submitting() when submitting != null:
return submitting(_that.order);case OrderSubmitted() when submitted != null:
return submitted(_that.order);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  empty,required TResult Function( Order order,  Discount? appliedDiscount)  building,required TResult Function( Order order)  submitting,required TResult Function( Order order)  submitted,required TResult Function( String message,  Order? order)  error,}) {final _that = this;
switch (_that) {
case _Empty():
return empty();case ActiveOrderBuilding():
return building(_that.order,_that.appliedDiscount);case _Submitting():
return submitting(_that.order);case OrderSubmitted():
return submitted(_that.order);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  empty,TResult? Function( Order order,  Discount? appliedDiscount)?  building,TResult? Function( Order order)?  submitting,TResult? Function( Order order)?  submitted,TResult? Function( String message,  Order? order)?  error,}) {final _that = this;
switch (_that) {
case _Empty() when empty != null:
return empty();case ActiveOrderBuilding() when building != null:
return building(_that.order,_that.appliedDiscount);case _Submitting() when submitting != null:
return submitting(_that.order);case OrderSubmitted() when submitted != null:
return submitted(_that.order);case _Error() when error != null:
return error(_that.message,_that.order);case _:
  return null;

}
}

}

/// @nodoc


class _Empty extends ActiveOrderState {
  const _Empty(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Empty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ActiveOrderState.empty()';
}


}




/// @nodoc


class ActiveOrderBuilding extends ActiveOrderState {
  const ActiveOrderBuilding({required this.order, this.appliedDiscount = null}): super._();
  

 final  Order order;
@JsonKey() final  Discount? appliedDiscount;

/// Create a copy of ActiveOrderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActiveOrderBuildingCopyWith<ActiveOrderBuilding> get copyWith => _$ActiveOrderBuildingCopyWithImpl<ActiveOrderBuilding>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActiveOrderBuilding&&(identical(other.order, order) || other.order == order)&&(identical(other.appliedDiscount, appliedDiscount) || other.appliedDiscount == appliedDiscount));
}


@override
int get hashCode => Object.hash(runtimeType,order,appliedDiscount);

@override
String toString() {
  return 'ActiveOrderState.building(order: $order, appliedDiscount: $appliedDiscount)';
}


}

/// @nodoc
abstract mixin class $ActiveOrderBuildingCopyWith<$Res> implements $ActiveOrderStateCopyWith<$Res> {
  factory $ActiveOrderBuildingCopyWith(ActiveOrderBuilding value, $Res Function(ActiveOrderBuilding) _then) = _$ActiveOrderBuildingCopyWithImpl;
@useResult
$Res call({
 Order order, Discount? appliedDiscount
});


$OrderCopyWith<$Res> get order;$DiscountCopyWith<$Res>? get appliedDiscount;

}
/// @nodoc
class _$ActiveOrderBuildingCopyWithImpl<$Res>
    implements $ActiveOrderBuildingCopyWith<$Res> {
  _$ActiveOrderBuildingCopyWithImpl(this._self, this._then);

  final ActiveOrderBuilding _self;
  final $Res Function(ActiveOrderBuilding) _then;

/// Create a copy of ActiveOrderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? order = null,Object? appliedDiscount = freezed,}) {
  return _then(ActiveOrderBuilding(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as Order,appliedDiscount: freezed == appliedDiscount ? _self.appliedDiscount : appliedDiscount // ignore: cast_nullable_to_non_nullable
as Discount?,
  ));
}

/// Create a copy of ActiveOrderState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrderCopyWith<$Res> get order {
  
  return $OrderCopyWith<$Res>(_self.order, (value) {
    return _then(_self.copyWith(order: value));
  });
}/// Create a copy of ActiveOrderState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiscountCopyWith<$Res>? get appliedDiscount {
    if (_self.appliedDiscount == null) {
    return null;
  }

  return $DiscountCopyWith<$Res>(_self.appliedDiscount!, (value) {
    return _then(_self.copyWith(appliedDiscount: value));
  });
}
}

/// @nodoc


class _Submitting extends ActiveOrderState {
  const _Submitting({required this.order}): super._();
  

 final  Order order;

/// Create a copy of ActiveOrderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmittingCopyWith<_Submitting> get copyWith => __$SubmittingCopyWithImpl<_Submitting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Submitting&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,order);

@override
String toString() {
  return 'ActiveOrderState.submitting(order: $order)';
}


}

/// @nodoc
abstract mixin class _$SubmittingCopyWith<$Res> implements $ActiveOrderStateCopyWith<$Res> {
  factory _$SubmittingCopyWith(_Submitting value, $Res Function(_Submitting) _then) = __$SubmittingCopyWithImpl;
@useResult
$Res call({
 Order order
});


$OrderCopyWith<$Res> get order;

}
/// @nodoc
class __$SubmittingCopyWithImpl<$Res>
    implements _$SubmittingCopyWith<$Res> {
  __$SubmittingCopyWithImpl(this._self, this._then);

  final _Submitting _self;
  final $Res Function(_Submitting) _then;

/// Create a copy of ActiveOrderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? order = null,}) {
  return _then(_Submitting(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as Order,
  ));
}

/// Create a copy of ActiveOrderState
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


class OrderSubmitted extends ActiveOrderState {
  const OrderSubmitted({required this.order}): super._();
  

 final  Order order;

/// Create a copy of ActiveOrderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderSubmittedCopyWith<OrderSubmitted> get copyWith => _$OrderSubmittedCopyWithImpl<OrderSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderSubmitted&&(identical(other.order, order) || other.order == order));
}


@override
int get hashCode => Object.hash(runtimeType,order);

@override
String toString() {
  return 'ActiveOrderState.submitted(order: $order)';
}


}

/// @nodoc
abstract mixin class $OrderSubmittedCopyWith<$Res> implements $ActiveOrderStateCopyWith<$Res> {
  factory $OrderSubmittedCopyWith(OrderSubmitted value, $Res Function(OrderSubmitted) _then) = _$OrderSubmittedCopyWithImpl;
@useResult
$Res call({
 Order order
});


$OrderCopyWith<$Res> get order;

}
/// @nodoc
class _$OrderSubmittedCopyWithImpl<$Res>
    implements $OrderSubmittedCopyWith<$Res> {
  _$OrderSubmittedCopyWithImpl(this._self, this._then);

  final OrderSubmitted _self;
  final $Res Function(OrderSubmitted) _then;

/// Create a copy of ActiveOrderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? order = null,}) {
  return _then(OrderSubmitted(
order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as Order,
  ));
}

/// Create a copy of ActiveOrderState
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


class _Error extends ActiveOrderState {
  const _Error({required this.message, this.order}): super._();
  

 final  String message;
 final  Order? order;

/// Create a copy of ActiveOrderState
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
  return 'ActiveOrderState.error(message: $message, order: $order)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $ActiveOrderStateCopyWith<$Res> {
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

/// Create a copy of ActiveOrderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? order = freezed,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as Order?,
  ));
}

/// Create a copy of ActiveOrderState
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
