// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'modifier_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ModifierGroup {

 int get id; String get name;// e.g., "Milk Option"
 bool get isMultiSelect; List<ModifierOption> get options;
/// Create a copy of ModifierGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModifierGroupCopyWith<ModifierGroup> get copyWith => _$ModifierGroupCopyWithImpl<ModifierGroup>(this as ModifierGroup, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModifierGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isMultiSelect, isMultiSelect) || other.isMultiSelect == isMultiSelect)&&const DeepCollectionEquality().equals(other.options, options));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,isMultiSelect,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'ModifierGroup(id: $id, name: $name, isMultiSelect: $isMultiSelect, options: $options)';
}


}

/// @nodoc
abstract mixin class $ModifierGroupCopyWith<$Res>  {
  factory $ModifierGroupCopyWith(ModifierGroup value, $Res Function(ModifierGroup) _then) = _$ModifierGroupCopyWithImpl;
@useResult
$Res call({
 int id, String name, bool isMultiSelect, List<ModifierOption> options
});




}
/// @nodoc
class _$ModifierGroupCopyWithImpl<$Res>
    implements $ModifierGroupCopyWith<$Res> {
  _$ModifierGroupCopyWithImpl(this._self, this._then);

  final ModifierGroup _self;
  final $Res Function(ModifierGroup) _then;

/// Create a copy of ModifierGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? isMultiSelect = null,Object? options = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isMultiSelect: null == isMultiSelect ? _self.isMultiSelect : isMultiSelect // ignore: cast_nullable_to_non_nullable
as bool,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<ModifierOption>,
  ));
}

}


/// Adds pattern-matching-related methods to [ModifierGroup].
extension ModifierGroupPatterns on ModifierGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModifierGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModifierGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModifierGroup value)  $default,){
final _that = this;
switch (_that) {
case _ModifierGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModifierGroup value)?  $default,){
final _that = this;
switch (_that) {
case _ModifierGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  bool isMultiSelect,  List<ModifierOption> options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModifierGroup() when $default != null:
return $default(_that.id,_that.name,_that.isMultiSelect,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  bool isMultiSelect,  List<ModifierOption> options)  $default,) {final _that = this;
switch (_that) {
case _ModifierGroup():
return $default(_that.id,_that.name,_that.isMultiSelect,_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  bool isMultiSelect,  List<ModifierOption> options)?  $default,) {final _that = this;
switch (_that) {
case _ModifierGroup() when $default != null:
return $default(_that.id,_that.name,_that.isMultiSelect,_that.options);case _:
  return null;

}
}

}

/// @nodoc


class _ModifierGroup extends ModifierGroup {
  const _ModifierGroup({required this.id, required this.name, required this.isMultiSelect, final  List<ModifierOption> options = const []}): _options = options,super._();
  

@override final  int id;
@override final  String name;
// e.g., "Milk Option"
@override final  bool isMultiSelect;
 final  List<ModifierOption> _options;
@override@JsonKey() List<ModifierOption> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}


/// Create a copy of ModifierGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModifierGroupCopyWith<_ModifierGroup> get copyWith => __$ModifierGroupCopyWithImpl<_ModifierGroup>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModifierGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isMultiSelect, isMultiSelect) || other.isMultiSelect == isMultiSelect)&&const DeepCollectionEquality().equals(other._options, _options));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,isMultiSelect,const DeepCollectionEquality().hash(_options));

@override
String toString() {
  return 'ModifierGroup(id: $id, name: $name, isMultiSelect: $isMultiSelect, options: $options)';
}


}

/// @nodoc
abstract mixin class _$ModifierGroupCopyWith<$Res> implements $ModifierGroupCopyWith<$Res> {
  factory _$ModifierGroupCopyWith(_ModifierGroup value, $Res Function(_ModifierGroup) _then) = __$ModifierGroupCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, bool isMultiSelect, List<ModifierOption> options
});




}
/// @nodoc
class __$ModifierGroupCopyWithImpl<$Res>
    implements _$ModifierGroupCopyWith<$Res> {
  __$ModifierGroupCopyWithImpl(this._self, this._then);

  final _ModifierGroup _self;
  final $Res Function(_ModifierGroup) _then;

/// Create a copy of ModifierGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? isMultiSelect = null,Object? options = null,}) {
  return _then(_ModifierGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isMultiSelect: null == isMultiSelect ? _self.isMultiSelect : isMultiSelect // ignore: cast_nullable_to_non_nullable
as bool,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<ModifierOption>,
  ));
}


}

// dart format on
