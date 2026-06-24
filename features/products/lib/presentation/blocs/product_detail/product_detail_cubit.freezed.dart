// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductDetailState()';
}


}

/// @nodoc
class $ProductDetailStateCopyWith<$Res>  {
$ProductDetailStateCopyWith(ProductDetailState _, $Res Function(ProductDetailState) __);
}


/// Adds pattern-matching-related methods to [ProductDetailState].
extension ProductDetailStatePatterns on ProductDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( ProductDetailLoaded value)?  loaded,TResult Function( _Creating value)?  creating,TResult Function( _Saving value)?  saving,TResult Function( _Saved value)?  saved,TResult Function( _Deleting value)?  deleting,TResult Function( _Deleted value)?  deleted,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case ProductDetailLoaded() when loaded != null:
return loaded(_that);case _Creating() when creating != null:
return creating(_that);case _Saving() when saving != null:
return saving(_that);case _Saved() when saved != null:
return saved(_that);case _Deleting() when deleting != null:
return deleting(_that);case _Deleted() when deleted != null:
return deleted(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( ProductDetailLoaded value)  loaded,required TResult Function( _Creating value)  creating,required TResult Function( _Saving value)  saving,required TResult Function( _Saved value)  saved,required TResult Function( _Deleting value)  deleting,required TResult Function( _Deleted value)  deleted,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case ProductDetailLoaded():
return loaded(_that);case _Creating():
return creating(_that);case _Saving():
return saving(_that);case _Saved():
return saved(_that);case _Deleting():
return deleting(_that);case _Deleted():
return deleted(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( ProductDetailLoaded value)?  loaded,TResult? Function( _Creating value)?  creating,TResult? Function( _Saving value)?  saving,TResult? Function( _Saved value)?  saved,TResult? Function( _Deleting value)?  deleting,TResult? Function( _Deleted value)?  deleted,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case ProductDetailLoaded() when loaded != null:
return loaded(_that);case _Creating() when creating != null:
return creating(_that);case _Saving() when saving != null:
return saving(_that);case _Saved() when saved != null:
return saved(_that);case _Deleting() when deleting != null:
return deleting(_that);case _Deleted() when deleted != null:
return deleted(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( Product product,  List<ModifierGroup> modifiers)?  loaded,TResult Function()?  creating,TResult Function( Product product)?  saving,TResult Function( Product product)?  saved,TResult Function( Product product)?  deleting,TResult Function()?  deleted,TResult Function( String message,  Product? product)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case ProductDetailLoaded() when loaded != null:
return loaded(_that.product,_that.modifiers);case _Creating() when creating != null:
return creating();case _Saving() when saving != null:
return saving(_that.product);case _Saved() when saved != null:
return saved(_that.product);case _Deleting() when deleting != null:
return deleting(_that.product);case _Deleted() when deleted != null:
return deleted();case _Error() when error != null:
return error(_that.message,_that.product);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( Product product,  List<ModifierGroup> modifiers)  loaded,required TResult Function()  creating,required TResult Function( Product product)  saving,required TResult Function( Product product)  saved,required TResult Function( Product product)  deleting,required TResult Function()  deleted,required TResult Function( String message,  Product? product)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case ProductDetailLoaded():
return loaded(_that.product,_that.modifiers);case _Creating():
return creating();case _Saving():
return saving(_that.product);case _Saved():
return saved(_that.product);case _Deleting():
return deleting(_that.product);case _Deleted():
return deleted();case _Error():
return error(_that.message,_that.product);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( Product product,  List<ModifierGroup> modifiers)?  loaded,TResult? Function()?  creating,TResult? Function( Product product)?  saving,TResult? Function( Product product)?  saved,TResult? Function( Product product)?  deleting,TResult? Function()?  deleted,TResult? Function( String message,  Product? product)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case ProductDetailLoaded() when loaded != null:
return loaded(_that.product,_that.modifiers);case _Creating() when creating != null:
return creating();case _Saving() when saving != null:
return saving(_that.product);case _Saved() when saved != null:
return saved(_that.product);case _Deleting() when deleting != null:
return deleting(_that.product);case _Deleted() when deleted != null:
return deleted();case _Error() when error != null:
return error(_that.message,_that.product);case _:
  return null;

}
}

}

