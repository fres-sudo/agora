// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'combos_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CombosEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CombosEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CombosEvent()';
}


}

/// @nodoc
class $CombosEventCopyWith<$Res>  {
$CombosEventCopyWith(CombosEvent _, $Res Function(CombosEvent) __);
}


/// Adds pattern-matching-related methods to [CombosEvent].
extension CombosEventPatterns on CombosEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _Created value)?  created,TResult Function( _Updated value)?  updated,TResult Function( _Deleted value)?  deleted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _Created() when created != null:
return created(_that);case _Updated() when updated != null:
return updated(_that);case _Deleted() when deleted != null:
return deleted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _Created value)  created,required TResult Function( _Updated value)  updated,required TResult Function( _Deleted value)  deleted,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _Created():
return created(_that);case _Updated():
return updated(_that);case _Deleted():
return deleted(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _Created value)?  created,TResult? Function( _Updated value)?  updated,TResult? Function( _Deleted value)?  deleted,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _Created() when created != null:
return created(_that);case _Updated() when updated != null:
return updated(_that);case _Deleted() when deleted != null:
return deleted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( Combo combo)?  created,TResult Function( Combo combo)?  updated,TResult Function( int id)?  deleted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _Created() when created != null:
return created(_that.combo);case _Updated() when updated != null:
return updated(_that.combo);case _Deleted() when deleted != null:
return deleted(_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( Combo combo)  created,required TResult Function( Combo combo)  updated,required TResult Function( int id)  deleted,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _Created():
return created(_that.combo);case _Updated():
return updated(_that.combo);case _Deleted():
return deleted(_that.id);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( Combo combo)?  created,TResult? Function( Combo combo)?  updated,TResult? Function( int id)?  deleted,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _Created() when created != null:
return created(_that.combo);case _Updated() when updated != null:
return updated(_that.combo);case _Deleted() when deleted != null:
return deleted(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements CombosEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CombosEvent.started()';
}


}




/// @nodoc


class _Created implements CombosEvent {
  const _Created(this.combo);
  

 final  Combo combo;

/// Create a copy of CombosEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatedCopyWith<_Created> get copyWith => __$CreatedCopyWithImpl<_Created>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Created&&(identical(other.combo, combo) || other.combo == combo));
}


@override
int get hashCode => Object.hash(runtimeType,combo);

@override
String toString() {
  return 'CombosEvent.created(combo: $combo)';
}


}

/// @nodoc
abstract mixin class _$CreatedCopyWith<$Res> implements $CombosEventCopyWith<$Res> {
  factory _$CreatedCopyWith(_Created value, $Res Function(_Created) _then) = __$CreatedCopyWithImpl;
@useResult
$Res call({
 Combo combo
});


$ComboCopyWith<$Res> get combo;

}
/// @nodoc
class __$CreatedCopyWithImpl<$Res>
    implements _$CreatedCopyWith<$Res> {
  __$CreatedCopyWithImpl(this._self, this._then);

  final _Created _self;
  final $Res Function(_Created) _then;

/// Create a copy of CombosEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? combo = null,}) {
  return _then(_Created(
null == combo ? _self.combo : combo // ignore: cast_nullable_to_non_nullable
as Combo,
  ));
}

/// Create a copy of CombosEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComboCopyWith<$Res> get combo {
  
  return $ComboCopyWith<$Res>(_self.combo, (value) {
    return _then(_self.copyWith(combo: value));
  });
}
}

/// @nodoc


class _Updated implements CombosEvent {
  const _Updated(this.combo);
  

 final  Combo combo;

/// Create a copy of CombosEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdatedCopyWith<_Updated> get copyWith => __$UpdatedCopyWithImpl<_Updated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Updated&&(identical(other.combo, combo) || other.combo == combo));
}


@override
int get hashCode => Object.hash(runtimeType,combo);

@override
String toString() {
  return 'CombosEvent.updated(combo: $combo)';
}


}

/// @nodoc
abstract mixin class _$UpdatedCopyWith<$Res> implements $CombosEventCopyWith<$Res> {
  factory _$UpdatedCopyWith(_Updated value, $Res Function(_Updated) _then) = __$UpdatedCopyWithImpl;
@useResult
$Res call({
 Combo combo
});


$ComboCopyWith<$Res> get combo;

}
/// @nodoc
class __$UpdatedCopyWithImpl<$Res>
    implements _$UpdatedCopyWith<$Res> {
  __$UpdatedCopyWithImpl(this._self, this._then);

  final _Updated _self;
  final $Res Function(_Updated) _then;

/// Create a copy of CombosEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? combo = null,}) {
  return _then(_Updated(
null == combo ? _self.combo : combo // ignore: cast_nullable_to_non_nullable
as Combo,
  ));
}

