// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discounts_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiscountsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscountsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DiscountsEvent()';
}


}

/// @nodoc
class $DiscountsEventCopyWith<$Res>  {
$DiscountsEventCopyWith(DiscountsEvent _, $Res Function(DiscountsEvent) __);
}


/// Adds pattern-matching-related methods to [DiscountsEvent].
extension DiscountsEventPatterns on DiscountsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _Created value)?  created,TResult Function( _Updated value)?  updated,TResult Function( _Toggled value)?  toggled,TResult Function( _Deleted value)?  deleted,TResult Function( _FilterChanged value)?  filterChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _Created() when created != null:
return created(_that);case _Updated() when updated != null:
return updated(_that);case _Toggled() when toggled != null:
return toggled(_that);case _Deleted() when deleted != null:
return deleted(_that);case _FilterChanged() when filterChanged != null:
return filterChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _Created value)  created,required TResult Function( _Updated value)  updated,required TResult Function( _Toggled value)  toggled,required TResult Function( _Deleted value)  deleted,required TResult Function( _FilterChanged value)  filterChanged,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _Created():
return created(_that);case _Updated():
return updated(_that);case _Toggled():
return toggled(_that);case _Deleted():
return deleted(_that);case _FilterChanged():
return filterChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _Created value)?  created,TResult? Function( _Updated value)?  updated,TResult? Function( _Toggled value)?  toggled,TResult? Function( _Deleted value)?  deleted,TResult? Function( _FilterChanged value)?  filterChanged,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _Created() when created != null:
return created(_that);case _Updated() when updated != null:
return updated(_that);case _Toggled() when toggled != null:
return toggled(_that);case _Deleted() when deleted != null:
return deleted(_that);case _FilterChanged() when filterChanged != null:
return filterChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( Discount discount)?  created,TResult Function( Discount discount)?  updated,TResult Function( int id,  bool isActive)?  toggled,TResult Function( int id)?  deleted,TResult Function( bool activeOnly)?  filterChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _Created() when created != null:
return created(_that.discount);case _Updated() when updated != null:
return updated(_that.discount);case _Toggled() when toggled != null:
return toggled(_that.id,_that.isActive);case _Deleted() when deleted != null:
return deleted(_that.id);case _FilterChanged() when filterChanged != null:
return filterChanged(_that.activeOnly);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( Discount discount)  created,required TResult Function( Discount discount)  updated,required TResult Function( int id,  bool isActive)  toggled,required TResult Function( int id)  deleted,required TResult Function( bool activeOnly)  filterChanged,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _Created():
return created(_that.discount);case _Updated():
return updated(_that.discount);case _Toggled():
return toggled(_that.id,_that.isActive);case _Deleted():
return deleted(_that.id);case _FilterChanged():
return filterChanged(_that.activeOnly);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( Discount discount)?  created,TResult? Function( Discount discount)?  updated,TResult? Function( int id,  bool isActive)?  toggled,TResult? Function( int id)?  deleted,TResult? Function( bool activeOnly)?  filterChanged,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _Created() when created != null:
return created(_that.discount);case _Updated() when updated != null:
return updated(_that.discount);case _Toggled() when toggled != null:
return toggled(_that.id,_that.isActive);case _Deleted() when deleted != null:
return deleted(_that.id);case _FilterChanged() when filterChanged != null:
return filterChanged(_that.activeOnly);case _:
  return null;

}
}

}

/// @nodoc


class _Started implements DiscountsEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DiscountsEvent.started()';
}


}




/// @nodoc


class _Created implements DiscountsEvent {
  const _Created(this.discount);
  

 final  Discount discount;

/// Create a copy of DiscountsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatedCopyWith<_Created> get copyWith => __$CreatedCopyWithImpl<_Created>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Created&&(identical(other.discount, discount) || other.discount == discount));
}


@override
int get hashCode => Object.hash(runtimeType,discount);

@override
String toString() {
  return 'DiscountsEvent.created(discount: $discount)';
}


}

/// @nodoc
abstract mixin class _$CreatedCopyWith<$Res> implements $DiscountsEventCopyWith<$Res> {
  factory _$CreatedCopyWith(_Created value, $Res Function(_Created) _then) = __$CreatedCopyWithImpl;
@useResult
$Res call({
 Discount discount
});


$DiscountCopyWith<$Res> get discount;

}
/// @nodoc
class __$CreatedCopyWithImpl<$Res>
    implements _$CreatedCopyWith<$Res> {
  __$CreatedCopyWithImpl(this._self, this._then);

  final _Created _self;
  final $Res Function(_Created) _then;

/// Create a copy of DiscountsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? discount = null,}) {
  return _then(_Created(
null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as Discount,
  ));
}