/// @nodoc


class _Initial extends ProductDetailState {
  const _Initial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductDetailState.initial()';
}


}




/// @nodoc


class _Loading extends ProductDetailState {
  const _Loading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductDetailState.loading()';
}


}




/// @nodoc


class ProductDetailLoaded extends ProductDetailState {
  const ProductDetailLoaded({required this.product, final  List<ModifierGroup> modifiers = const []}): _modifiers = modifiers,super._();
  

 final  Product product;
 final  List<ModifierGroup> _modifiers;
@JsonKey() List<ModifierGroup> get modifiers {
  if (_modifiers is EqualUnmodifiableListView) return _modifiers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_modifiers);
}


/// Create a copy of ProductDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductDetailLoadedCopyWith<ProductDetailLoaded> get copyWith => _$ProductDetailLoadedCopyWithImpl<ProductDetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDetailLoaded&&(identical(other.product, product) || other.product == product)&&const DeepCollectionEquality().equals(other._modifiers, _modifiers));
}


@override
int get hashCode => Object.hash(runtimeType,product,const DeepCollectionEquality().hash(_modifiers));

@override
String toString() {
  return 'ProductDetailState.loaded(product: $product, modifiers: $modifiers)';
}


}

/// @nodoc
abstract mixin class $ProductDetailLoadedCopyWith<$Res> implements $ProductDetailStateCopyWith<$Res> {
  factory $ProductDetailLoadedCopyWith(ProductDetailLoaded value, $Res Function(ProductDetailLoaded) _then) = _$ProductDetailLoadedCopyWithImpl;
@useResult
$Res call({
 Product product, List<ModifierGroup> modifiers
});


$ProductCopyWith<$Res> get product;

}
/// @nodoc
class _$ProductDetailLoadedCopyWithImpl<$Res>
    implements $ProductDetailLoadedCopyWith<$Res> {
  _$ProductDetailLoadedCopyWithImpl(this._self, this._then);

  final ProductDetailLoaded _self;
  final $Res Function(ProductDetailLoaded) _then;

/// Create a copy of ProductDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? product = null,Object? modifiers = null,}) {
  return _then(ProductDetailLoaded(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as Product,modifiers: null == modifiers ? _self._modifiers : modifiers // ignore: cast_nullable_to_non_nullable
as List<ModifierGroup>,
  ));
}

/// Create a copy of ProductDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCopyWith<$Res> get product {
  
  return $ProductCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}

/// @nodoc


class _Creating extends ProductDetailState {
  const _Creating(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Creating);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductDetailState.creating()';
}


}




/// @nodoc


class _Saving extends ProductDetailState {
  const _Saving({required this.product}): super._();
  

 final  Product product;

/// Create a copy of ProductDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavingCopyWith<_Saving> get copyWith => __$SavingCopyWithImpl<_Saving>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Saving&&(identical(other.product, product) || other.product == product));
}


@override
int get hashCode => Object.hash(runtimeType,product);

@override
String toString() {
  return 'ProductDetailState.saving(product: $product)';
}


}

/// @nodoc
abstract mixin class _$SavingCopyWith<$Res> implements $ProductDetailStateCopyWith<$Res> {
  factory _$SavingCopyWith(_Saving value, $Res Function(_Saving) _then) = __$SavingCopyWithImpl;
@useResult
$Res call({
 Product product
});


$ProductCopyWith<$Res> get product;

}
/// @nodoc
class __$SavingCopyWithImpl<$Res>
    implements _$SavingCopyWith<$Res> {
  __$SavingCopyWithImpl(this._self, this._then);

  final _Saving _self;
  final $Res Function(_Saving) _then;

/// Create a copy of ProductDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? product = null,}) {
  return _then(_Saving(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as Product,
  ));
}