/// Create a copy of CombosEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComboCopyWith<$Res> get combo {
  
  return $ComboCopyWith<$Res>(_self.combo, (value) {
    return _then(_self.copyWith(combo: value));
  });
}
}

/// @nodoc


class _Deleted implements CombosEvent {
  const _Deleted(this.id);
  

 final  int id;

/// Create a copy of CombosEvent
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
  return 'CombosEvent.deleted(id: $id)';
}


}

/// @nodoc
abstract mixin class _$DeletedCopyWith<$Res> implements $CombosEventCopyWith<$Res> {
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

/// Create a copy of CombosEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_Deleted(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$CombosState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CombosState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CombosState()';
}


}

/// @nodoc
class $CombosStateCopyWith<$Res>  {
$CombosStateCopyWith(CombosState _, $Res Function(CombosState) __);
}


/// Adds pattern-matching-related methods to [CombosState].
extension CombosStatePatterns on CombosState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( CombosLoaded value)?  loaded,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case CombosLoaded() when loaded != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( CombosLoaded value)  loaded,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case CombosLoaded():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( CombosLoaded value)?  loaded,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case CombosLoaded() when loaded != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Combo> combos)?  loaded,TResult Function( String message,  CombosLoaded? previousState)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case CombosLoaded() when loaded != null:
return loaded(_that.combos);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Combo> combos)  loaded,required TResult Function( String message,  CombosLoaded? previousState)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case CombosLoaded():
return loaded(_that.combos);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Combo> combos)?  loaded,TResult? Function( String message,  CombosLoaded? previousState)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case CombosLoaded() when loaded != null:
return loaded(_that.combos);case _Error() when error != null:
return error(_that.message,_that.previousState);case _:
  return null;

}
}

}

/// @nodoc


class _Initial extends CombosState {
  const _Initial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CombosState.initial()';
}


}




/// @nodoc


class _Loading extends CombosState {
  const _Loading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CombosState.loading()';
}


}




/// @nodoc


class CombosLoaded extends CombosState {
  const CombosLoaded({required final  List<Combo> combos}): _combos = combos,super._();
  

 final  List<Combo> _combos;
 List<Combo> get combos {
  if (_combos is EqualUnmodifiableListView) return _combos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_combos);
}


/// Create a copy of CombosState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CombosLoadedCopyWith<CombosLoaded> get copyWith => _$CombosLoadedCopyWithImpl<CombosLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CombosLoaded&&const DeepCollectionEquality().equals(other._combos, _combos));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_combos));

@override
String toString() {
  return 'CombosState.loaded(combos: $combos)';
}


}

/// @nodoc
abstract mixin class $CombosLoadedCopyWith<$Res> implements $CombosStateCopyWith<$Res> {
  factory $CombosLoadedCopyWith(CombosLoaded value, $Res Function(CombosLoaded) _then) = _$CombosLoadedCopyWithImpl;
@useResult
$Res call({
 List<Combo> combos
});




}
/// @nodoc
class _$CombosLoadedCopyWithImpl<$Res>
    implements $CombosLoadedCopyWith<$Res> {
  _$CombosLoadedCopyWithImpl(this._self, this._then);

  final CombosLoaded _self;
  final $Res Function(CombosLoaded) _then;

/// Create a copy of CombosState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? combos = null,}) {
  return _then(CombosLoaded(
combos: null == combos ? _self._combos : combos // ignore: cast_nullable_to_non_nullable
as List<Combo>,
  ));
}


}

/// @nodoc


class _Error extends CombosState {
  const _Error({required this.message, this.previousState}): super._();
  

 final  String message;
 final  CombosLoaded? previousState;

/// Create a copy of CombosState
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
  return 'CombosState.error(message: $message, previousState: $previousState)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $CombosStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message, CombosLoaded? previousState
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of CombosState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? previousState = freezed,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,previousState: freezed == previousState ? _self.previousState : previousState // ignore: cast_nullable_to_non_nullable
as CombosLoaded?,
  ));
}


}

// dart format on
