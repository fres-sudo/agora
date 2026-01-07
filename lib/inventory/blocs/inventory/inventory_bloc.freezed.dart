// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InventoryEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InventoryEvent()';
}


}

/// @nodoc
class $InventoryEventCopyWith<$Res>  {
$InventoryEventCopyWith(InventoryEvent _, $Res Function(InventoryEvent) __);
}


/// Adds pattern-matching-related methods to [InventoryEvent].
extension InventoryEventPatterns on InventoryEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _ThresholdChanged value)?  thresholdChanged,TResult Function( _FilterChanged value)?  filterChanged,TResult Function( _Refresh value)?  refresh,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _ThresholdChanged() when thresholdChanged != null:
return thresholdChanged(_that);case _FilterChanged() when filterChanged != null:
return filterChanged(_that);case _Refresh() when refresh != null:
return refresh(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _ThresholdChanged value)  thresholdChanged,required TResult Function( _FilterChanged value)  filterChanged,required TResult Function( _Refresh value)  refresh,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _ThresholdChanged():
return thresholdChanged(_that);case _FilterChanged():
return filterChanged(_that);case _Refresh():
return refresh(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _ThresholdChanged value)?  thresholdChanged,TResult? Function( _FilterChanged value)?  filterChanged,TResult? Function( _Refresh value)?  refresh,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _ThresholdChanged() when thresholdChanged != null:
return thresholdChanged(_that);case _FilterChanged() when filterChanged != null:
return filterChanged(_that);case _Refresh() when refresh != null:
return refresh(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( int threshold)?  thresholdChanged,TResult Function( bool lowStockOnly)?  filterChanged,TResult Function()?  refresh,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _ThresholdChanged() when thresholdChanged != null:
return thresholdChanged(_that.threshold);case _FilterChanged() when filterChanged != null:
return filterChanged(_that.lowStockOnly);case _Refresh() when refresh != null:
return refresh();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( int threshold)  thresholdChanged,required TResult Function( bool lowStockOnly)  filterChanged,required TResult Function()  refresh,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _ThresholdChanged():
return thresholdChanged(_that.threshold);case _FilterChanged():
return filterChanged(_that.lowStockOnly);case _Refresh():
return refresh();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( int threshold)?  thresholdChanged,TResult? Function( bool lowStockOnly)?  filterChanged,TResult? Function()?  refresh,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _ThresholdChanged() when thresholdChanged != null:
return thresholdChanged(_that.threshold);case _FilterChanged() when filterChanged != null:
return filterChanged(_that.lowStockOnly);case _Refresh() when refresh != null:
return refresh();case _:
  return null;

}
}

}

/// @nodoc


class _Started implements InventoryEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InventoryEvent.started()';
}


}




/// @nodoc


class _ThresholdChanged implements InventoryEvent {
  const _ThresholdChanged(this.threshold);
  

 final  int threshold;

/// Create a copy of InventoryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ThresholdChangedCopyWith<_ThresholdChanged> get copyWith => __$ThresholdChangedCopyWithImpl<_ThresholdChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ThresholdChanged&&(identical(other.threshold, threshold) || other.threshold == threshold));
}


@override
int get hashCode => Object.hash(runtimeType,threshold);

@override
String toString() {
  return 'InventoryEvent.thresholdChanged(threshold: $threshold)';
}


}

/// @nodoc
abstract mixin class _$ThresholdChangedCopyWith<$Res> implements $InventoryEventCopyWith<$Res> {
  factory _$ThresholdChangedCopyWith(_ThresholdChanged value, $Res Function(_ThresholdChanged) _then) = __$ThresholdChangedCopyWithImpl;
@useResult
$Res call({
 int threshold
});




}
/// @nodoc
class __$ThresholdChangedCopyWithImpl<$Res>
    implements _$ThresholdChangedCopyWith<$Res> {
  __$ThresholdChangedCopyWithImpl(this._self, this._then);

  final _ThresholdChanged _self;
  final $Res Function(_ThresholdChanged) _then;

/// Create a copy of InventoryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? threshold = null,}) {
  return _then(_ThresholdChanged(
null == threshold ? _self.threshold : threshold // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _FilterChanged implements InventoryEvent {
  const _FilterChanged({required this.lowStockOnly});
  

 final  bool lowStockOnly;

/// Create a copy of InventoryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FilterChangedCopyWith<_FilterChanged> get copyWith => __$FilterChangedCopyWithImpl<_FilterChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FilterChanged&&(identical(other.lowStockOnly, lowStockOnly) || other.lowStockOnly == lowStockOnly));
}


@override
int get hashCode => Object.hash(runtimeType,lowStockOnly);

@override
String toString() {
  return 'InventoryEvent.filterChanged(lowStockOnly: $lowStockOnly)';
}


}

/// @nodoc
abstract mixin class _$FilterChangedCopyWith<$Res> implements $InventoryEventCopyWith<$Res> {
  factory _$FilterChangedCopyWith(_FilterChanged value, $Res Function(_FilterChanged) _then) = __$FilterChangedCopyWithImpl;
@useResult
$Res call({
 bool lowStockOnly
});




}
/// @nodoc
class __$FilterChangedCopyWithImpl<$Res>
    implements _$FilterChangedCopyWith<$Res> {
  __$FilterChangedCopyWithImpl(this._self, this._then);

  final _FilterChanged _self;
  final $Res Function(_FilterChanged) _then;

/// Create a copy of InventoryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? lowStockOnly = null,}) {
  return _then(_FilterChanged(
lowStockOnly: null == lowStockOnly ? _self.lowStockOnly : lowStockOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _Refresh implements InventoryEvent {
  const _Refresh();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Refresh);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InventoryEvent.refresh()';
}


}




/// @nodoc
mixin _$InventoryState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InventoryState()';
}


}

