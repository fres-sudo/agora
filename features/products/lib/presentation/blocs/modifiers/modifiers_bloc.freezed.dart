// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'modifiers_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ModifiersEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModifiersEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ModifiersEvent()';
}


}

/// @nodoc
class $ModifiersEventCopyWith<$Res>  {
$ModifiersEventCopyWith(ModifiersEvent _, $Res Function(ModifiersEvent) __);
}


/// Adds pattern-matching-related methods to [ModifiersEvent].
extension ModifiersEventPatterns on ModifiersEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _Created value)?  created,TResult Function( _Updated value)?  updated,TResult Function( _Deleted value)?  deleted,TResult Function( _LinkedToProduct value)?  linkedToProduct,TResult Function( _UnlinkedFromProduct value)?  unlinkedFromProduct,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _Created() when created != null:
return created(_that);case _Updated() when updated != null:
return updated(_that);case _Deleted() when deleted != null:
return deleted(_that);case _LinkedToProduct() when linkedToProduct != null:
return linkedToProduct(_that);case _UnlinkedFromProduct() when unlinkedFromProduct != null:
return unlinkedFromProduct(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _Created value)  created,required TResult Function( _Updated value)  updated,required TResult Function( _Deleted value)  deleted,required TResult Function( _LinkedToProduct value)  linkedToProduct,required TResult Function( _UnlinkedFromProduct value)  unlinkedFromProduct,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _Created():
return created(_that);case _Updated():
return updated(_that);case _Deleted():
return deleted(_that);case _LinkedToProduct():
return linkedToProduct(_that);case _UnlinkedFromProduct():
return unlinkedFromProduct(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _Created value)?  created,TResult? Function( _Updated value)?  updated,TResult? Function( _Deleted value)?  deleted,TResult? Function( _LinkedToProduct value)?  linkedToProduct,TResult? Function( _UnlinkedFromProduct value)?  unlinkedFromProduct,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _Created() when created != null:
return created(_that);case _Updated() when updated != null:
return updated(_that);case _Deleted() when deleted != null:
return deleted(_that);case _LinkedToProduct() when linkedToProduct != null:
return linkedToProduct(_that);case _UnlinkedFromProduct() when unlinkedFromProduct != null:
return unlinkedFromProduct(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( ModifierGroup modifierGroup)?  created,TResult Function( ModifierGroup modifierGroup)?  updated,TResult Function( int id)?  deleted,TResult Function( int productId,  int modifierId)?  linkedToProduct,TResult Function( int productId,  int modifierId)?  unlinkedFromProduct,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _Created() when created != null:
return created(_that.modifierGroup);case _Updated() when updated != null:
return updated(_that.modifierGroup);case _Deleted() when deleted != null:
return deleted(_that.id);case _LinkedToProduct() when linkedToProduct != null:
return linkedToProduct(_that.productId,_that.modifierId);case _UnlinkedFromProduct() when unlinkedFromProduct != null:
return unlinkedFromProduct(_that.productId,_that.modifierId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( ModifierGroup modifierGroup)  created,required TResult Function( ModifierGroup modifierGroup)  updated,required TResult Function( int id)  deleted,required TResult Function( int productId,  int modifierId)  linkedToProduct,required TResult Function( int productId,  int modifierId)  unlinkedFromProduct,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _Created():
return created(_that.modifierGroup);case _Updated():
return updated(_that.modifierGroup);case _Deleted():
return deleted(_that.id);case _LinkedToProduct():
return linkedToProduct(_that.productId,_that.modifierId);case _UnlinkedFromProduct():
return unlinkedFromProduct(_that.productId,_that.modifierId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( ModifierGroup modifierGroup)?  created,TResult? Function( ModifierGroup modifierGroup)?  updated,TResult? Function( int id)?  deleted,TResult? Function( int productId,  int modifierId)?  linkedToProduct,TResult? Function( int productId,  int modifierId)?  unlinkedFromProduct,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _Created() when created != null:
return created(_that.modifierGroup);case _Updated() when updated != null:
return updated(_that.modifierGroup);case _Deleted() when deleted != null:
return deleted(_that.id);case _LinkedToProduct() when linkedToProduct != null:
return linkedToProduct(_that.productId,_that.modifierId);case _UnlinkedFromProduct() when unlinkedFromProduct != null:
return unlinkedFromProduct(_that.productId,_that.modifierId);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements ModifiersEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ModifiersEvent.started()';
}


}




/// @nodoc


class _Created implements ModifiersEvent {
  const _Created(this.modifierGroup);
  

 final  ModifierGroup modifierGroup;

/// Create a copy of ModifiersEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatedCopyWith<_Created> get copyWith => __$CreatedCopyWithImpl<_Created>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Created&&(identical(other.modifierGroup, modifierGroup) || other.modifierGroup == modifierGroup));
}


@override
int get hashCode => Object.hash(runtimeType,modifierGroup);

@override
String toString() {
  return 'ModifiersEvent.created(modifierGroup: $modifierGroup)';
}


}

