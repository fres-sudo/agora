// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'version_checker_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VersionCheckerEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VersionCheckerEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VersionCheckerEvent()';
}


}

/// @nodoc
class $VersionCheckerEventCopyWith<$Res>  {
$VersionCheckerEventCopyWith(VersionCheckerEvent _, $Res Function(VersionCheckerEvent) __);
}


/// Adds pattern-matching-related methods to [VersionCheckerEvent].
extension VersionCheckerEventPatterns on VersionCheckerEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CheckVersionVersionCheckerEvent value)?  checkVersion,TResult Function( GetAppInfoVersionCheckerEvent value)?  getAppInfo,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CheckVersionVersionCheckerEvent() when checkVersion != null:
return checkVersion(_that);case GetAppInfoVersionCheckerEvent() when getAppInfo != null:
return getAppInfo(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CheckVersionVersionCheckerEvent value)  checkVersion,required TResult Function( GetAppInfoVersionCheckerEvent value)  getAppInfo,}){
final _that = this;
switch (_that) {
case CheckVersionVersionCheckerEvent():
return checkVersion(_that);case GetAppInfoVersionCheckerEvent():
return getAppInfo(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CheckVersionVersionCheckerEvent value)?  checkVersion,TResult? Function( GetAppInfoVersionCheckerEvent value)?  getAppInfo,}){
final _that = this;
switch (_that) {
case CheckVersionVersionCheckerEvent() when checkVersion != null:
return checkVersion(_that);case GetAppInfoVersionCheckerEvent() when getAppInfo != null:
return getAppInfo(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  checkVersion,TResult Function()?  getAppInfo,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CheckVersionVersionCheckerEvent() when checkVersion != null:
return checkVersion();case GetAppInfoVersionCheckerEvent() when getAppInfo != null:
return getAppInfo();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  checkVersion,required TResult Function()  getAppInfo,}) {final _that = this;
switch (_that) {
case CheckVersionVersionCheckerEvent():
return checkVersion();case GetAppInfoVersionCheckerEvent():
return getAppInfo();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  checkVersion,TResult? Function()?  getAppInfo,}) {final _that = this;
switch (_that) {
case CheckVersionVersionCheckerEvent() when checkVersion != null:
return checkVersion();case GetAppInfoVersionCheckerEvent() when getAppInfo != null:
return getAppInfo();case _:
  return null;

}
}

}

/// @nodoc


class CheckVersionVersionCheckerEvent implements VersionCheckerEvent {
  const CheckVersionVersionCheckerEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckVersionVersionCheckerEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VersionCheckerEvent.checkVersion()';
}


}




/// @nodoc


class GetAppInfoVersionCheckerEvent implements VersionCheckerEvent {
  const GetAppInfoVersionCheckerEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetAppInfoVersionCheckerEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VersionCheckerEvent.getAppInfo()';
}


}




/// @nodoc
mixin _$VersionCheckerState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VersionCheckerState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VersionCheckerState()';
}


}

/// @nodoc
class $VersionCheckerStateCopyWith<$Res>  {
$VersionCheckerStateCopyWith(VersionCheckerState _, $Res Function(VersionCheckerState) __);
}


