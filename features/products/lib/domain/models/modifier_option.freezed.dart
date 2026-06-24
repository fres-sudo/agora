// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'modifier_option.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ModifierOption {

 int get id; String get name; int get priceChangeCents;
/// Create a copy of ModifierOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModifierOptionCopyWith<ModifierOption> get copyWith => _$ModifierOptionCopyWithImpl<ModifierOption>(this as ModifierOption, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModifierOption&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.priceChangeCents, priceChangeCents) || other.priceChangeCents == priceChangeCents));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,priceChangeCents);

@override
String toString() {
  return 'ModifierOption(id: $id, name: $name, priceChangeCents: $priceChangeCents)';
}


}

/// @nodoc
abstract mixin class $ModifierOptionCopyWith<$Res>  {
  factory $ModifierOptionCopyWith(ModifierOption value, $Res Function(ModifierOption) _then) = _$ModifierOptionCopyWithImpl;
@useResult
$Res call({
 int id, String name, int priceChangeCents
});




}
/// @nodoc
class _$ModifierOptionCopyWithImpl<$Res>
    implements $ModifierOptionCopyWith<$Res> {
  _$ModifierOptionCopyWithImpl(this._self, this._then);

  final ModifierOption _self;
  final $Res Function(ModifierOption) _then;

/// Create a copy of ModifierOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? priceChangeCents = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceChangeCents: null == priceChangeCents ? _self.priceChangeCents : priceChangeCents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ModifierOption].
extension ModifierOptionPatterns on ModifierOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModifierOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModifierOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModifierOption value)  $default,){
final _that = this;
switch (_that) {
case _ModifierOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModifierOption value)?  $default,){
final _that = this;
switch (_that) {
case _ModifierOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  int priceChangeCents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModifierOption() when $default != null:
return $default(_that.id,_that.name,_that.priceChangeCents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  int priceChangeCents)  $default,) {final _that = this;
switch (_that) {
case _ModifierOption():
return $default(_that.id,_that.name,_that.priceChangeCents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  int priceChangeCents)?  $default,) {final _that = this;
switch (_that) {
case _ModifierOption() when $default != null:
return $default(_that.id,_that.name,_that.priceChangeCents);case _:
  return null;

}
}

}

/// @nodoc


class _ModifierOption extends ModifierOption {
  const _ModifierOption({required this.id, required this.name, required this.priceChangeCents}): super._();
  

@override final  int id;
@override final  String name;
@override final  int priceChangeCents;

/// Create a copy of ModifierOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModifierOptionCopyWith<_ModifierOption> get copyWith => __$ModifierOptionCopyWithImpl<_ModifierOption>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModifierOption&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.priceChangeCents, priceChangeCents) || other.priceChangeCents == priceChangeCents));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,priceChangeCents);

@override
String toString() {
  return 'ModifierOption(id: $id, name: $name, priceChangeCents: $priceChangeCents)';
}


}

/// @nodoc
abstract mixin class _$ModifierOptionCopyWith<$Res> implements $ModifierOptionCopyWith<$Res> {
  factory _$ModifierOptionCopyWith(_ModifierOption value, $Res Function(_ModifierOption) _then) = __$ModifierOptionCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, int priceChangeCents
});




}
/// @nodoc
class __$ModifierOptionCopyWithImpl<$Res>
    implements _$ModifierOptionCopyWith<$Res> {
  __$ModifierOptionCopyWithImpl(this._self, this._then);

  final _ModifierOption _self;
  final $Res Function(_ModifierOption) _then;

/// Create a copy of ModifierOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? priceChangeCents = null,}) {
  return _then(_ModifierOption(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceChangeCents: null == priceChangeCents ? _self.priceChangeCents : priceChangeCents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
