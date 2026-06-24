// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ThemeState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThemeState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ThemeState()';
}


}

/// @nodoc
class $ThemeStateCopyWith<$Res>  {
$ThemeStateCopyWith(ThemeState _, $Res Function(ThemeState) __);
}


/// Adds pattern-matching-related methods to [ThemeState].
extension ThemeStatePatterns on ThemeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SettingThemeState value)?  setting,TResult Function( SettedThemeState value)?  setted,TResult Function( ErrorsettingThemeState value)?  errorsetting,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SettingThemeState() when setting != null:
return setting(_that);case SettedThemeState() when setted != null:
return setted(_that);case ErrorsettingThemeState() when errorsetting != null:
return errorsetting(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SettingThemeState value)  setting,required TResult Function( SettedThemeState value)  setted,required TResult Function( ErrorsettingThemeState value)  errorsetting,}){
final _that = this;
switch (_that) {
case SettingThemeState():
return setting(_that);case SettedThemeState():
return setted(_that);case ErrorsettingThemeState():
return errorsetting(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SettingThemeState value)?  setting,TResult? Function( SettedThemeState value)?  setted,TResult? Function( ErrorsettingThemeState value)?  errorsetting,}){
final _that = this;
switch (_that) {
case SettingThemeState() when setting != null:
return setting(_that);case SettedThemeState() when setted != null:
return setted(_that);case ErrorsettingThemeState() when errorsetting != null:
return errorsetting(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  setting,TResult Function( ThemeMode mode)?  setted,TResult Function()?  errorsetting,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SettingThemeState() when setting != null:
return setting();case SettedThemeState() when setted != null:
return setted(_that.mode);case ErrorsettingThemeState() when errorsetting != null:
return errorsetting();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  setting,required TResult Function( ThemeMode mode)  setted,required TResult Function()  errorsetting,}) {final _that = this;
switch (_that) {
case SettingThemeState():
return setting();case SettedThemeState():
return setted(_that.mode);case ErrorsettingThemeState():
return errorsetting();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  setting,TResult? Function( ThemeMode mode)?  setted,TResult? Function()?  errorsetting,}) {final _that = this;
switch (_that) {
case SettingThemeState() when setting != null:
return setting();case SettedThemeState() when setted != null:
return setted(_that.mode);case ErrorsettingThemeState() when errorsetting != null:
return errorsetting();case _:
  return null;

}
}

}

/// @nodoc


class SettingThemeState implements ThemeState {
  const SettingThemeState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingThemeState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ThemeState.setting()';
}


}




/// @nodoc


class SettedThemeState implements ThemeState {
  const SettedThemeState(this.mode);
  

 final  ThemeMode mode;

/// Create a copy of ThemeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettedThemeStateCopyWith<SettedThemeState> get copyWith => _$SettedThemeStateCopyWithImpl<SettedThemeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettedThemeState&&(identical(other.mode, mode) || other.mode == mode));
}


@override
int get hashCode => Object.hash(runtimeType,mode);

@override
String toString() {
  return 'ThemeState.setted(mode: $mode)';
}


}

/// @nodoc
abstract mixin class $SettedThemeStateCopyWith<$Res> implements $ThemeStateCopyWith<$Res> {
  factory $SettedThemeStateCopyWith(SettedThemeState value, $Res Function(SettedThemeState) _then) = _$SettedThemeStateCopyWithImpl;
@useResult
$Res call({
 ThemeMode mode
});




}
/// @nodoc
class _$SettedThemeStateCopyWithImpl<$Res>
    implements $SettedThemeStateCopyWith<$Res> {
  _$SettedThemeStateCopyWithImpl(this._self, this._then);

  final SettedThemeState _self;
  final $Res Function(SettedThemeState) _then;

/// Create a copy of ThemeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mode = null,}) {
  return _then(SettedThemeState(
null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ThemeMode,
  ));
}


}

/// @nodoc


class ErrorsettingThemeState implements ThemeState {
  const ErrorsettingThemeState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorsettingThemeState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ThemeState.errorsetting()';
}


}




// dart format on