/// Create a copy of DiscountsEvent
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


class _Updated implements DiscountsEvent {
  const _Updated(this.discount);
  

 final  Discount discount;

/// Create a copy of DiscountsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdatedCopyWith<_Updated> get copyWith => __$UpdatedCopyWithImpl<_Updated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Updated&&(identical(other.discount, discount) || other.discount == discount));
}


@override
int get hashCode => Object.hash(runtimeType,discount);

@override
String toString() {
  return 'DiscountsEvent.updated(discount: $discount)';
}


}

/// @nodoc
abstract mixin class _$UpdatedCopyWith<$Res> implements $DiscountsEventCopyWith<$Res> {
  factory _$UpdatedCopyWith(_Updated value, $Res Function(_Updated) _then) = __$UpdatedCopyWithImpl;
@useResult
$Res call({
 Discount discount
});


$DiscountCopyWith<$Res> get discount;

}
/// @nodoc
class __$UpdatedCopyWithImpl<$Res>
    implements _$UpdatedCopyWith<$Res> {
  __$UpdatedCopyWithImpl(this._self, this._then);

  final _Updated _self;
  final $Res Function(_Updated) _then;

/// Create a copy of DiscountsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? discount = null,}) {
  return _then(_Updated(
null == discount ? _self.discount : discount // ignore: cast_nullable_to_non_nullable
as Discount,
  ));
}

/// Create a copy of DiscountsEvent
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


class _Toggled implements DiscountsEvent {
  const _Toggled({required this.id, required this.isActive});
  

 final  int id;
 final  bool isActive;

/// Create a copy of DiscountsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ToggledCopyWith<_Toggled> get copyWith => __$ToggledCopyWithImpl<_Toggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Toggled&&(identical(other.id, id) || other.id == id)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}


@override
int get hashCode => Object.hash(runtimeType,id,isActive);

@override
String toString() {
  return 'DiscountsEvent.toggled(id: $id, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$ToggledCopyWith<$Res> implements $DiscountsEventCopyWith<$Res> {
  factory _$ToggledCopyWith(_Toggled value, $Res Function(_Toggled) _then) = __$ToggledCopyWithImpl;
@useResult
$Res call({
 int id, bool isActive
});




}
/// @nodoc
class __$ToggledCopyWithImpl<$Res>
    implements _$ToggledCopyWith<$Res> {
  __$ToggledCopyWithImpl(this._self, this._then);

  final _Toggled _self;
  final $Res Function(_Toggled) _then;

/// Create a copy of DiscountsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? isActive = null,}) {
  return _then(_Toggled(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _Deleted implements DiscountsEvent {
  const _Deleted(this.id);
  

 final  int id;

/// Create a copy of DiscountsEvent
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
  return 'DiscountsEvent.deleted(id: $id)';
}


}

/// @nodoc
abstract mixin class _$DeletedCopyWith<$Res> implements $DiscountsEventCopyWith<$Res> {
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

/// Create a copy of DiscountsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_Deleted(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _FilterChanged implements DiscountsEvent {
  const _FilterChanged({required this.activeOnly});
  

 final  bool activeOnly;

/// Create a copy of DiscountsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FilterChangedCopyWith<_FilterChanged> get copyWith => __$FilterChangedCopyWithImpl<_FilterChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FilterChanged&&(identical(other.activeOnly, activeOnly) || other.activeOnly == activeOnly));
}


@override
int get hashCode => Object.hash(runtimeType,activeOnly);

@override
String toString() {
  return 'DiscountsEvent.filterChanged(activeOnly: $activeOnly)';
}


}

/// @nodoc
abstract mixin class _$FilterChangedCopyWith<$Res> implements $DiscountsEventCopyWith<$Res> {
  factory _$FilterChangedCopyWith(_FilterChanged value, $Res Function(_FilterChanged) _then) = __$FilterChangedCopyWithImpl;
@useResult
$Res call({
 bool activeOnly
});




}
/// @nodoc
class __$FilterChangedCopyWithImpl<$Res>
    implements _$FilterChangedCopyWith<$Res> {
  __$FilterChangedCopyWithImpl(this._self, this._then);

  final _FilterChanged _self;
  final $Res Function(_FilterChanged) _then;

/// Create a copy of DiscountsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? activeOnly = null,}) {
  return _then(_FilterChanged(
activeOnly: null == activeOnly ? _self.activeOnly : activeOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$DiscountsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscountsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DiscountsState()';
}


}

/// @nodoc
class $DiscountsStateCopyWith<$Res>  {
$DiscountsStateCopyWith(DiscountsState _, $Res Function(DiscountsState) __);
}


/// Adds pattern-matching-related methods to [DiscountsState].
extension DiscountsStatePatterns on DiscountsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( DiscountsLoaded value)?  loaded,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case DiscountsLoaded() when loaded != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( DiscountsLoaded value)  loaded,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case DiscountsLoaded():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( DiscountsLoaded value)?  loaded,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case DiscountsLoaded() when loaded != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Discount> discounts,  bool showActiveOnly)?  loaded,TResult Function( String message,  DiscountsLoaded? previousState)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case DiscountsLoaded() when loaded != null:
return loaded(_that.discounts,_that.showActiveOnly);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Discount> discounts,  bool showActiveOnly)  loaded,required TResult Function( String message,  DiscountsLoaded? previousState)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case DiscountsLoaded():
return loaded(_that.discounts,_that.showActiveOnly);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Discount> discounts,  bool showActiveOnly)?  loaded,TResult? Function( String message,  DiscountsLoaded? previousState)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case DiscountsLoaded() when loaded != null:
return loaded(_that.discounts,_that.showActiveOnly);case _Error() when error != null:
return error(_that.message,_that.previousState);case _:
  return null;

}
}

}