/// @nodoc
abstract mixin class _$CreatedCopyWith<$Res> implements $ModifiersEventCopyWith<$Res> {
  factory _$CreatedCopyWith(_Created value, $Res Function(_Created) _then) = __$CreatedCopyWithImpl;
@useResult
$Res call({
 ModifierGroup modifierGroup
});


$ModifierGroupCopyWith<$Res> get modifierGroup;

}
/// @nodoc
class __$CreatedCopyWithImpl<$Res>
    implements _$CreatedCopyWith<$Res> {
  __$CreatedCopyWithImpl(this._self, this._then);

  final _Created _self;
  final $Res Function(_Created) _then;

/// Create a copy of ModifiersEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? modifierGroup = null,}) {
  return _then(_Created(
null == modifierGroup ? _self.modifierGroup : modifierGroup // ignore: cast_nullable_to_non_nullable
as ModifierGroup,
  ));
}

/// Create a copy of ModifiersEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModifierGroupCopyWith<$Res> get modifierGroup {
  
  return $ModifierGroupCopyWith<$Res>(_self.modifierGroup, (value) {
    return _then(_self.copyWith(modifierGroup: value));
  });
}
}

/// @nodoc


class _Updated implements ModifiersEvent {
  const _Updated(this.modifierGroup);
  

 final  ModifierGroup modifierGroup;

/// Create a copy of ModifiersEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdatedCopyWith<_Updated> get copyWith => __$UpdatedCopyWithImpl<_Updated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Updated&&(identical(other.modifierGroup, modifierGroup) || other.modifierGroup == modifierGroup));
}


@override
int get hashCode => Object.hash(runtimeType,modifierGroup);

@override
String toString() {
  return 'ModifiersEvent.updated(modifierGroup: $modifierGroup)';
}


}

/// @nodoc
abstract mixin class _$UpdatedCopyWith<$Res> implements $ModifiersEventCopyWith<$Res> {
  factory _$UpdatedCopyWith(_Updated value, $Res Function(_Updated) _then) = __$UpdatedCopyWithImpl;
@useResult
$Res call({
 ModifierGroup modifierGroup
});


$ModifierGroupCopyWith<$Res> get modifierGroup;

}
/// @nodoc
class __$UpdatedCopyWithImpl<$Res>
    implements _$UpdatedCopyWith<$Res> {
  __$UpdatedCopyWithImpl(this._self, this._then);

  final _Updated _self;
  final $Res Function(_Updated) _then;

/// Create a copy of ModifiersEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? modifierGroup = null,}) {
  return _then(_Updated(
null == modifierGroup ? _self.modifierGroup : modifierGroup // ignore: cast_nullable_to_non_nullable
as ModifierGroup,
  ));
}

/// Create a copy of ModifiersEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ModifierGroupCopyWith<$Res> get modifierGroup {
  
  return $ModifierGroupCopyWith<$Res>(_self.modifierGroup, (value) {
    return _then(_self.copyWith(modifierGroup: value));
  });
}
}

/// @nodoc


class _Deleted implements ModifiersEvent {
  const _Deleted(this.id);
  

