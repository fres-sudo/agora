import 'package:result/result.dart';
import 'package:catalog/models/product.dart';
import 'package:feature_products/domain/models/product_form_data.dart';
import 'package:catalog/models/product_status.dart';
import 'package:catalog/repositories/modifiers_repository.dart';
import 'package:catalog/repositories/products_repository.dart';
import 'package:feature_products/presentation/utils/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:bloc_exports/bloc_exports.dart';

part 'product_form_cubit.freezed.dart';
part 'product_form_state.dart';

/// Cubit for managing the multi-step product form.
class ProductFormCubit extends Cubit<ProductFormState> {
  ProductFormCubit({
    required ProductsRepository productsRepository,
    required ModifiersRepository modifiersRepository,
  }) : _productsRepository = productsRepository,
       _modifiersRepository = modifiersRepository,
       super(const ProductFormState.initial());

  final ProductsRepository _productsRepository;
  final ModifiersRepository _modifiersRepository;

  // ============================================================
  // INITIALIZATION
  // ============================================================

  /// Initialize form for creating a new product.
  void initCreate() {
    emit(
      ProductFormState.editing(
        formData: const ProductFormData(),
        isEditing: false,
      ),
    );
  }

  /// Initialize form for editing an existing product.
  void initEdit(Product product) {
    emit(
      ProductFormState.editing(
        formData: ProductFormData(
          id: product.id,
          name: product.name,
          description: product.description ?? '',
          sku: product.sku ?? '',
          imageUrl: product.imageUrl,
          categoryId: product.categoryId,
          priceCents: product.priceCents,
          costCents: product.costCents,
          taxPercent: product.taxPercent,
          stockQuantity: product.stockQuantity,
          status: product.status,
          selectedModifierIds: product.modifierGroups
              .map((group) => group.id)
              .toList(),
          prepStation: product.prepStation,
        ),
        isEditing: true,
      ),
    );
  }

  // ============================================================
  // FORM NAVIGATION
  // ============================================================

  /// Move to the next step if validation passes.
  void nextStep() {
    final currentState = state;
    if (currentState is! ProductFormEditing) return;
    if (currentState.isLastStep) return;

    // Validate current step
    final errors = _validateStep(
      currentState.currentStep,
      currentState.formData,
    );
    if (errors.isNotEmpty) {
      emit(currentState.copyWith(errors: errors));
      return;
    }

    final nextStep = ProductFormStep.values[currentState.currentStep.index + 1];
    emit(currentState.copyWith(currentStep: nextStep, errors: {}));
  }

  /// Move to the previous step.
  void previousStep() {
    final currentState = state;
    if (currentState is! ProductFormEditing) return;
    if (currentState.isFirstStep) return;

    final prevStep = ProductFormStep.values[currentState.currentStep.index - 1];
    emit(currentState.copyWith(currentStep: prevStep, errors: {}));
  }

  /// Jump to a specific step.
  void goToStep(ProductFormStep step) {
    final currentState = state;
    if (currentState is! ProductFormEditing) return;

    emit(currentState.copyWith(currentStep: step, errors: {}));
  }

  // ============================================================
  // FORM UPDATES
  // ============================================================

  /// Update the form data, optionally clearing a single field's error.
  ///
  /// Pass [clearError] with the field key to dismiss its error as the user edits.
  /// Errors for other fields are preserved until the next step validation.
  void updateFormData(
    ProductFormData Function(ProductFormData) update, {
    String? clearError,
  }) {
    final currentState = state;
    if (currentState is! ProductFormEditing) return;

    final errors = clearError != null
        ? (Map<String, String>.from(currentState.errors)..remove(clearError))
        : currentState.errors;

    emit(
      currentState.copyWith(
        formData: update(currentState.formData),
        errors: errors,
      ),
    );
  }

  void updateName(String name) =>
      updateFormData((d) => d.copyWith(name: name), clearError: 'name');

  void updateDescription(String description) => updateFormData(
    (d) => d.copyWith(description: description),
    clearError: 'description',
  );

  void updateSku(String sku) =>
      updateFormData((d) => d.copyWith(sku: sku), clearError: 'sku');

  void updateCategory(int? categoryId) => updateFormData(
    (d) => d.copyWith(categoryId: categoryId),
    clearError: 'category',
  );

  void updatePrice(int priceCents) => updateFormData(
    (d) => d.copyWith(priceCents: priceCents),
    clearError: 'price',
  );

