// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_form_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductFormState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductFormState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductFormState()';
}


}

/// @nodoc
class $ProductFormStateCopyWith<$Res>  {
$ProductFormStateCopyWith(ProductFormState _, $Res Function(ProductFormState) __);
}


/// Adds pattern-matching-related methods to [ProductFormState].
extension ProductFormStatePatterns on ProductFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( ProductFormEditing value)?  editing,TResult Function( _Submitting value)?  submitting,TResult Function( _Success value)?  success,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case ProductFormEditing() when editing != null:
return editing(_that);case _Submitting() when submitting != null:
return submitting(_that);case _Success() when success != null:
return success(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( ProductFormEditing value)  editing,required TResult Function( _Submitting value)  submitting,required TResult Function( _Success value)  success,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case ProductFormEditing():
return editing(_that);case _Submitting():
return submitting(_that);case _Success():
return success(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( ProductFormEditing value)?  editing,TResult? Function( _Submitting value)?  submitting,TResult? Function( _Success value)?  success,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case ProductFormEditing() when editing != null:
return editing(_that);case _Submitting() when submitting != null:
return submitting(_that);case _Success() when success != null:
return success(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( ProductFormStep currentStep,  ProductFormData formData,  bool isEditing,  Map<String, String> errors)?  editing,TResult Function( ProductFormData formData,  bool asDraft)?  submitting,TResult Function( int productId,  bool isNew)?  success,TResult Function( String message,  ProductFormData formData,  ProductFormStep currentStep)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case ProductFormEditing() when editing != null:
return editing(_that.currentStep,_that.formData,_that.isEditing,_that.errors);case _Submitting() when submitting != null:
return submitting(_that.formData,_that.asDraft);case _Success() when success != null:
return success(_that.productId,_that.isNew);case _Error() when error != null:
return error(_that.message,_that.formData,_that.currentStep);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( ProductFormStep currentStep,  ProductFormData formData,  bool isEditing,  Map<String, String> errors)  editing,required TResult Function( ProductFormData formData,  bool asDraft)  submitting,required TResult Function( int productId,  bool isNew)  success,required TResult Function( String message,  ProductFormData formData,  ProductFormStep currentStep)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case ProductFormEditing():
return editing(_that.currentStep,_that.formData,_that.isEditing,_that.errors);case _Submitting():
return submitting(_that.formData,_that.asDraft);case _Success():
return success(_that.productId,_that.isNew);case _Error():
return error(_that.message,_that.formData,_that.currentStep);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( ProductFormStep currentStep,  ProductFormData formData,  bool isEditing,  Map<String, String> errors)?  editing,TResult? Function( ProductFormData formData,  bool asDraft)?  submitting,TResult? Function( int productId,  bool isNew)?  success,TResult? Function( String message,  ProductFormData formData,  ProductFormStep currentStep)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case ProductFormEditing() when editing != null:
return editing(_that.currentStep,_that.formData,_that.isEditing,_that.errors);case _Submitting() when submitting != null:
return submitting(_that.formData,_that.asDraft);case _Success() when success != null:
return success(_that.productId,_that.isNew);case _Error() when error != null:
return error(_that.message,_that.formData,_that.currentStep);case _:
  return null;

}
}

}

/// @nodoc


class _Initial extends ProductFormState {
  const _Initial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductFormState.initial()';
}


}




/// @nodoc


class ProductFormEditing extends ProductFormState {
  const ProductFormEditing({this.currentStep = ProductFormStep.productInfo, required this.formData, this.isEditing = false, final  Map<String, String> errors = const {}}): _errors = errors,super._();
  

/// Current step in the wizard.
@JsonKey() final  ProductFormStep currentStep;
/// Form data being edited.
 final  ProductFormData formData;
/// Whether this is editing an existing product.
@JsonKey() final  bool isEditing;
/// Validation errors per field.
 final  Map<String, String> _errors;
/// Validation errors per field.
@JsonKey() Map<String, String> get errors {
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errors);
}


/// Create a copy of ProductFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductFormEditingCopyWith<ProductFormEditing> get copyWith => _$ProductFormEditingCopyWithImpl<ProductFormEditing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductFormEditing&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.formData, formData) || other.formData == formData)&&(identical(other.isEditing, isEditing) || other.isEditing == isEditing)&&const DeepCollectionEquality().equals(other._errors, _errors));
}


@override
int get hashCode => Object.hash(runtimeType,currentStep,formData,isEditing,const DeepCollectionEquality().hash(_errors));

@override
String toString() {
  return 'ProductFormState.editing(currentStep: $currentStep, formData: $formData, isEditing: $isEditing, errors: $errors)';
}


}