/// Adds pattern-matching-related methods to [VersionCheckerState].
extension VersionCheckerStatePatterns on VersionCheckerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CheckingVersionVersionCheckerState value)?  checkingVersion,TResult Function( LockedVersionVersionCheckerState value)?  lockedVersion,TResult Function( DeprecatedVersionVersionCheckerState value)?  deprecatedVersion,TResult Function( ActiveVersionVersionCheckerState value)?  activeVersion,TResult Function( ErrorCheckingVersionVersionCheckerState value)?  errorCheckingVersion,TResult Function( GettingAppInfoVersionCheckerState value)?  gettingAppInfo,TResult Function( GotAppInfoVersionCheckerState value)?  gotAppInfo,TResult Function( ErrorGettingAppInfoVersionCheckerState value)?  errorGettingAppInfo,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CheckingVersionVersionCheckerState() when checkingVersion != null:
return checkingVersion(_that);case LockedVersionVersionCheckerState() when lockedVersion != null:
return lockedVersion(_that);case DeprecatedVersionVersionCheckerState() when deprecatedVersion != null:
return deprecatedVersion(_that);case ActiveVersionVersionCheckerState() when activeVersion != null:
return activeVersion(_that);case ErrorCheckingVersionVersionCheckerState() when errorCheckingVersion != null:
return errorCheckingVersion(_that);case GettingAppInfoVersionCheckerState() when gettingAppInfo != null:
return gettingAppInfo(_that);case GotAppInfoVersionCheckerState() when gotAppInfo != null:
return gotAppInfo(_that);case ErrorGettingAppInfoVersionCheckerState() when errorGettingAppInfo != null:
return errorGettingAppInfo(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CheckingVersionVersionCheckerState value)  checkingVersion,required TResult Function( LockedVersionVersionCheckerState value)  lockedVersion,required TResult Function( DeprecatedVersionVersionCheckerState value)  deprecatedVersion,required TResult Function( ActiveVersionVersionCheckerState value)  activeVersion,required TResult Function( ErrorCheckingVersionVersionCheckerState value)  errorCheckingVersion,required TResult Function( GettingAppInfoVersionCheckerState value)  gettingAppInfo,required TResult Function( GotAppInfoVersionCheckerState value)  gotAppInfo,required TResult Function( ErrorGettingAppInfoVersionCheckerState value)  errorGettingAppInfo,}){
final _that = this;
switch (_that) {
case CheckingVersionVersionCheckerState():
return checkingVersion(_that);case LockedVersionVersionCheckerState():
return lockedVersion(_that);case DeprecatedVersionVersionCheckerState():
return deprecatedVersion(_that);case ActiveVersionVersionCheckerState():
return activeVersion(_that);case ErrorCheckingVersionVersionCheckerState():
return errorCheckingVersion(_that);case GettingAppInfoVersionCheckerState():
return gettingAppInfo(_that);case GotAppInfoVersionCheckerState():
return gotAppInfo(_that);case ErrorGettingAppInfoVersionCheckerState():
return errorGettingAppInfo(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CheckingVersionVersionCheckerState value)?  checkingVersion,TResult? Function( LockedVersionVersionCheckerState value)?  lockedVersion,TResult? Function( DeprecatedVersionVersionCheckerState value)?  deprecatedVersion,TResult? Function( ActiveVersionVersionCheckerState value)?  activeVersion,TResult? Function( ErrorCheckingVersionVersionCheckerState value)?  errorCheckingVersion,TResult? Function( GettingAppInfoVersionCheckerState value)?  gettingAppInfo,TResult? Function( GotAppInfoVersionCheckerState value)?  gotAppInfo,TResult? Function( ErrorGettingAppInfoVersionCheckerState value)?  errorGettingAppInfo,}){
final _that = this;
switch (_that) {
case CheckingVersionVersionCheckerState() when checkingVersion != null:
return checkingVersion(_that);case LockedVersionVersionCheckerState() when lockedVersion != null:
return lockedVersion(_that);case DeprecatedVersionVersionCheckerState() when deprecatedVersion != null:
return deprecatedVersion(_that);case ActiveVersionVersionCheckerState() when activeVersion != null:
return activeVersion(_that);case ErrorCheckingVersionVersionCheckerState() when errorCheckingVersion != null:
return errorCheckingVersion(_that);case GettingAppInfoVersionCheckerState() when gettingAppInfo != null:
return gettingAppInfo(_that);case GotAppInfoVersionCheckerState() when gotAppInfo != null:
return gotAppInfo(_that);case ErrorGettingAppInfoVersionCheckerState() when errorGettingAppInfo != null:
return errorGettingAppInfo(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  checkingVersion,TResult Function()?  lockedVersion,TResult Function()?  deprecatedVersion,TResult Function()?  activeVersion,TResult Function()?  errorCheckingVersion,TResult Function()?  gettingAppInfo,TResult Function( String version,  String build,  String platform)?  gotAppInfo,TResult Function()?  errorGettingAppInfo,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CheckingVersionVersionCheckerState() when checkingVersion != null:
return checkingVersion();case LockedVersionVersionCheckerState() when lockedVersion != null:
return lockedVersion();case DeprecatedVersionVersionCheckerState() when deprecatedVersion != null:
return deprecatedVersion();case ActiveVersionVersionCheckerState() when activeVersion != null:
return activeVersion();case ErrorCheckingVersionVersionCheckerState() when errorCheckingVersion != null:
return errorCheckingVersion();case GettingAppInfoVersionCheckerState() when gettingAppInfo != null:
return gettingAppInfo();case GotAppInfoVersionCheckerState() when gotAppInfo != null:
return gotAppInfo(_that.version,_that.build,_that.platform);case ErrorGettingAppInfoVersionCheckerState() when errorGettingAppInfo != null:
return errorGettingAppInfo();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  checkingVersion,required TResult Function()  lockedVersion,required TResult Function()  deprecatedVersion,required TResult Function()  activeVersion,required TResult Function()  errorCheckingVersion,required TResult Function()  gettingAppInfo,required TResult Function( String version,  String build,  String platform)  gotAppInfo,required TResult Function()  errorGettingAppInfo,}) {final _that = this;
switch (_that) {
case CheckingVersionVersionCheckerState():
return checkingVersion();case LockedVersionVersionCheckerState():
return lockedVersion();case DeprecatedVersionVersionCheckerState():
return deprecatedVersion();case ActiveVersionVersionCheckerState():
return activeVersion();case ErrorCheckingVersionVersionCheckerState():
return errorCheckingVersion();case GettingAppInfoVersionCheckerState():
return gettingAppInfo();case GotAppInfoVersionCheckerState():
return gotAppInfo(_that.version,_that.build,_that.platform);case ErrorGettingAppInfoVersionCheckerState():
return errorGettingAppInfo();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  checkingVersion,TResult? Function()?  lockedVersion,TResult? Function()?  deprecatedVersion,TResult? Function()?  activeVersion,TResult? Function()?  errorCheckingVersion,TResult? Function()?  gettingAppInfo,TResult? Function( String version,  String build,  String platform)?  gotAppInfo,TResult? Function()?  errorGettingAppInfo,}) {final _that = this;
switch (_that) {
case CheckingVersionVersionCheckerState() when checkingVersion != null:
return checkingVersion();case LockedVersionVersionCheckerState() when lockedVersion != null:
return lockedVersion();case DeprecatedVersionVersionCheckerState() when deprecatedVersion != null:
return deprecatedVersion();case ActiveVersionVersionCheckerState() when activeVersion != null:
return activeVersion();case ErrorCheckingVersionVersionCheckerState() when errorCheckingVersion != null:
return errorCheckingVersion();case GettingAppInfoVersionCheckerState() when gettingAppInfo != null:
return gettingAppInfo();case GotAppInfoVersionCheckerState() when gotAppInfo != null:
return gotAppInfo(_that.version,_that.build,_that.platform);case ErrorGettingAppInfoVersionCheckerState() when errorGettingAppInfo != null:
return errorGettingAppInfo();case _:
  return null;

}
}

}