 final  int id;

/// Create a copy of ModifiersEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeletedCopyWith<_Deleted> get copyWith => __$DeletedCopyWithImpl<_Deleted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Deleted&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'ModifiersEvent.deleted(id: $id)';
}


}

/// @nodoc
abstract mixin class _$DeletedCopyWith<$Res> implements $ModifiersEventCopyWith<$Res> {
  factory _$DeletedCopyWith(_Deleted value, $Res Function(_Deleted) _then) = __$DeletedCopyWithImpl;
@useResult
$Res call({
 int id
});




}
/// @nodoc
class __$DeletedCopyWithImpl<$Res>
    implements _$DeletedCopyWith<$Res> {
  __$DeletedCopyWithImpl(this._self, this._then);

  final _Deleted _self;
  final $Res Function(_Deleted) _then;

/// Create a copy of ModifiersEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_Deleted(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _LinkedToProduct implements ModifiersEvent {
  const _LinkedToProduct({required this.productId, required this.modifierId});
  

 final  int productId;
 final  int modifierId;

/// Create a copy of ModifiersEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LinkedToProductCopyWith<_LinkedToProduct> get copyWith => __$LinkedToProductCopyWithImpl<_LinkedToProduct>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LinkedToProduct&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.modifierId, modifierId) || other.modifierId == modifierId));
}


@override
int get hashCode => Object.hash(runtimeType,productId,modifierId);

@override
String toString() {
  return 'ModifiersEvent.linkedToProduct(productId: $productId, modifierId: $modifierId)';
}


}

/// @nodoc
abstract mixin class _$LinkedToProductCopyWith<$Res> implements $ModifiersEventCopyWith<$Res> {
  factory _$LinkedToProductCopyWith(_LinkedToProduct value, $Res Function(_LinkedToProduct) _then) = __$LinkedToProductCopyWithImpl;
@useResult
$Res call({
 int productId, int modifierId
});




}
/// @nodoc
class __$LinkedToProductCopyWithImpl<$Res>
    implements _$LinkedToProductCopyWith<$Res> {
  __$LinkedToProductCopyWithImpl(this._self, this._then);

  final _LinkedToProduct _self;
  final $Res Function(_LinkedToProduct) _then;

/// Create a copy of ModifiersEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? modifierId = null,}) {
  return _then(_LinkedToProduct(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,modifierId: null == modifierId ? _self.modifierId : modifierId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _UnlinkedFromProduct implements ModifiersEvent {
  const _UnlinkedFromProduct({required this.productId, required this.modifierId});
  

 final  int productId;
 final  int modifierId;

/// Create a copy of ModifiersEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnlinkedFromProductCopyWith<_UnlinkedFromProduct> get copyWith => __$UnlinkedFromProductCopyWithImpl<_UnlinkedFromProduct>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnlinkedFromProduct&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.modifierId, modifierId) || other.modifierId == modifierId));
}


@override
int get hashCode => Object.hash(runtimeType,productId,modifierId);

@override
String toString() {
  return 'ModifiersEvent.unlinkedFromProduct(productId: $productId, modifierId: $modifierId)';
}


}

/// @nodoc
abstract mixin class _$UnlinkedFromProductCopyWith<$Res> implements $ModifiersEventCopyWith<$Res> {
  factory _$UnlinkedFromProductCopyWith(_UnlinkedFromProduct value, $Res Function(_UnlinkedFromProduct) _then) = __$UnlinkedFromProductCopyWithImpl;
@useResult
$Res call({
 int productId, int modifierId
});




}
/// @nodoc
class __$UnlinkedFromProductCopyWithImpl<$Res>
    implements _$UnlinkedFromProductCopyWith<$Res> {
  __$UnlinkedFromProductCopyWithImpl(this._self, this._then);

  final _UnlinkedFromProduct _self;
  final $Res Function(_UnlinkedFromProduct) _then;

/// Create a copy of ModifiersEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? modifierId = null,}) {
  return _then(_UnlinkedFromProduct(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,modifierId: null == modifierId ? _self.modifierId : modifierId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$ModifiersState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModifiersState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ModifiersState()';
}


}

/// @nodoc
class $ModifiersStateCopyWith<$Res>  {
$ModifiersStateCopyWith(ModifiersState _, $Res Function(ModifiersState) __);
}


/// Adds pattern-matching-related methods to [ModifiersState].
extension ModifiersStatePatterns on ModifiersState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( ModifiersLoaded value)?  loaded,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case ModifiersLoaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( ModifiersLoaded value)  loaded,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case ModifiersLoaded():
return loaded(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( ModifiersLoaded value)?  loaded,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case ModifiersLoaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<ModifierGroup> modifiers)?  loaded,TResult Function( String message,  ModifiersLoaded? previousState)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case ModifiersLoaded() when loaded != null:
return loaded(_that.modifiers);case _Error() when error != null:
return error(_that.message,_that.previousState);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<ModifierGroup> modifiers)  loaded,required TResult Function( String message,  ModifiersLoaded? previousState)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case ModifiersLoaded():
return loaded(_that.modifiers);case _Error():
return error(_that.message,_that.previousState);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<ModifierGroup> modifiers)?  loaded,TResult? Function( String message,  ModifiersLoaded? previousState)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case ModifiersLoaded() when loaded != null:
return loaded(_that.modifiers);case _Error() when error != null:
return error(_that.message,_that.previousState);case _:
  return null;

}
}

}