/// @nodoc
class $InventoryStateCopyWith<$Res>  {
$InventoryStateCopyWith(InventoryState _, $Res Function(InventoryState) __);
}


/// Adds pattern-matching-related methods to [InventoryState].
extension InventoryStatePatterns on InventoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( InventoryLoaded value)?  loaded,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case InventoryLoaded() when loaded != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( InventoryLoaded value)  loaded,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case InventoryLoaded():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( InventoryLoaded value)?  loaded,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case InventoryLoaded() when loaded != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Stock> stocks,  int lowStockCount,  int threshold,  bool showLowStockOnly)?  loaded,TResult Function( String message,  InventoryLoaded? previousState)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case InventoryLoaded() when loaded != null:
return loaded(_that.stocks,_that.lowStockCount,_that.threshold,_that.showLowStockOnly);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Stock> stocks,  int lowStockCount,  int threshold,  bool showLowStockOnly)  loaded,required TResult Function( String message,  InventoryLoaded? previousState)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case InventoryLoaded():
return loaded(_that.stocks,_that.lowStockCount,_that.threshold,_that.showLowStockOnly);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Stock> stocks,  int lowStockCount,  int threshold,  bool showLowStockOnly)?  loaded,TResult? Function( String message,  InventoryLoaded? previousState)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case InventoryLoaded() when loaded != null:
return loaded(_that.stocks,_that.lowStockCount,_that.threshold,_that.showLowStockOnly);case _Error() when error != null:
return error(_that.message,_that.previousState);case _:
  return null;

}
}

}

/// @nodoc


class _Initial extends InventoryState {
  const _Initial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InventoryState.initial()';
}


}




/// @nodoc


class _Loading extends InventoryState {
  const _Loading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'InventoryState.loading()';
}


}




/// @nodoc


class InventoryLoaded extends InventoryState {
  const InventoryLoaded({required final  List<Stock> stocks, required this.lowStockCount, required this.threshold, this.showLowStockOnly = false}): _stocks = stocks,super._();
  

 final  List<Stock> _stocks;
 List<Stock> get stocks {
  if (_stocks is EqualUnmodifiableListView) return _stocks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stocks);
}

 final  int lowStockCount;
 final  int threshold;
@JsonKey() final  bool showLowStockOnly;

/// Create a copy of InventoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryLoadedCopyWith<InventoryLoaded> get copyWith => _$InventoryLoadedCopyWithImpl<InventoryLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryLoaded&&const DeepCollectionEquality().equals(other._stocks, _stocks)&&(identical(other.lowStockCount, lowStockCount) || other.lowStockCount == lowStockCount)&&(identical(other.threshold, threshold) || other.threshold == threshold)&&(identical(other.showLowStockOnly, showLowStockOnly) || other.showLowStockOnly == showLowStockOnly));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_stocks),lowStockCount,threshold,showLowStockOnly);

@override
String toString() {
  return 'InventoryState.loaded(stocks: $stocks, lowStockCount: $lowStockCount, threshold: $threshold, showLowStockOnly: $showLowStockOnly)';
}


}

/// @nodoc
abstract mixin class $InventoryLoadedCopyWith<$Res> implements $InventoryStateCopyWith<$Res> {
  factory $InventoryLoadedCopyWith(InventoryLoaded value, $Res Function(InventoryLoaded) _then) = _$InventoryLoadedCopyWithImpl;
@useResult
$Res call({
 List<Stock> stocks, int lowStockCount, int threshold, bool showLowStockOnly
});




}
/// @nodoc
class _$InventoryLoadedCopyWithImpl<$Res>
    implements $InventoryLoadedCopyWith<$Res> {
  _$InventoryLoadedCopyWithImpl(this._self, this._then);

  final InventoryLoaded _self;
  final $Res Function(InventoryLoaded) _then;

/// Create a copy of InventoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? stocks = null,Object? lowStockCount = null,Object? threshold = null,Object? showLowStockOnly = null,}) {
  return _then(InventoryLoaded(
stocks: null == stocks ? _self._stocks : stocks // ignore: cast_nullable_to_non_nullable
as List<Stock>,lowStockCount: null == lowStockCount ? _self.lowStockCount : lowStockCount // ignore: cast_nullable_to_non_nullable
as int,threshold: null == threshold ? _self.threshold : threshold // ignore: cast_nullable_to_non_nullable
as int,showLowStockOnly: null == showLowStockOnly ? _self.showLowStockOnly : showLowStockOnly // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _Error extends InventoryState {
  const _Error({required this.message, this.previousState}): super._();
  

 final  String message;
 final  InventoryLoaded? previousState;

/// Create a copy of InventoryState
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
  return 'InventoryState.error(message: $message, previousState: $previousState)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $InventoryStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message, InventoryLoaded? previousState
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of InventoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? previousState = freezed,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,previousState: freezed == previousState ? _self.previousState : previousState // ignore: cast_nullable_to_non_nullable
as InventoryLoaded?,
  ));
}


}

// dart format on
