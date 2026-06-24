// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'selected_modifiers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SelectedModifiers {

 String get groupName;// e.g., "Size"
 String get optionName;// e.g., "Large"
 int get priceChangeCents;
/// Create a copy of SelectedModifiers
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectedModifiersCopyWith<SelectedModifiers> get copyWith => _$SelectedModifiersCopyWithImpl<SelectedModifiers>(this as SelectedModifiers, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectedModifiers&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.optionName, optionName) || other.optionName == optionName)&&(identical(other.priceChangeCents, priceChangeCents) || other.priceChangeCents == priceChangeCents));
}


@override
int get hashCode => Object.hash(runtimeType,groupName,optionName,priceChangeCents);

@override
String toString() {
  return 'SelectedModifiers(groupName: $groupName, optionName: $optionName, priceChangeCents: $priceChangeCents)';
}


}

/// @nodoc
abstract mixin class $SelectedModifiersCopyWith<$Res>  {
  factory $SelectedModifiersCopyWith(SelectedModifiers value, $Res Function(SelectedModifiers) _then) = _$SelectedModifiersCopyWithImpl;
@useResult
$Res call({
 String groupName, String optionName, int priceChangeCents
});




}
/// @nodoc
class _$SelectedModifiersCopyWithImpl<$Res>
    implements $SelectedModifiersCopyWith<$Res> {
  _$SelectedModifiersCopyWithImpl(this._self, this._then);

  final SelectedModifiers _self;
  final $Res Function(SelectedModifiers) _then;

/// Create a copy of SelectedModifiers
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groupName = null,Object? optionName = null,Object? priceChangeCents = null,}) {
  return _then(_self.copyWith(
groupName: null == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String,optionName: null == optionName ? _self.optionName : optionName // ignore: cast_nullable_to_non_nullable
as String,priceChangeCents: null == priceChangeCents ? _self.priceChangeCents : priceChangeCents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SelectedModifiers].
extension SelectedModifiersPatterns on SelectedModifiers {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SelectedModifiers value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SelectedModifiers() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SelectedModifiers value)  $default,){
final _that = this;
switch (_that) {
case _SelectedModifiers():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SelectedModifiers value)?  $default,){
final _that = this;
switch (_that) {
case _SelectedModifiers() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String groupName,  String optionName,  int priceChangeCents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SelectedModifiers() when $default != null:
return $default(_that.groupName,_that.optionName,_that.priceChangeCents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String groupName,  String optionName,  int priceChangeCents)  $default,) {final _that = this;
switch (_that) {
case _SelectedModifiers():
return $default(_that.groupName,_that.optionName,_that.priceChangeCents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String groupName,  String optionName,  int priceChangeCents)?  $default,) {final _that = this;
switch (_that) {
case _SelectedModifiers() when $default != null:
return $default(_that.groupName,_that.optionName,_that.priceChangeCents);case _:
  return null;

}
}

}

/// @nodoc


class _SelectedModifiers extends SelectedModifiers {
  const _SelectedModifiers({required this.groupName, required this.optionName, required this.priceChangeCents}): super._();
  

@override final  String groupName;
// e.g., "Size"
@override final  String optionName;
// e.g., "Large"
@override final  int priceChangeCents;

/// Create a copy of SelectedModifiers
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectedModifiersCopyWith<_SelectedModifiers> get copyWith => __$SelectedModifiersCopyWithImpl<_SelectedModifiers>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectedModifiers&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.optionName, optionName) || other.optionName == optionName)&&(identical(other.priceChangeCents, priceChangeCents) || other.priceChangeCents == priceChangeCents));
}


@override
int get hashCode => Object.hash(runtimeType,groupName,optionName,priceChangeCents);

@override
String toString() {
  return 'SelectedModifiers(groupName: $groupName, optionName: $optionName, priceChangeCents: $priceChangeCents)';
}


}

/// @nodoc
abstract mixin class _$SelectedModifiersCopyWith<$Res> implements $SelectedModifiersCopyWith<$Res> {
  factory _$SelectedModifiersCopyWith(_SelectedModifiers value, $Res Function(_SelectedModifiers) _then) = __$SelectedModifiersCopyWithImpl;
@override @useResult
$Res call({
 String groupName, String optionName, int priceChangeCents
});




}
/// @nodoc
class __$SelectedModifiersCopyWithImpl<$Res>
    implements _$SelectedModifiersCopyWith<$Res> {
  __$SelectedModifiersCopyWithImpl(this._self, this._then);

  final _SelectedModifiers _self;
  final $Res Function(_SelectedModifiers) _then;

/// Create a copy of SelectedModifiers
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groupName = null,Object? optionName = null,Object? priceChangeCents = null,}) {
  return _then(_SelectedModifiers(
groupName: null == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String,optionName: null == optionName ? _self.optionName : optionName // ignore: cast_nullable_to_non_nullable
as String,priceChangeCents: null == priceChangeCents ? _self.priceChangeCents : priceChangeCents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
