part of 'product_form_cubit.dart';

/// The different steps in the product form wizard.
enum ProductFormStep {
  productInfo,
  pricing,
  variantsModifiers,
  ingredients,
}

@freezed
class ProductFormState with _$ProductFormState {
  const ProductFormState._();

  /// Initial/empty form state.
  const factory ProductFormState.initial() = _Initial;

  /// Form is being edited.
  const factory ProductFormState.editing({
    /// Current step in the wizard.
    @Default(ProductFormStep.productInfo) ProductFormStep currentStep,

    /// Form data being edited.
    required ProductFormData formData,

    /// Whether this is editing an existing product.
    @Default(false) bool isEditing,

    /// Validation errors per field.
    @Default({}) Map<String, String> errors,
  }) = ProductFormEditing;

  /// Form is being submitted.
  const factory ProductFormState.submitting({
    required ProductFormData formData,
    @Default(false) bool asDraft,
  }) = _Submitting;

  /// Form was successfully submitted.
  const factory ProductFormState.success({
    required int productId,
    @Default(false) bool isNew,
  }) = _Success;

  /// Error occurred during submission.
  const factory ProductFormState.error({
    required String message,
    required ProductFormData formData,
    @Default(ProductFormStep.productInfo) ProductFormStep currentStep,
  }) = _Error;

  /// Returns true if on the first step.
  bool get isFirstStep => maybeMap(
        editing: (s) => s.currentStep == ProductFormStep.productInfo,
        orElse: () => true,
      );

  /// Returns true if on the last step.
  bool get isLastStep => maybeMap(
        editing: (s) => s.currentStep == ProductFormStep.ingredients,
        orElse: () => false,
      );

  /// Returns the current step index (0-3).
  int get currentStepIndex => maybeMap(
        editing: (s) => s.currentStep.index,
        error: (s) => s.currentStep.index,
        orElse: () => 0,
      );
}