/// @nodoc


class CheckingVersionVersionCheckerState implements VersionCheckerState {
  const CheckingVersionVersionCheckerState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckingVersionVersionCheckerState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VersionCheckerState.checkingVersion()';
}


}




/// @nodoc


class LockedVersionVersionCheckerState implements VersionCheckerState {
  const LockedVersionVersionCheckerState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LockedVersionVersionCheckerState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VersionCheckerState.lockedVersion()';
}


}




/// @nodoc


class DeprecatedVersionVersionCheckerState implements VersionCheckerState {
  const DeprecatedVersionVersionCheckerState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeprecatedVersionVersionCheckerState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VersionCheckerState.deprecatedVersion()';
}


}




/// @nodoc


class ActiveVersionVersionCheckerState implements VersionCheckerState {
  const ActiveVersionVersionCheckerState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActiveVersionVersionCheckerState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VersionCheckerState.activeVersion()';
}


}




/// @nodoc


class ErrorCheckingVersionVersionCheckerState implements VersionCheckerState {
  const ErrorCheckingVersionVersionCheckerState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorCheckingVersionVersionCheckerState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VersionCheckerState.errorCheckingVersion()';
}


}




/// @nodoc


class GettingAppInfoVersionCheckerState implements VersionCheckerState {
  const GettingAppInfoVersionCheckerState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GettingAppInfoVersionCheckerState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VersionCheckerState.gettingAppInfo()';
}


}




/// @nodoc


class GotAppInfoVersionCheckerState implements VersionCheckerState {
  const GotAppInfoVersionCheckerState({required this.version, required this.build, required this.platform});
  

 final  String version;
 final  String build;
 final  String platform;

/// Create a copy of VersionCheckerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GotAppInfoVersionCheckerStateCopyWith<GotAppInfoVersionCheckerState> get copyWith => _$GotAppInfoVersionCheckerStateCopyWithImpl<GotAppInfoVersionCheckerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GotAppInfoVersionCheckerState&&(identical(other.version, version) || other.version == version)&&(identical(other.build, build) || other.build == build)&&(identical(other.platform, platform) || other.platform == platform));
}


@override
int get hashCode => Object.hash(runtimeType,version,build,platform);

@override
String toString() {
  return 'VersionCheckerState.gotAppInfo(version: $version, build: $build, platform: $platform)';
}


}

/// @nodoc
abstract mixin class $GotAppInfoVersionCheckerStateCopyWith<$Res> implements $VersionCheckerStateCopyWith<$Res> {
  factory $GotAppInfoVersionCheckerStateCopyWith(GotAppInfoVersionCheckerState value, $Res Function(GotAppInfoVersionCheckerState) _then) = _$GotAppInfoVersionCheckerStateCopyWithImpl;
@useResult
$Res call({
 String version, String build, String platform
});




}
/// @nodoc
class _$GotAppInfoVersionCheckerStateCopyWithImpl<$Res>
    implements $GotAppInfoVersionCheckerStateCopyWith<$Res> {
  _$GotAppInfoVersionCheckerStateCopyWithImpl(this._self, this._then);

  final GotAppInfoVersionCheckerState _self;
  final $Res Function(GotAppInfoVersionCheckerState) _then;

/// Create a copy of VersionCheckerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? version = null,Object? build = null,Object? platform = null,}) {
  return _then(GotAppInfoVersionCheckerState(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,build: null == build ? _self.build : build // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ErrorGettingAppInfoVersionCheckerState implements VersionCheckerState {
  const ErrorGettingAppInfoVersionCheckerState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorGettingAppInfoVersionCheckerState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VersionCheckerState.errorGettingAppInfo()';
}


}




// dart format on
