// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Product {

 int get id; String get name; String? get description; String? get sku; String? get imageUrl; int get categoryId; int get priceCents;// Keep as int for math
 int get costCents; int get taxPercent;// Tax as percentage (e.g., 10 = 10%)
 int get stockQuantity;// Merged from Stock table
 bool get trackStock;// Whether sales decrement stock
 ProductStatus get status; List<ModifierGroup> get modifierGroups;// Free-text kitchen prep-station label (e.g. "Griglia"). Null = this
// product's line items stay on the customer receipt only, never
// ticketed (docs/features/02-kitchen-ticket-routing.md).
 String? get prepStation;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.priceCents, priceCents) || other.priceCents == priceCents)&&(identical(other.costCents, costCents) || other.costCents == costCents)&&(identical(other.taxPercent, taxPercent) || other.taxPercent == taxPercent)&&(identical(other.stockQuantity, stockQuantity) || other.stockQuantity == stockQuantity)&&(identical(other.trackStock, trackStock) || other.trackStock == trackStock)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.modifierGroups, modifierGroups)&&(identical(other.prepStation, prepStation) || other.prepStation == prepStation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,sku,imageUrl,categoryId,priceCents,costCents,taxPercent,stockQuantity,trackStock,status,const DeepCollectionEquality().hash(modifierGroups),prepStation);

@override
String toString() {
  return 'Product(id: $id, name: $name, description: $description, sku: $sku, imageUrl: $imageUrl, categoryId: $categoryId, priceCents: $priceCents, costCents: $costCents, taxPercent: $taxPercent, stockQuantity: $stockQuantity, trackStock: $trackStock, status: $status, modifierGroups: $modifierGroups, prepStation: $prepStation)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? description, String? sku, String? imageUrl, int categoryId, int priceCents, int costCents, int taxPercent, int stockQuantity, bool trackStock, ProductStatus status, List<ModifierGroup> modifierGroups, String? prepStation
});




}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? sku = freezed,Object? imageUrl = freezed,Object? categoryId = null,Object? priceCents = null,Object? costCents = null,Object? taxPercent = null,Object? stockQuantity = null,Object? trackStock = null,Object? status = null,Object? modifierGroups = null,Object? prepStation = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,priceCents: null == priceCents ? _self.priceCents : priceCents // ignore: cast_nullable_to_non_nullable
as int,costCents: null == costCents ? _self.costCents : costCents // ignore: cast_nullable_to_non_nullable
as int,taxPercent: null == taxPercent ? _self.taxPercent : taxPercent // ignore: cast_nullable_to_non_nullable
as int,stockQuantity: null == stockQuantity ? _self.stockQuantity : stockQuantity // ignore: cast_nullable_to_non_nullable
as int,trackStock: null == trackStock ? _self.trackStock : trackStock // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProductStatus,modifierGroups: null == modifierGroups ? _self.modifierGroups : modifierGroups // ignore: cast_nullable_to_non_nullable
as List<ModifierGroup>,prepStation: freezed == prepStation ? _self.prepStation : prepStation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? description,  String? sku,  String? imageUrl,  int categoryId,  int priceCents,  int costCents,  int taxPercent,  int stockQuantity,  bool trackStock,  ProductStatus status,  List<ModifierGroup> modifierGroups,  String? prepStation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.sku,_that.imageUrl,_that.categoryId,_that.priceCents,_that.costCents,_that.taxPercent,_that.stockQuantity,_that.trackStock,_that.status,_that.modifierGroups,_that.prepStation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? description,  String? sku,  String? imageUrl,  int categoryId,  int priceCents,  int costCents,  int taxPercent,  int stockQuantity,  bool trackStock,  ProductStatus status,  List<ModifierGroup> modifierGroups,  String? prepStation)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.name,_that.description,_that.sku,_that.imageUrl,_that.categoryId,_that.priceCents,_that.costCents,_that.taxPercent,_that.stockQuantity,_that.trackStock,_that.status,_that.modifierGroups,_that.prepStation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? description,  String? sku,  String? imageUrl,  int categoryId,  int priceCents,  int costCents,  int taxPercent,  int stockQuantity,  bool trackStock,  ProductStatus status,  List<ModifierGroup> modifierGroups,  String? prepStation)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.sku,_that.imageUrl,_that.categoryId,_that.priceCents,_that.costCents,_that.taxPercent,_that.stockQuantity,_that.trackStock,_that.status,_that.modifierGroups,_that.prepStation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Product extends Product {
  const _Product({required this.id, required this.name, this.description, this.sku, this.imageUrl, required this.categoryId, required this.priceCents, required this.costCents, this.taxPercent = 0, required this.stockQuantity, this.trackStock = true, this.status = ProductStatus.draft, final  List<ModifierGroup> modifierGroups = const [], this.prepStation}): _modifierGroups = modifierGroups,super._();
  factory _Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? description;
@override final  String? sku;
@override final  String? imageUrl;
@override final  int categoryId;
@override final  int priceCents;
// Keep as int for math
@override final  int costCents;
@override@JsonKey() final  int taxPercent;
// Tax as percentage (e.g., 10 = 10%)
@override final  int stockQuantity;
// Merged from Stock table
@override@JsonKey() final  bool trackStock;
// Whether sales decrement stock
@override@JsonKey() final  ProductStatus status;
 final  List<ModifierGroup> _modifierGroups;
@override@JsonKey() List<ModifierGroup> get modifierGroups {
  if (_modifierGroups is EqualUnmodifiableListView) return _modifierGroups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_modifierGroups);
}

