// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CatalogTemplate {

 int get id; String get name; DateTime get savedAt; CatalogSnapshot get snapshot;
/// Create a copy of CatalogTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogTemplateCopyWith<CatalogTemplate> get copyWith => _$CatalogTemplateCopyWithImpl<CatalogTemplate>(this as CatalogTemplate, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt)&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,savedAt,snapshot);

@override
String toString() {
  return 'CatalogTemplate(id: $id, name: $name, savedAt: $savedAt, snapshot: $snapshot)';
}


}

/// @nodoc
abstract mixin class $CatalogTemplateCopyWith<$Res>  {
  factory $CatalogTemplateCopyWith(CatalogTemplate value, $Res Function(CatalogTemplate) _then) = _$CatalogTemplateCopyWithImpl;
@useResult
$Res call({
 int id, String name, DateTime savedAt, CatalogSnapshot snapshot
});


$CatalogSnapshotCopyWith<$Res> get snapshot;

}
/// @nodoc
class _$CatalogTemplateCopyWithImpl<$Res>
    implements $CatalogTemplateCopyWith<$Res> {
  _$CatalogTemplateCopyWithImpl(this._self, this._then);

  final CatalogTemplate _self;
  final $Res Function(CatalogTemplate) _then;

/// Create a copy of CatalogTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? savedAt = null,Object? snapshot = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,savedAt: null == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as DateTime,snapshot: null == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as CatalogSnapshot,
  ));
}
/// Create a copy of CatalogTemplate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CatalogSnapshotCopyWith<$Res> get snapshot {
  
  return $CatalogSnapshotCopyWith<$Res>(_self.snapshot, (value) {
    return _then(_self.copyWith(snapshot: value));
  });
}
}


/// Adds pattern-matching-related methods to [CatalogTemplate].
extension CatalogTemplatePatterns on CatalogTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogTemplate value)  $default,){
final _that = this;
switch (_that) {
case _CatalogTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  DateTime savedAt,  CatalogSnapshot snapshot)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogTemplate() when $default != null:
return $default(_that.id,_that.name,_that.savedAt,_that.snapshot);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  DateTime savedAt,  CatalogSnapshot snapshot)  $default,) {final _that = this;
switch (_that) {
case _CatalogTemplate():
return $default(_that.id,_that.name,_that.savedAt,_that.snapshot);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  DateTime savedAt,  CatalogSnapshot snapshot)?  $default,) {final _that = this;
switch (_that) {
case _CatalogTemplate() when $default != null:
return $default(_that.id,_that.name,_that.savedAt,_that.snapshot);case _:
  return null;

}
}

}

/// @nodoc


class _CatalogTemplate extends CatalogTemplate {
  const _CatalogTemplate({required this.id, required this.name, required this.savedAt, required this.snapshot}): super._();
  

@override final  int id;
@override final  String name;
@override final  DateTime savedAt;
@override final  CatalogSnapshot snapshot;

/// Create a copy of CatalogTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogTemplateCopyWith<_CatalogTemplate> get copyWith => __$CatalogTemplateCopyWithImpl<_CatalogTemplate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt)&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,savedAt,snapshot);

@override
String toString() {
  return 'CatalogTemplate(id: $id, name: $name, savedAt: $savedAt, snapshot: $snapshot)';
}


}

/// @nodoc
abstract mixin class _$CatalogTemplateCopyWith<$Res> implements $CatalogTemplateCopyWith<$Res> {
  factory _$CatalogTemplateCopyWith(_CatalogTemplate value, $Res Function(_CatalogTemplate) _then) = __$CatalogTemplateCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, DateTime savedAt, CatalogSnapshot snapshot
});


@override $CatalogSnapshotCopyWith<$Res> get snapshot;

}
/// @nodoc
class __$CatalogTemplateCopyWithImpl<$Res>
    implements _$CatalogTemplateCopyWith<$Res> {
  __$CatalogTemplateCopyWithImpl(this._self, this._then);

  final _CatalogTemplate _self;
  final $Res Function(_CatalogTemplate) _then;

/// Create a copy of CatalogTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? savedAt = null,Object? snapshot = null,}) {
  return _then(_CatalogTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,savedAt: null == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as DateTime,snapshot: null == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as CatalogSnapshot,
  ));
}

/// Create a copy of CatalogTemplate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CatalogSnapshotCopyWith<$Res> get snapshot {
  
  return $CatalogSnapshotCopyWith<$Res>(_self.snapshot, (value) {
    return _then(_self.copyWith(snapshot: value));
  });
}
}

// dart format on
