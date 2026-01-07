import 'package:agora/core/misc/result.dart';
import 'package:agora/products/models/product/product.dart';
import 'package:agora/products/models/product/product_form_data.dart';
import 'package:agora/products/models/product/product_status.dart';
import 'package:agora/products/repositories/products_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_form_cubit.freezed.dart';
part 'product_form_state.dart';

/// Cubit for managing the multi-step product form.
class ProductFormCubit extends Cubit<ProductFormState> {
  ProductFormCubit({
    required ProductsRepository productsRepository,
  })  : _productsRepository = productsRepository,
        super(const ProductFormState.initial());

  final ProductsRepository _productsRepository;

  // ============================================================
  // INITIALIZATION
  // ============================================================

  /// Initialize form for creating a new product.
  void initCreate() {
    emit(ProductFormState.editing(
      formData: const ProductFormData(),
      isEditing: false,
    ));
  }

  /// Initialize form for editing an existing product.
  void initEdit(Product product) {
    emit(ProductFormState.editing(
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
      ),
      isEditing: true,
    ));
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
    final errors = _validateStep(currentState.currentStep, currentState.formData);
    if (errors.isNotEmpty) {
      emit(currentState.copyWith(errors: errors));
      return;
    }

    final nextStep = ProductFormStep.values[currentState.currentStep.index + 1];
    emit(currentState.copyWith(
      currentStep: nextStep,
      errors: {},
    ));
  }

  /// Move to the previous step.
  void previousStep() {
    final currentState = state;
    if (currentState is! ProductFormEditing) return;
    if (currentState.isFirstStep) return;

    final prevStep = ProductFormStep.values[currentState.currentStep.index - 1];
    emit(currentState.copyWith(
      currentStep: prevStep,
      errors: {},
    ));
  }

  /// Jump to a specific step.
  void goToStep(ProductFormStep step) {
    final currentState = state;
    if (currentState is! ProductFormEditing) return;

    emit(currentState.copyWith(
      currentStep: step,
      errors: {},
    ));
  }

  // ============================================================
  // FORM UPDATES
  // ============================================================

  /// Update the form data.
  void updateFormData(ProductFormData Function(ProductFormData) update) {
    final currentState = state;
    if (currentState is! ProductFormEditing) return;

    emit(currentState.copyWith(
      formData: update(currentState.formData),
      errors: {},
    ));
  }

  /// Update product name.
  void updateName(String name) {
    updateFormData((data) => data.copyWith(name: name));
  }

  /// Update product description.
  void updateDescription(String description) {
    updateFormData((data) => data.copyWith(description: description));
  }

  /// Update product SKU.
  void updateSku(String sku) {
    updateFormData((data) => data.copyWith(sku: sku));
  }

  /// Update product category.
  void updateCategory(int? categoryId) {
    updateFormData((data) => data.copyWith(categoryId: categoryId));
  }

  /// Update product price (in cents).
  void updatePrice(int priceCents) {
    updateFormData((data) => data.copyWith(priceCents: priceCents));
  }

  /// Update product cost (in cents).
  void updateCost(int costCents) {
    updateFormData((data) => data.copyWith(costCents: costCents));
  }

  /// Update tax percent.
  void updateTaxPercent(int taxPercent) {
    updateFormData((data) => data.copyWith(taxPercent: taxPercent));
  }

  /// Update product image URL.
  void updateImageUrl(String? imageUrl) {
    updateFormData((data) => data.copyWith(imageUrl: imageUrl));
  }

  /// Update unlimited availability.
  void updateUnlimitedAvailability(bool value) {
    updateFormData((data) => data.copyWith(unlimitedAvailability: value));
  }

  /// Toggle a modifier selection.
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

  /// Add or update an ingredient.
  void updateIngredient(int productId, double quantity) {
    updateFormData((data) {
      final ingredients = Map<int, double>.from(data.ingredients);
      if (quantity <= 0) {
        ingredients.remove(productId);
      } else {
        ingredients[productId] = quantity;
      }
      return data.copyWith(ingredients: ingredients);
    });
  }

  /// Remove an ingredient.
  void removeIngredient(int productId) {
    updateFormData((data) {
      final ingredients = Map<int, double>.from(data.ingredients);
      ingredients.remove(productId);
      return data.copyWith(ingredients: ingredients);
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
      emit(currentState.copyWith(
        errors: {'name': 'Product name is required'},
        currentStep: ProductFormStep.productInfo,
      ));
      return;
    }

    emit(ProductFormState.submitting(
      formData: formData,
      asDraft: asDraft,
    ));

    final product = Product(
      id: formData.id,
      name: formData.name.trim(),
      description: formData.description.isEmpty ? null : formData.description.trim(),
      sku: formData.sku.isEmpty ? null : formData.sku.trim(),
      imageUrl: formData.imageUrl,
      categoryId: formData.categoryId ?? 0,
      priceCents: formData.priceCents,
      costCents: formData.costCents,
      taxPercent: formData.taxPercent,
      stockQuantity: formData.stockQuantity,
      status: asDraft ? ProductStatus.draft : formData.status,
    );

    final isNew = formData.id == 0;
    final result = isNew
        ? await _productsRepository.createProduct(product)
        : await _productsRepository.updateProduct(product);

    result.when(
      success: (savedProduct) {
        emit(ProductFormState.success(
          productId: savedProduct.id,
          isNew: isNew,
        ));
      },
      error: (error) {
        emit(ProductFormState.error(
          message: error.toString(),
          formData: formData,
          currentStep: currentState.currentStep,
        ));
      },
    );
  }

  /// Save as draft.
  Future<void> saveAsDraft() => submit(asDraft: true);

  // ============================================================
  // VALIDATION
  // ============================================================

  Map<String, String> _validateStep(ProductFormStep step, ProductFormData data) {
    final errors = <String, String>{};

    switch (step) {
      case ProductFormStep.productInfo:
        if (data.name.trim().isEmpty) {
          errors['name'] = 'Product name is required';
        }
        if (data.categoryId == null) {
          errors['category'] = 'Please select a category';
        }
        break;
      case ProductFormStep.pricing:
        if (data.priceCents <= 0) {
          errors['price'] = 'Price must be greater than 0';
        }
        break;
      case ProductFormStep.variantsModifiers:
        // No required fields
        break;
      case ProductFormStep.ingredients:
        // No required fields
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
