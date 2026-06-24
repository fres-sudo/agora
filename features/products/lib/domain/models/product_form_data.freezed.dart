// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_form_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductFormData {

/// The product ID (0 for new products).
 int get id;/// Product name.
 String get name;/// Product description.
 String get description;/// Product SKU/barcode.
 String get sku;/// Product image URL.
 String? get imageUrl;/// Selected category ID.
 int? get categoryId;/// Price in cents.
 int get priceCents;/// Cost in cents.
 int get costCents;/// Tax percentage.
 int get taxPercent;/// Stock quantity.
 int get stockQuantity;/// Product status.
 ProductStatus get status;/// Whether this product has unlimited availability (ignores ingredients).
 bool get unlimitedAvailability;/// Selected modifier group IDs.
 List<int> get selectedModifierIds;/// Ingredients with quantities (productId -> quantity).
 Map<int, double> get ingredients;
/// Create a copy of ProductFormData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductFormDataCopyWith<ProductFormData> get copyWith => _$ProductFormDataCopyWithImpl<ProductFormData>(this as ProductFormData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductFormData&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.priceCents, priceCents) || other.priceCents == priceCents)&&(identical(other.costCents, costCents) || other.costCents == costCents)&&(identical(other.taxPercent, taxPercent) || other.taxPercent == taxPercent)&&(identical(other.stockQuantity, stockQuantity) || other.stockQuantity == stockQuantity)&&(identical(other.status, status) || other.status == status)&&(identical(other.unlimitedAvailability, unlimitedAvailability) || other.unlimitedAvailability == unlimitedAvailability)&&const DeepCollectionEquality().equals(other.selectedModifierIds, selectedModifierIds)&&const DeepCollectionEquality().equals(other.ingredients, ingredients));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,sku,imageUrl,categoryId,priceCents,costCents,taxPercent,stockQuantity,status,unlimitedAvailability,const DeepCollectionEquality().hash(selectedModifierIds),const DeepCollectionEquality().hash(ingredients));

@override
String toString() {
  return 'ProductFormData(id: $id, name: $name, description: $description, sku: $sku, imageUrl: $imageUrl, categoryId: $categoryId, priceCents: $priceCents, costCents: $costCents, taxPercent: $taxPercent, stockQuantity: $stockQuantity, status: $status, unlimitedAvailability: $unlimitedAvailability, selectedModifierIds: $selectedModifierIds, ingredients: $ingredients)';
}


}

