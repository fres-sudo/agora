// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConfigState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConfigState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConfigState()';
}


}

/// @nodoc
class $ConfigStateCopyWith<$Res>  {
$ConfigStateCopyWith(ConfigState _, $Res Function(ConfigState) __);
}


/// Adds pattern-matching-related methods to [ConfigState].
extension ConfigStatePatterns on ConfigState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadingConfigState value)?  loading,TResult Function( FetchedConfigState value)?  fetched,TResult Function( ErrorConfigState value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadingConfigState() when loading != null:
return loading(_that);case FetchedConfigState() when fetched != null:
return fetched(_that);case ErrorConfigState() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadingConfigState value)  loading,required TResult Function( FetchedConfigState value)  fetched,required TResult Function( ErrorConfigState value)  error,}){
final _that = this;
switch (_that) {
case LoadingConfigState():
return loading(_that);case FetchedConfigState():
return fetched(_that);case ErrorConfigState():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadingConfigState value)?  loading,TResult? Function( FetchedConfigState value)?  fetched,TResult? Function( ErrorConfigState value)?  error,}){
final _that = this;
switch (_that) {
case LoadingConfigState() when loading != null:
return loading(_that);case FetchedConfigState() when fetched != null:
return fetched(_that);case ErrorConfigState() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( RemoteConfig config)?  fetched,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadingConfigState() when loading != null:
return loading();case FetchedConfigState() when fetched != null:
return fetched(_that.config);case ErrorConfigState() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( RemoteConfig config)  fetched,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case LoadingConfigState():
return loading();case FetchedConfigState():
return fetched(_that.config);case ErrorConfigState():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( RemoteConfig config)?  fetched,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case LoadingConfigState() when loading != null:
return loading();case FetchedConfigState() when fetched != null:
return fetched(_that.config);case ErrorConfigState() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class LoadingConfigState implements ConfigState {
  const LoadingConfigState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadingConfigState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ConfigState.loading()';
}


}




/// @nodoc


class FetchedConfigState implements ConfigState {
  const FetchedConfigState(this.config);
  

 final  RemoteConfig config;

/// Create a copy of ConfigState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FetchedConfigStateCopyWith<FetchedConfigState> get copyWith => _$FetchedConfigStateCopyWithImpl<FetchedConfigState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FetchedConfigState&&(identical(other.config, config) || other.config == config));
}


@override
int get hashCode => Object.hash(runtimeType,config);

@override
String toString() {
  return 'ConfigState.fetched(config: $config)';
}


}

/// @nodoc
abstract mixin class $FetchedConfigStateCopyWith<$Res> implements $ConfigStateCopyWith<$Res> {
  factory $FetchedConfigStateCopyWith(FetchedConfigState value, $Res Function(FetchedConfigState) _then) = _$FetchedConfigStateCopyWithImpl;
@useResult
$Res call({
 RemoteConfig config
});


$RemoteConfigCopyWith<$Res> get config;

}
/// @nodoc
class _$FetchedConfigStateCopyWithImpl<$Res>
    implements $FetchedConfigStateCopyWith<$Res> {
  _$FetchedConfigStateCopyWithImpl(this._self, this._then);

  final FetchedConfigState _self;
  final $Res Function(FetchedConfigState) _then;

/// Create a copy of ConfigState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? config = null,}) {
  return _then(FetchedConfigState(
null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as RemoteConfig,
  ));
}

/// Create a copy of ConfigState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RemoteConfigCopyWith<$Res> get config {
  
  return $RemoteConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}

/// @nodoc


class ErrorConfigState implements ConfigState {
  const ErrorConfigState(this.message);
  

 final  String message;

/// Create a copy of ConfigState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ErrorConfigStateCopyWith<ErrorConfigState> get copyWith => _$ErrorConfigStateCopyWithImpl<ErrorConfigState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorConfigState&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ConfigState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ErrorConfigStateCopyWith<$Res> implements $ConfigStateCopyWith<$Res> {
  factory $ErrorConfigStateCopyWith(ErrorConfigState value, $Res Function(ErrorConfigState) _then) = _$ErrorConfigStateCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ErrorConfigStateCopyWithImpl<$Res>
    implements $ErrorConfigStateCopyWith<$Res> {
  _$ErrorConfigStateCopyWithImpl(this._self, this._then);

  final ErrorConfigState _self;
  final $Res Function(ErrorConfigState) _then;

/// Create a copy of ConfigState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ErrorConfigState(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