  void updateCost(int costCents) => updateFormData(
    (d) => d.copyWith(costCents: costCents),
    clearError: 'cost',
  );

  void updateTaxPercent(int taxPercent) => updateFormData(
    (d) => d.copyWith(taxPercent: taxPercent),
    clearError: 'tax',
  );

  void updateImageUrl(String? imageUrl) =>
      updateFormData((d) => d.copyWith(imageUrl: imageUrl));

  void updatePrepStation(String? prepStation) => updateFormData(
    (d) => d.copyWith(
      prepStation: (prepStation == null || prepStation.trim().isEmpty)
          ? null
          : prepStation.trim(),
    ),
  );

  void toggleModifier(int modifierId) {
    updateFormData((data) {
      final modifiers = List<int>.from(data.selectedModifierIds);
      if (modifiers.contains(modifierId)) {
        modifiers.remove(modifierId);
      } else {
        modifiers.add(modifierId);
      }
      return data.copyWith(selectedModifierIds: modifiers);
    });
  }

  // ============================================================
  // SUBMISSION
  // ============================================================

  /// Submit the form and save the product.
  Future<void> submit({bool asDraft = false}) async {
    final currentState = state;
    if (currentState is! ProductFormEditing) return;

    final formData = currentState.formData;

    // Final validation
    if (!formData.isValid) {
      emit(
        currentState.copyWith(
          errors: {'name': 'Product name is required'},
          currentStep: ProductFormStep.productInfo,
        ),
      );
      return;
    }

    emit(ProductFormState.submitting(formData: formData, asDraft: asDraft));

    final product = Product(
      id: formData.id,
      name: formData.name.trim(),
      description: formData.description.isEmpty
          ? null
          : formData.description.trim(),
      sku: formData.sku.isEmpty ? null : formData.sku.trim(),
      imageUrl: formData.imageUrl,
      categoryId: formData.categoryId ?? 0,
      priceCents: formData.priceCents,
      costCents: formData.costCents,
      taxPercent: formData.taxPercent,
      stockQuantity: formData.stockQuantity,
      status: asDraft ? ProductStatus.draft : formData.status,
      prepStation: formData.prepStation,
    );

    final isNew = formData.id == 0;
    final result = isNew
        ? await _productsRepository.createProduct(product)
        : await _productsRepository.updateProduct(product);

    switch (result) {
      case Ok<Product>(:final value):
        // Persist the product<->modifier links selected on the "Variants &
        // Modifiers" step. The product row is already safely saved at this
        // point, so a failure here is logged rather than surfaced as a
        // blocking error — retrying would otherwise risk creating a
        // duplicate product (submit() branches create-vs-update on
        // `formData.id == 0`).
        final modifiersResult = await _modifiersRepository.setProductModifiers(
          productId: value.id,
          modifierIds: formData.selectedModifierIds,
        );
        if (modifiersResult is Error<void>) {
          debugPrint(
            'Failed to save product modifiers for product ${value.id}: '
            '${modifiersResult.error}',
          );
        }
        emit(ProductFormState.success(productId: value.id, isNew: isNew));
      case Error<Product>(:final error):
        emit(
          ProductFormState.error(
            message: error.toString(),
            formData: formData,
            currentStep: currentState.currentStep,
          ),
        );
    }
  }

  /// Save as draft.
  Future<void> saveAsDraft() => submit(asDraft: true);

  // ============================================================
  // VALIDATION
  // ============================================================

  Map<String, String> _validateStep(
    ProductFormStep step,
    ProductFormData data,
  ) {
    final errors = <String, String>{};

    void check(String key, String? error) {
      if (error != null) errors[key] = error;
    }

    switch (step) {
      case ProductFormStep.productInfo:
        check('name', FormValidators.validateName(data.name));
        check('category', FormValidators.validateCategory(data.categoryId));
        check(
          'description',
          FormValidators.validateDescription(data.description),
        );
        check('sku', FormValidators.validateSku(data.sku));
        break;
      case ProductFormStep.pricing:
        check('price', FormValidators.validatePrice(data.priceCents));
        check('tax', FormValidators.validateTax(data.taxPercent));
        break;
      case ProductFormStep.variantsModifiers:
        break;
    }

    return errors;
  }
}

// ============================================================
// CONTEXT EXTENSIONS
// ============================================================

extension ProductFormCubitExtension on BuildContext {
  ProductFormCubit get productFormCubit => read<ProductFormCubit>();
  ProductFormCubit get watchProductFormCubit => watch<ProductFormCubit>();
}
