// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'url_launcher_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UrlLauncherEvent {

 Uri get uri; LaunchMode get mode;
/// Create a copy of UrlLauncherEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UrlLauncherEventCopyWith<UrlLauncherEvent> get copyWith => _$UrlLauncherEventCopyWithImpl<UrlLauncherEvent>(this as UrlLauncherEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UrlLauncherEvent&&(identical(other.uri, uri) || other.uri == uri)&&(identical(other.mode, mode) || other.mode == mode));
}


@override
int get hashCode => Object.hash(runtimeType,uri,mode);

@override
String toString() {
  return 'UrlLauncherEvent(uri: $uri, mode: $mode)';
}


}

/// @nodoc
abstract mixin class $UrlLauncherEventCopyWith<$Res>  {
  factory $UrlLauncherEventCopyWith(UrlLauncherEvent value, $Res Function(UrlLauncherEvent) _then) = _$UrlLauncherEventCopyWithImpl;
@useResult
$Res call({
 Uri uri, LaunchMode mode
});




}
/// @nodoc
class _$UrlLauncherEventCopyWithImpl<$Res>
    implements $UrlLauncherEventCopyWith<$Res> {
  _$UrlLauncherEventCopyWithImpl(this._self, this._then);

  final UrlLauncherEvent _self;
  final $Res Function(UrlLauncherEvent) _then;

/// Create a copy of UrlLauncherEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uri = null,Object? mode = null,}) {
  return _then(_self.copyWith(
uri: null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as Uri,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as LaunchMode,
  ));
}

}


/// Adds pattern-matching-related methods to [UrlLauncherEvent].
extension UrlLauncherEventPatterns on UrlLauncherEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ExecuteUrlLauncherEvent value)?  execute,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ExecuteUrlLauncherEvent() when execute != null:
return execute(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ExecuteUrlLauncherEvent value)  execute,}){
final _that = this;
switch (_that) {
case ExecuteUrlLauncherEvent():
return execute(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ExecuteUrlLauncherEvent value)?  execute,}){
final _that = this;
switch (_that) {
case ExecuteUrlLauncherEvent() when execute != null:
return execute(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Uri uri,  LaunchMode mode)?  execute,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ExecuteUrlLauncherEvent() when execute != null:
return execute(_that.uri,_that.mode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Uri uri,  LaunchMode mode)  execute,}) {final _that = this;
switch (_that) {
case ExecuteUrlLauncherEvent():
return execute(_that.uri,_that.mode);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Uri uri,  LaunchMode mode)?  execute,}) {final _that = this;
switch (_that) {
case ExecuteUrlLauncherEvent() when execute != null:
return execute(_that.uri,_that.mode);case _:
  return null;

}
}

}

/// @nodoc


class ExecuteUrlLauncherEvent implements UrlLauncherEvent {
  const ExecuteUrlLauncherEvent(this.uri, {this.mode = LaunchMode.platformDefault});
  

@override final  Uri uri;
@override@JsonKey() final  LaunchMode mode;

/// Create a copy of UrlLauncherEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExecuteUrlLauncherEventCopyWith<ExecuteUrlLauncherEvent> get copyWith => _$ExecuteUrlLauncherEventCopyWithImpl<ExecuteUrlLauncherEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExecuteUrlLauncherEvent&&(identical(other.uri, uri) || other.uri == uri)&&(identical(other.mode, mode) || other.mode == mode));
}


@override
int get hashCode => Object.hash(runtimeType,uri,mode);

@override
String toString() {
  return 'UrlLauncherEvent.execute(uri: $uri, mode: $mode)';
}


}

/// @nodoc
abstract mixin class $ExecuteUrlLauncherEventCopyWith<$Res> implements $UrlLauncherEventCopyWith<$Res> {
  factory $ExecuteUrlLauncherEventCopyWith(ExecuteUrlLauncherEvent value, $Res Function(ExecuteUrlLauncherEvent) _then) = _$ExecuteUrlLauncherEventCopyWithImpl;
@override @useResult
$Res call({
 Uri uri, LaunchMode mode
});




}
/// @nodoc
class _$ExecuteUrlLauncherEventCopyWithImpl<$Res>
    implements $ExecuteUrlLauncherEventCopyWith<$Res> {
  _$ExecuteUrlLauncherEventCopyWithImpl(this._self, this._then);

  final ExecuteUrlLauncherEvent _self;
  final $Res Function(ExecuteUrlLauncherEvent) _then;

/// Create a copy of UrlLauncherEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uri = null,Object? mode = null,}) {
  return _then(ExecuteUrlLauncherEvent(
null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as Uri,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as LaunchMode,
  ));
}


}

