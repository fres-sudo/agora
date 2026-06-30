// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clock_in_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClockInState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClockInState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ClockInState()';
}


}

/// @nodoc
class $ClockInStateCopyWith<$Res>  {
$ClockInStateCopyWith(ClockInState _, $Res Function(ClockInState) __);
}


/// Adds pattern-matching-related methods to [ClockInState].
extension ClockInStatePatterns on ClockInState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _ClockedIn value)?  clockedIn,TResult Function( _ClockedOut value)?  clockedOut,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _ClockedIn() when clockedIn != null:
return clockedIn(_that);case _ClockedOut() when clockedOut != null:
return clockedOut(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _ClockedIn value)  clockedIn,required TResult Function( _ClockedOut value)  clockedOut,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _ClockedIn():
return clockedIn(_that);case _ClockedOut():
return clockedOut(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _ClockedIn value)?  clockedIn,TResult? Function( _ClockedOut value)?  clockedOut,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _ClockedIn() when clockedIn != null:
return clockedIn(_that);case _ClockedOut() when clockedOut != null:
return clockedOut(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( ClockRecord record)?  clockedIn,TResult Function()?  clockedOut,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _ClockedIn() when clockedIn != null:
return clockedIn(_that.record);case _ClockedOut() when clockedOut != null:
return clockedOut();case _Error() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( ClockRecord record)  clockedIn,required TResult Function()  clockedOut,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _ClockedIn():
return clockedIn(_that.record);case _ClockedOut():
return clockedOut();case _Error():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( ClockRecord record)?  clockedIn,TResult? Function()?  clockedOut,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _ClockedIn() when clockedIn != null:
return clockedIn(_that.record);case _ClockedOut() when clockedOut != null:
return clockedOut();case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements ClockInState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ClockInState.initial()';
}


}




/// @nodoc


class _Loading implements ClockInState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ClockInState.loading()';
}


}




/// @nodoc


class _ClockedIn implements ClockInState {
  const _ClockedIn(this.record);
  

 final  ClockRecord record;

/// Create a copy of ClockInState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClockedInCopyWith<_ClockedIn> get copyWith => __$ClockedInCopyWithImpl<_ClockedIn>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClockedIn&&(identical(other.record, record) || other.record == record));
}


@override
int get hashCode => Object.hash(runtimeType,record);

@override
String toString() {
  return 'ClockInState.clockedIn(record: $record)';
}


}

/// @nodoc
abstract mixin class _$ClockedInCopyWith<$Res> implements $ClockInStateCopyWith<$Res> {
  factory _$ClockedInCopyWith(_ClockedIn value, $Res Function(_ClockedIn) _then) = __$ClockedInCopyWithImpl;
@useResult
$Res call({
 ClockRecord record
});


$ClockRecordCopyWith<$Res> get record;

}
/// @nodoc
class __$ClockedInCopyWithImpl<$Res>
    implements _$ClockedInCopyWith<$Res> {
  __$ClockedInCopyWithImpl(this._self, this._then);

  final _ClockedIn _self;
  final $Res Function(_ClockedIn) _then;

/// Create a copy of ClockInState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? record = null,}) {
  return _then(_ClockedIn(
null == record ? _self.record : record // ignore: cast_nullable_to_non_nullable
as ClockRecord,
  ));
}

/// Create a copy of ClockInState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ClockRecordCopyWith<$Res> get record {
  
  return $ClockRecordCopyWith<$Res>(_self.record, (value) {
    return _then(_self.copyWith(record: value));
  });
}
}

/// @nodoc


class _ClockedOut implements ClockInState {
  const _ClockedOut();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClockedOut);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ClockInState.clockedOut()';
}


}




/// @nodoc


class _Error implements ClockInState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of ClockInState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ClockInState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $ClockInStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of ClockInState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
