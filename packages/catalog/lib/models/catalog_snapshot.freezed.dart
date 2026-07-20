// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CatalogSnapshot {

 List<Category> get categories; List<ModifierGroup> get modifierGroups; List<Product> get products; List<Combo> get combos;
/// Create a copy of CatalogSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogSnapshotCopyWith<CatalogSnapshot> get copyWith => _$CatalogSnapshotCopyWithImpl<CatalogSnapshot>(this as CatalogSnapshot, _$identity);

  /// Serializes this CatalogSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogSnapshot&&const DeepCollectionEquality().equals(other.categories, categories)&&const DeepCollectionEquality().equals(other.modifierGroups, modifierGroups)&&const DeepCollectionEquality().equals(other.products, products)&&const DeepCollectionEquality().equals(other.combos, combos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(categories),const DeepCollectionEquality().hash(modifierGroups),const DeepCollectionEquality().hash(products),const DeepCollectionEquality().hash(combos));

@override
String toString() {
  return 'CatalogSnapshot(categories: $categories, modifierGroups: $modifierGroups, products: $products, combos: $combos)';
}


}

/// @nodoc
abstract mixin class $CatalogSnapshotCopyWith<$Res>  {
  factory $CatalogSnapshotCopyWith(CatalogSnapshot value, $Res Function(CatalogSnapshot) _then) = _$CatalogSnapshotCopyWithImpl;
@useResult
$Res call({
 List<Category> categories, List<ModifierGroup> modifierGroups, List<Product> products, List<Combo> combos
});




}
/// @nodoc
class _$CatalogSnapshotCopyWithImpl<$Res>
    implements $CatalogSnapshotCopyWith<$Res> {
  _$CatalogSnapshotCopyWithImpl(this._self, this._then);

  final CatalogSnapshot _self;
  final $Res Function(CatalogSnapshot) _then;

/// Create a copy of CatalogSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categories = null,Object? modifierGroups = null,Object? products = null,Object? combos = null,}) {
  return _then(_self.copyWith(
categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,modifierGroups: null == modifierGroups ? _self.modifierGroups : modifierGroups // ignore: cast_nullable_to_non_nullable
as List<ModifierGroup>,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,combos: null == combos ? _self.combos : combos // ignore: cast_nullable_to_non_nullable
as List<Combo>,
  ));
}

}


/// Adds pattern-matching-related methods to [CatalogSnapshot].
extension CatalogSnapshotPatterns on CatalogSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _CatalogSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Category> categories,  List<ModifierGroup> modifierGroups,  List<Product> products,  List<Combo> combos)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogSnapshot() when $default != null:
return $default(_that.categories,_that.modifierGroups,_that.products,_that.combos);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Category> categories,  List<ModifierGroup> modifierGroups,  List<Product> products,  List<Combo> combos)  $default,) {final _that = this;
switch (_that) {
case _CatalogSnapshot():
return $default(_that.categories,_that.modifierGroups,_that.products,_that.combos);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Category> categories,  List<ModifierGroup> modifierGroups,  List<Product> products,  List<Combo> combos)?  $default,) {final _that = this;
switch (_that) {
case _CatalogSnapshot() when $default != null:
return $default(_that.categories,_that.modifierGroups,_that.products,_that.combos);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CatalogSnapshot extends CatalogSnapshot {
  const _CatalogSnapshot({final  List<Category> categories = const [], final  List<ModifierGroup> modifierGroups = const [], final  List<Product> products = const [], final  List<Combo> combos = const []}): _categories = categories,_modifierGroups = modifierGroups,_products = products,_combos = combos,super._();
  factory _CatalogSnapshot.fromJson(Map<String, dynamic> json) => _$CatalogSnapshotFromJson(json);

 final  List<Category> _categories;
@override@JsonKey() List<Category> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

 final  List<ModifierGroup> _modifierGroups;
@override@JsonKey() List<ModifierGroup> get modifierGroups {
  if (_modifierGroups is EqualUnmodifiableListView) return _modifierGroups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_modifierGroups);
}

 final  List<Product> _products;
@override@JsonKey() List<Product> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

 final  List<Combo> _combos;
@override@JsonKey() List<Combo> get combos {
  if (_combos is EqualUnmodifiableListView) return _combos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_combos);
}


/// Create a copy of CatalogSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogSnapshotCopyWith<_CatalogSnapshot> get copyWith => __$CatalogSnapshotCopyWithImpl<_CatalogSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CatalogSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogSnapshot&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._modifierGroups, _modifierGroups)&&const DeepCollectionEquality().equals(other._products, _products)&&const DeepCollectionEquality().equals(other._combos, _combos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_modifierGroups),const DeepCollectionEquality().hash(_products),const DeepCollectionEquality().hash(_combos));

@override
String toString() {
  return 'CatalogSnapshot(categories: $categories, modifierGroups: $modifierGroups, products: $products, combos: $combos)';
}


}

/// @nodoc
abstract mixin class _$CatalogSnapshotCopyWith<$Res> implements $CatalogSnapshotCopyWith<$Res> {
  factory _$CatalogSnapshotCopyWith(_CatalogSnapshot value, $Res Function(_CatalogSnapshot) _then) = __$CatalogSnapshotCopyWithImpl;
@override @useResult
$Res call({
 List<Category> categories, List<ModifierGroup> modifierGroups, List<Product> products, List<Combo> combos
});




}
/// @nodoc
class __$CatalogSnapshotCopyWithImpl<$Res>
    implements _$CatalogSnapshotCopyWith<$Res> {
  __$CatalogSnapshotCopyWithImpl(this._self, this._then);

  final _CatalogSnapshot _self;
  final $Res Function(_CatalogSnapshot) _then;

/// Create a copy of CatalogSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categories = null,Object? modifierGroups = null,Object? products = null,Object? combos = null,}) {
  return _then(_CatalogSnapshot(
categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,modifierGroups: null == modifierGroups ? _self._modifierGroups : modifierGroups // ignore: cast_nullable_to_non_nullable
as List<ModifierGroup>,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,combos: null == combos ? _self._combos : combos // ignore: cast_nullable_to_non_nullable
as List<Combo>,
  ));
}


}

// dart format on