/// Create a copy of ProductDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCopyWith<$Res> get product {
  
  return $ProductCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}

/// @nodoc


class _Saved extends ProductDetailState {
  const _Saved({required this.product}): super._();
  

 final  Product product;

/// Create a copy of ProductDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavedCopyWith<_Saved> get copyWith => __$SavedCopyWithImpl<_Saved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Saved&&(identical(other.product, product) || other.product == product));
}


@override
int get hashCode => Object.hash(runtimeType,product);

@override
String toString() {
  return 'ProductDetailState.saved(product: $product)';
}


}

/// @nodoc
abstract mixin class _$SavedCopyWith<$Res> implements $ProductDetailStateCopyWith<$Res> {
  factory _$SavedCopyWith(_Saved value, $Res Function(_Saved) _then) = __$SavedCopyWithImpl;
@useResult
$Res call({
 Product product
});


$ProductCopyWith<$Res> get product;

}
/// @nodoc
class __$SavedCopyWithImpl<$Res>
    implements _$SavedCopyWith<$Res> {
  __$SavedCopyWithImpl(this._self, this._then);

  final _Saved _self;
  final $Res Function(_Saved) _then;

/// Create a copy of ProductDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? product = null,}) {
  return _then(_Saved(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as Product,
  ));
}

/// Create a copy of ProductDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCopyWith<$Res> get product {
  
  return $ProductCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}

/// @nodoc


class _Deleting extends ProductDetailState {
  const _Deleting({required this.product}): super._();
  

 final  Product product;

/// Create a copy of ProductDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeletingCopyWith<_Deleting> get copyWith => __$DeletingCopyWithImpl<_Deleting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Deleting&&(identical(other.product, product) || other.product == product));
}


@override
int get hashCode => Object.hash(runtimeType,product);

@override
String toString() {
  return 'ProductDetailState.deleting(product: $product)';
}


}

/// @nodoc
abstract mixin class _$DeletingCopyWith<$Res> implements $ProductDetailStateCopyWith<$Res> {
  factory _$DeletingCopyWith(_Deleting value, $Res Function(_Deleting) _then) = __$DeletingCopyWithImpl;
@useResult
$Res call({
 Product product
});


$ProductCopyWith<$Res> get product;

}
/// @nodoc
class __$DeletingCopyWithImpl<$Res>
    implements _$DeletingCopyWith<$Res> {
  __$DeletingCopyWithImpl(this._self, this._then);

  final _Deleting _self;
  final $Res Function(_Deleting) _then;

/// Create a copy of ProductDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? product = null,}) {
  return _then(_Deleting(
product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as Product,
  ));
}

/// Create a copy of ProductDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCopyWith<$Res> get product {
  
  return $ProductCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}

/// @nodoc


class _Deleted extends ProductDetailState {
  const _Deleted(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Deleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductDetailState.deleted()';
}


}




/// @nodoc


class _Error extends ProductDetailState {
  const _Error({required this.message, this.product}): super._();
  

 final  String message;
 final  Product? product;

/// Create a copy of ProductDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message)&&(identical(other.product, product) || other.product == product));
}


@override
int get hashCode => Object.hash(runtimeType,message,product);

@override
String toString() {
  return 'ProductDetailState.error(message: $message, product: $product)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $ProductDetailStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message, Product? product
});


$ProductCopyWith<$Res>? get product;

}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of ProductDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? product = freezed,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as Product?,
  ));
}

/// Create a copy of ProductDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCopyWith<$Res>? get product {
    if (_self.product == null) {
    return null;
  }

  return $ProductCopyWith<$Res>(_self.product!, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}

// dart format on