// Free-text kitchen prep-station label (e.g. "Griglia"). Null = this
// product's line items stay on the customer receipt only, never
// ticketed (docs/features/02-kitchen-ticket-routing.md).
@override final  String? prepStation;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.priceCents, priceCents) || other.priceCents == priceCents)&&(identical(other.costCents, costCents) || other.costCents == costCents)&&(identical(other.taxPercent, taxPercent) || other.taxPercent == taxPercent)&&(identical(other.stockQuantity, stockQuantity) || other.stockQuantity == stockQuantity)&&(identical(other.trackStock, trackStock) || other.trackStock == trackStock)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._modifierGroups, _modifierGroups)&&(identical(other.prepStation, prepStation) || other.prepStation == prepStation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,sku,imageUrl,categoryId,priceCents,costCents,taxPercent,stockQuantity,trackStock,status,const DeepCollectionEquality().hash(_modifierGroups),prepStation);

@override
String toString() {
  return 'Product(id: $id, name: $name, description: $description, sku: $sku, imageUrl: $imageUrl, categoryId: $categoryId, priceCents: $priceCents, costCents: $costCents, taxPercent: $taxPercent, stockQuantity: $stockQuantity, trackStock: $trackStock, status: $status, modifierGroups: $modifierGroups, prepStation: $prepStation)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? description, String? sku, String? imageUrl, int categoryId, int priceCents, int costCents, int taxPercent, int stockQuantity, bool trackStock, ProductStatus status, List<ModifierGroup> modifierGroups, String? prepStation
});




}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? sku = freezed,Object? imageUrl = freezed,Object? categoryId = null,Object? priceCents = null,Object? costCents = null,Object? taxPercent = null,Object? stockQuantity = null,Object? trackStock = null,Object? status = null,Object? modifierGroups = null,Object? prepStation = freezed,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,priceCents: null == priceCents ? _self.priceCents : priceCents // ignore: cast_nullable_to_non_nullable
as int,costCents: null == costCents ? _self.costCents : costCents // ignore: cast_nullable_to_non_nullable
as int,taxPercent: null == taxPercent ? _self.taxPercent : taxPercent // ignore: cast_nullable_to_non_nullable
as int,stockQuantity: null == stockQuantity ? _self.stockQuantity : stockQuantity // ignore: cast_nullable_to_non_nullable
as int,trackStock: null == trackStock ? _self.trackStock : trackStock // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProductStatus,modifierGroups: null == modifierGroups ? _self._modifierGroups : modifierGroups // ignore: cast_nullable_to_non_nullable
as List<ModifierGroup>,prepStation: freezed == prepStation ? _self.prepStation : prepStation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