/// @nodoc


class _Initial extends DiscountsState {
  const _Initial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DiscountsState.initial()';
}


}




/// @nodoc


class _Loading extends DiscountsState {
  const _Loading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DiscountsState.loading()';
}


}




/// @nodoc


class DiscountsLoaded extends DiscountsState {
  const DiscountsLoaded({required final  List<Discount> discounts, this.showActiveOnly = false}): _discounts = discounts,super._();
  

 final  List<Discount> _discounts;
 List<Discount> get discounts {
  if (_discounts is EqualUnmodifiableListView) return _discounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_discounts);
}

@JsonKey() final  bool showActiveOnly;

/// Create a copy of DiscountsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscountsLoadedCopyWith<DiscountsLoaded> get copyWith => _$DiscountsLoadedCopyWithImpl<DiscountsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscountsLoaded&&const DeepCollectionEquality().equals(other._discounts, _discounts)&&(identical(other.showActiveOnly, showActiveOnly) || other.showActiveOnly == showActiveOnly));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_discounts),showActiveOnly);

@override
String toString() {
  return 'DiscountsState.loaded(discounts: $discounts, showActiveOnly: $showActiveOnly)';
}


}

/// @nodoc
abstract mixin class $DiscountsLoadedCopyWith<$Res> implements $DiscountsStateCopyWith<$Res> {
  factory $DiscountsLoadedCopyWith(DiscountsLoaded value, $Res Function(DiscountsLoaded) _then) = _$DiscountsLoadedCopyWithImpl;
@useResult
$Res call({
 List<Discount> discounts, bool showActiveOnly
});




}
/// @nodoc
class _$DiscountsLoadedCopyWithImpl<$Res>
    implements $DiscountsLoadedCopyWith<$Res> {
  _$DiscountsLoadedCopyWithImpl(this._self, this._then);

  final DiscountsLoaded _self;
  final $Res Function(DiscountsLoaded) _then;

/// Create a copy of DiscountsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? discounts = null,Object? showActiveOnly = null,}) {
  return _then(DiscountsLoaded(
discounts: null == discounts ? _self._discounts : discounts // ignore: cast_nullable_to_non_nullable
as List<Discount>,showActiveOnly: null == showActiveOnly ? _self.showActiveOnly : showActiveOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _Error extends DiscountsState {
  const _Error({required this.message, this.previousState}): super._();
  

 final  String message;
 final  DiscountsLoaded? previousState;

/// Create a copy of DiscountsState
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
  return 'DiscountsState.error(message: $message, previousState: $previousState)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $DiscountsStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message, DiscountsLoaded? previousState
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of DiscountsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? previousState = freezed,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,previousState: freezed == previousState ? _self.previousState : previousState // ignore: cast_nullable_to_non_nullable
as DiscountsLoaded?,
  ));
}


}

// dart format on