/// @nodoc
abstract mixin class $ProductFormDataCopyWith<$Res>  {
  factory $ProductFormDataCopyWith(ProductFormData value, $Res Function(ProductFormData) _then) = _$ProductFormDataCopyWithImpl;
@useResult
$Res call({
 int id, String name, String description, String sku, String? imageUrl, int? categoryId, int priceCents, int costCents, int taxPercent, int stockQuantity, ProductStatus status, bool unlimitedAvailability, List<int> selectedModifierIds, Map<int, double> ingredients
});




}
/// @nodoc
class _$ProductFormDataCopyWithImpl<$Res>
    implements $ProductFormDataCopyWith<$Res> {
  _$ProductFormDataCopyWithImpl(this._self, this._then);

  final ProductFormData _self;
  final $Res Function(ProductFormData) _then;

/// Create a copy of ProductFormData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? sku = null,Object? imageUrl = freezed,Object? categoryId = freezed,Object? priceCents = null,Object? costCents = null,Object? taxPercent = null,Object? stockQuantity = null,Object? status = null,Object? unlimitedAvailability = null,Object? selectedModifierIds = null,Object? ingredients = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,priceCents: null == priceCents ? _self.priceCents : priceCents // ignore: cast_nullable_to_non_nullable
as int,costCents: null == costCents ? _self.costCents : costCents // ignore: cast_nullable_to_non_nullable
as int,taxPercent: null == taxPercent ? _self.taxPercent : taxPercent // ignore: cast_nullable_to_non_nullable
as int,stockQuantity: null == stockQuantity ? _self.stockQuantity : stockQuantity // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProductStatus,unlimitedAvailability: null == unlimitedAvailability ? _self.unlimitedAvailability : unlimitedAvailability // ignore: cast_nullable_to_non_nullable
as bool,selectedModifierIds: null == selectedModifierIds ? _self.selectedModifierIds : selectedModifierIds // ignore: cast_nullable_to_non_nullable
as List<int>,ingredients: null == ingredients ? _self.ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as Map<int, double>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductFormData].
extension ProductFormDataPatterns on ProductFormData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductFormData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductFormData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductFormData value)  $default,){
final _that = this;
switch (_that) {
case _ProductFormData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductFormData value)?  $default,){
final _that = this;
switch (_that) {
case _ProductFormData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String description,  String sku,  String? imageUrl,  int? categoryId,  int priceCents,  int costCents,  int taxPercent,  int stockQuantity,  ProductStatus status,  bool unlimitedAvailability,  List<int> selectedModifierIds,  Map<int, double> ingredients)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductFormData() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.sku,_that.imageUrl,_that.categoryId,_that.priceCents,_that.costCents,_that.taxPercent,_that.stockQuantity,_that.status,_that.unlimitedAvailability,_that.selectedModifierIds,_that.ingredients);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String description,  String sku,  String? imageUrl,  int? categoryId,  int priceCents,  int costCents,  int taxPercent,  int stockQuantity,  ProductStatus status,  bool unlimitedAvailability,  List<int> selectedModifierIds,  Map<int, double> ingredients)  $default,) {final _that = this;
switch (_that) {
case _ProductFormData():
return $default(_that.id,_that.name,_that.description,_that.sku,_that.imageUrl,_that.categoryId,_that.priceCents,_that.costCents,_that.taxPercent,_that.stockQuantity,_that.status,_that.unlimitedAvailability,_that.selectedModifierIds,_that.ingredients);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String description,  String sku,  String? imageUrl,  int? categoryId,  int priceCents,  int costCents,  int taxPercent,  int stockQuantity,  ProductStatus status,  bool unlimitedAvailability,  List<int> selectedModifierIds,  Map<int, double> ingredients)?  $default,) {final _that = this;
switch (_that) {
case _ProductFormData() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.sku,_that.imageUrl,_that.categoryId,_that.priceCents,_that.costCents,_that.taxPercent,_that.stockQuantity,_that.status,_that.unlimitedAvailability,_that.selectedModifierIds,_that.ingredients);case _:
  return null;

}
}

}

/// @nodoc


class _ProductFormData extends ProductFormData {
  const _ProductFormData({this.id = 0, this.name = '', this.description = '', this.sku = '', this.imageUrl, this.categoryId, this.priceCents = 0, this.costCents = 0, this.taxPercent = 0, this.stockQuantity = 0, this.status = ProductStatus.draft, this.unlimitedAvailability = false, final  List<int> selectedModifierIds = const [], final  Map<int, double> ingredients = const {}}): _selectedModifierIds = selectedModifierIds,_ingredients = ingredients,super._();
  

/// The product ID (0 for new products).
@override@JsonKey() final  int id;
/// Product name.
@override@JsonKey() final  String name;
/// Product description.
@override@JsonKey() final  String description;
/// Product SKU/barcode.
@override@JsonKey() final  String sku;
/// Product image URL.
@override final  String? imageUrl;
/// Selected category ID.
@override final  int? categoryId;
/// Price in cents.
@override@JsonKey() final  int priceCents;
/// Cost in cents.
@override@JsonKey() final  int costCents;
/// Tax percentage.
@override@JsonKey() final  int taxPercent;
/// Stock quantity.
@override@JsonKey() final  int stockQuantity;
/// Product status.
@override@JsonKey() final  ProductStatus status;
/// Whether this product has unlimited availability (ignores ingredients).
@override@JsonKey() final  bool unlimitedAvailability;
/// Selected modifier group IDs.
 final  List<int> _selectedModifierIds;
/// Selected modifier group IDs.
@override@JsonKey() List<int> get selectedModifierIds {
  if (_selectedModifierIds is EqualUnmodifiableListView) return _selectedModifierIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedModifierIds);
}