/// @nodoc
abstract mixin class $ProductFormEditingCopyWith<$Res> implements $ProductFormStateCopyWith<$Res> {
  factory $ProductFormEditingCopyWith(ProductFormEditing value, $Res Function(ProductFormEditing) _then) = _$ProductFormEditingCopyWithImpl;
@useResult
$Res call({
 ProductFormStep currentStep, ProductFormData formData, bool isEditing, Map<String, String> errors
});


$ProductFormDataCopyWith<$Res> get formData;

}
/// @nodoc
class _$ProductFormEditingCopyWithImpl<$Res>
    implements $ProductFormEditingCopyWith<$Res> {
  _$ProductFormEditingCopyWithImpl(this._self, this._then);

  final ProductFormEditing _self;
  final $Res Function(ProductFormEditing) _then;

/// Create a copy of ProductFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? currentStep = null,Object? formData = null,Object? isEditing = null,Object? errors = null,}) {
  return _then(ProductFormEditing(
currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as ProductFormStep,formData: null == formData ? _self.formData : formData // ignore: cast_nullable_to_non_nullable
as ProductFormData,isEditing: null == isEditing ? _self.isEditing : isEditing // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

/// Create a copy of ProductFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductFormDataCopyWith<$Res> get formData {
  
  return $ProductFormDataCopyWith<$Res>(_self.formData, (value) {
    return _then(_self.copyWith(formData: value));
  });
}
}

/// @nodoc


class _Submitting extends ProductFormState {
  const _Submitting({required this.formData, this.asDraft = false}): super._();
  

 final  ProductFormData formData;
@JsonKey() final  bool asDraft;

/// Create a copy of ProductFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmittingCopyWith<_Submitting> get copyWith => __$SubmittingCopyWithImpl<_Submitting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Submitting&&(identical(other.formData, formData) || other.formData == formData)&&(identical(other.asDraft, asDraft) || other.asDraft == asDraft));
}


@override
int get hashCode => Object.hash(runtimeType,formData,asDraft);

@override
String toString() {
  return 'ProductFormState.submitting(formData: $formData, asDraft: $asDraft)';
}


}

/// @nodoc
abstract mixin class _$SubmittingCopyWith<$Res> implements $ProductFormStateCopyWith<$Res> {
  factory _$SubmittingCopyWith(_Submitting value, $Res Function(_Submitting) _then) = __$SubmittingCopyWithImpl;
@useResult
$Res call({
 ProductFormData formData, bool asDraft
});


$ProductFormDataCopyWith<$Res> get formData;

}
/// @nodoc
class __$SubmittingCopyWithImpl<$Res>
    implements _$SubmittingCopyWith<$Res> {
  __$SubmittingCopyWithImpl(this._self, this._then);

  final _Submitting _self;
  final $Res Function(_Submitting) _then;

/// Create a copy of ProductFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? formData = null,Object? asDraft = null,}) {
  return _then(_Submitting(
formData: null == formData ? _self.formData : formData // ignore: cast_nullable_to_non_nullable
as ProductFormData,asDraft: null == asDraft ? _self.asDraft : asDraft // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ProductFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductFormDataCopyWith<$Res> get formData {
  
  return $ProductFormDataCopyWith<$Res>(_self.formData, (value) {
    return _then(_self.copyWith(formData: value));
  });
}
}

/// @nodoc


class _Success extends ProductFormState {
  const _Success({required this.productId, this.isNew = false}): super._();
  

 final  int productId;
@JsonKey() final  bool isNew;

/// Create a copy of ProductFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuccessCopyWith<_Success> get copyWith => __$SuccessCopyWithImpl<_Success>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.isNew, isNew) || other.isNew == isNew));
}


@override
int get hashCode => Object.hash(runtimeType,productId,isNew);

@override
String toString() {
  return 'ProductFormState.success(productId: $productId, isNew: $isNew)';
}


}

/// @nodoc
abstract mixin class _$SuccessCopyWith<$Res> implements $ProductFormStateCopyWith<$Res> {
  factory _$SuccessCopyWith(_Success value, $Res Function(_Success) _then) = __$SuccessCopyWithImpl;
@useResult
$Res call({
 int productId, bool isNew
});




}
/// @nodoc
class __$SuccessCopyWithImpl<$Res>
    implements _$SuccessCopyWith<$Res> {
  __$SuccessCopyWithImpl(this._self, this._then);

  final _Success _self;
  final $Res Function(_Success) _then;

/// Create a copy of ProductFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? isNew = null,}) {
  return _then(_Success(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,isNew: null == isNew ? _self.isNew : isNew // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _Error extends ProductFormState {
  const _Error({required this.message, required this.formData, this.currentStep = ProductFormStep.productInfo}): super._();
  

 final  String message;
 final  ProductFormData formData;
@JsonKey() final  ProductFormStep currentStep;

/// Create a copy of ProductFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message)&&(identical(other.formData, formData) || other.formData == formData)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep));
}


@override
int get hashCode => Object.hash(runtimeType,message,formData,currentStep);

@override
String toString() {
  return 'ProductFormState.error(message: $message, formData: $formData, currentStep: $currentStep)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $ProductFormStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message, ProductFormData formData, ProductFormStep currentStep
});


$ProductFormDataCopyWith<$Res> get formData;

}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of ProductFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? formData = null,Object? currentStep = null,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,formData: null == formData ? _self.formData : formData // ignore: cast_nullable_to_non_nullable
as ProductFormData,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as ProductFormStep,
  ));
}

/// Create a copy of ProductFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductFormDataCopyWith<$Res> get formData {
  
  return $ProductFormDataCopyWith<$Res>(_self.formData, (value) {
    return _then(_self.copyWith(formData: value));
  });
}
}

// dart format on