/// @nodoc
mixin _$UrlLauncherState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UrlLauncherState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UrlLauncherState()';
}


}

/// @nodoc
class $UrlLauncherStateCopyWith<$Res>  {
$UrlLauncherStateCopyWith(UrlLauncherState _, $Res Function(UrlLauncherState) __);
}


/// Adds pattern-matching-related methods to [UrlLauncherState].
extension UrlLauncherStatePatterns on UrlLauncherState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _CheckingUrlLauncherState value)?  checking,TResult Function( _LaunchingUrlLauncherState value)?  launching,TResult Function( _LaunchedUrlLauncherState value)?  launched,TResult Function( _ErrorUrlLauncherState value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckingUrlLauncherState() when checking != null:
return checking(_that);case _LaunchingUrlLauncherState() when launching != null:
return launching(_that);case _LaunchedUrlLauncherState() when launched != null:
return launched(_that);case _ErrorUrlLauncherState() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _CheckingUrlLauncherState value)  checking,required TResult Function( _LaunchingUrlLauncherState value)  launching,required TResult Function( _LaunchedUrlLauncherState value)  launched,required TResult Function( _ErrorUrlLauncherState value)  error,}){
final _that = this;
switch (_that) {
case _CheckingUrlLauncherState():
return checking(_that);case _LaunchingUrlLauncherState():
return launching(_that);case _LaunchedUrlLauncherState():
return launched(_that);case _ErrorUrlLauncherState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _CheckingUrlLauncherState value)?  checking,TResult? Function( _LaunchingUrlLauncherState value)?  launching,TResult? Function( _LaunchedUrlLauncherState value)?  launched,TResult? Function( _ErrorUrlLauncherState value)?  error,}){
final _that = this;
switch (_that) {
case _CheckingUrlLauncherState() when checking != null:
return checking(_that);case _LaunchingUrlLauncherState() when launching != null:
return launching(_that);case _LaunchedUrlLauncherState() when launched != null:
return launched(_that);case _ErrorUrlLauncherState() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  checking,TResult Function()?  launching,TResult Function()?  launched,TResult Function()?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckingUrlLauncherState() when checking != null:
return checking();case _LaunchingUrlLauncherState() when launching != null:
return launching();case _LaunchedUrlLauncherState() when launched != null:
return launched();case _ErrorUrlLauncherState() when error != null:
return error();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  checking,required TResult Function()  launching,required TResult Function()  launched,required TResult Function()  error,}) {final _that = this;
switch (_that) {
case _CheckingUrlLauncherState():
return checking();case _LaunchingUrlLauncherState():
return launching();case _LaunchedUrlLauncherState():
return launched();case _ErrorUrlLauncherState():
return error();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  checking,TResult? Function()?  launching,TResult? Function()?  launched,TResult? Function()?  error,}) {final _that = this;
switch (_that) {
case _CheckingUrlLauncherState() when checking != null:
return checking();case _LaunchingUrlLauncherState() when launching != null:
return launching();case _LaunchedUrlLauncherState() when launched != null:
return launched();case _ErrorUrlLauncherState() when error != null:
return error();case _:
  return null;

}
}

}

/// @nodoc


class _CheckingUrlLauncherState implements UrlLauncherState {
  const _CheckingUrlLauncherState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckingUrlLauncherState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UrlLauncherState.checking()';
}


}




/// @nodoc


class _LaunchingUrlLauncherState implements UrlLauncherState {
  const _LaunchingUrlLauncherState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LaunchingUrlLauncherState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UrlLauncherState.launching()';
}


}




/// @nodoc


class _LaunchedUrlLauncherState implements UrlLauncherState {
  const _LaunchedUrlLauncherState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LaunchedUrlLauncherState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UrlLauncherState.launched()';
}


}




/// @nodoc


class _ErrorUrlLauncherState implements UrlLauncherState {
  const _ErrorUrlLauncherState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ErrorUrlLauncherState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UrlLauncherState.error()';
}


}




// dart format on