/// @nodoc


class _Initial extends ModifiersState {
  const _Initial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ModifiersState.initial()';
}


}




/// @nodoc


class _Loading extends ModifiersState {
  const _Loading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ModifiersState.loading()';
}


}




/// @nodoc


class ModifiersLoaded extends ModifiersState {
  const ModifiersLoaded({required final  List<ModifierGroup> modifiers}): _modifiers = modifiers,super._();
  

 final  List<ModifierGroup> _modifiers;
 List<ModifierGroup> get modifiers {
  if (_modifiers is EqualUnmodifiableListView) return _modifiers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_modifiers);
}


/// Create a copy of ModifiersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModifiersLoadedCopyWith<ModifiersLoaded> get copyWith => _$ModifiersLoadedCopyWithImpl<ModifiersLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModifiersLoaded&&const DeepCollectionEquality().equals(other._modifiers, _modifiers));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_modifiers));

@override
String toString() {
  return 'ModifiersState.loaded(modifiers: $modifiers)';
}


}

/// @nodoc
abstract mixin class $ModifiersLoadedCopyWith<$Res> implements $ModifiersStateCopyWith<$Res> {
  factory $ModifiersLoadedCopyWith(ModifiersLoaded value, $Res Function(ModifiersLoaded) _then) = _$ModifiersLoadedCopyWithImpl;
@useResult
$Res call({
 List<ModifierGroup> modifiers
});




}
/// @nodoc
class _$ModifiersLoadedCopyWithImpl<$Res>
    implements $ModifiersLoadedCopyWith<$Res> {
  _$ModifiersLoadedCopyWithImpl(this._self, this._then);

  final ModifiersLoaded _self;
  final $Res Function(ModifiersLoaded) _then;

/// Create a copy of ModifiersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? modifiers = null,}) {
  return _then(ModifiersLoaded(
modifiers: null == modifiers ? _self._modifiers : modifiers // ignore: cast_nullable_to_non_nullable
as List<ModifierGroup>,
  ));
}


}

/// @nodoc


class _Error extends ModifiersState {
  const _Error({required this.message, this.previousState}): super._();
  

 final  String message;
 final  ModifiersLoaded? previousState;

/// Create a copy of ModifiersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.previousState, previousState));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(previousState));

@override
String toString() {
  return 'ModifiersState.error(message: $message, previousState: $previousState)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $ModifiersStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message, ModifiersLoaded? previousState
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of ModifiersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? previousState = freezed,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,previousState: freezed == previousState ? _self.previousState : previousState // ignore: cast_nullable_to_non_nullable
as ModifiersLoaded?,
  ));
}


}

// dart format on