/// Ingredients with quantities (productId -> quantity).
 final  Map<int, double> _ingredients;
/// Ingredients with quantities (productId -> quantity).
@override@JsonKey() Map<int, double> get ingredients {
  if (_ingredients is EqualUnmodifiableMapView) return _ingredients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_ingredients);
}


/// Create a copy of ProductFormData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductFormDataCopyWith<_ProductFormData> get copyWith => __$ProductFormDataCopyWithImpl<_ProductFormData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductFormData&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.priceCents, priceCents) || other.priceCents == priceCents)&&(identical(other.costCents, costCents) || other.costCents == costCents)&&(identical(other.taxPercent, taxPercent) || other.taxPercent == taxPercent)&&(identical(other.stockQuantity, stockQuantity) || other.stockQuantity == stockQuantity)&&(identical(other.status, status) || other.status == status)&&(identical(other.unlimitedAvailability, unlimitedAvailability) || other.unlimitedAvailability == unlimitedAvailability)&&const DeepCollectionEquality().equals(other._selectedModifierIds, _selectedModifierIds)&&const DeepCollectionEquality().equals(other._ingredients, _ingredients));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,sku,imageUrl,categoryId,priceCents,costCents,taxPercent,stockQuantity,status,unlimitedAvailability,const DeepCollectionEquality().hash(_selectedModifierIds),const DeepCollectionEquality().hash(_ingredients));

@override
String toString() {
  return 'ProductFormData(id: $id, name: $name, description: $description, sku: $sku, imageUrl: $imageUrl, categoryId: $categoryId, priceCents: $priceCents, costCents: $costCents, taxPercent: $taxPercent, stockQuantity: $stockQuantity, status: $status, unlimitedAvailability: $unlimitedAvailability, selectedModifierIds: $selectedModifierIds, ingredients: $ingredients)';
}


}

/// @nodoc
abstract mixin class _$ProductFormDataCopyWith<$Res> implements $ProductFormDataCopyWith<$Res> {
  factory _$ProductFormDataCopyWith(_ProductFormData value, $Res Function(_ProductFormData) _then) = __$ProductFormDataCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String description, String sku, String? imageUrl, int? categoryId, int priceCents, int costCents, int taxPercent, int stockQuantity, ProductStatus status, bool unlimitedAvailability, List<int> selectedModifierIds, Map<int, double> ingredients
});




}
/// @nodoc
class __$ProductFormDataCopyWithImpl<$Res>
    implements _$ProductFormDataCopyWith<$Res> {
  __$ProductFormDataCopyWithImpl(this._self, this._then);

  final _ProductFormData _self;
  final $Res Function(_ProductFormData) _then;

/// Create a copy of ProductFormData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? sku = null,Object? imageUrl = freezed,Object? categoryId = freezed,Object? priceCents = null,Object? costCents = null,Object? taxPercent = null,Object? stockQuantity = null,Object? status = null,Object? unlimitedAvailability = null,Object? selectedModifierIds = null,Object? ingredients = null,}) {
  return _then(_ProductFormData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,priceCents: null == priceCents ? _self.priceCents : priceCents // ignore: cast_nullable_to_non_nullable
as int,costCents: null == costCents ? _self.costCents : costCents // ignore: cast_nullable_to_non_nullable
as int,taxPercent: null == taxPercent ? _self.taxPercent : taxPercent // ignore: cast_nullable_to_non_nullable
as int,stockQuantity: null == stockQuantity ? _self.stockQuantity : stockQuantity // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProductStatus,unlimitedAvailability: null == unlimitedAvailability ? _self.unlimitedAvailability : unlimitedAvailability // ignore: cast_nullable_to_non_nullable
as bool,selectedModifierIds: null == selectedModifierIds ? _self._selectedModifierIds : selectedModifierIds // ignore: cast_nullable_to_non_nullable
as List<int>,ingredients: null == ingredients ? _self._ingredients : ingredients // ignore: cast_nullable_to_non_nullable
as Map<int, double>,
  ));
}


}

// dart format on
