import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:agora/discounts/models/discount/discount.dart';
import 'package:agora/discounts/repositories/discounts_repository.dart';
import 'package:agora/core/misc/result.dart';

part 'discount_validation_cubit.freezed.dart';
part 'discount_validation_state.dart';

/// Cubit for validating discount codes during checkout.
class DiscountValidationCubit extends Cubit<DiscountValidationState> {
  DiscountValidationCubit({
    required DiscountsRepository discountsRepository,
  })  : _discountsRepository = discountsRepository,
        super(const DiscountValidationState.initial());

  final DiscountsRepository _discountsRepository;

  // ============================================================
  // PUBLIC METHODS
  // ============================================================

  /// Validate a discount code.
  Future<void> validate(String code) async {
    if (code.trim().isEmpty) {
      emit(const DiscountValidationState.invalid(
        reason: 'Please enter a discount code',
      ));
      return;
    }

    emit(const DiscountValidationState.validating());

    final result = await _discountsRepository.getDiscountByCode(code.trim());

    result.when(
      success: (discount) {
        if (discount != null) {
          // Check if discount is still valid
          if (!discount.isActive) {
            emit(const DiscountValidationState.invalid(
              reason: 'This discount is no longer active',
            ));
          } else if (discount.validUntil != null &&
              discount.validUntil!.isBefore(DateTime.now())) {
            emit(const DiscountValidationState.invalid(
              reason: 'This discount has expired',
            ));
          } else if (discount.usageLimit != null &&
              discount.usageCount >= discount.usageLimit!) {
            emit(const DiscountValidationState.invalid(
              reason: 'This discount has reached its usage limit',
            ));
          } else {
            emit(DiscountValidationState.valid(discount: discount));
          }
        } else {
          emit(const DiscountValidationState.invalid(
            reason: 'Invalid discount code',
          ));
        }
      },
      error: (error) {
        emit(DiscountValidationState.error(
          message: 'Failed to validate code: ${error.toString()}',
        ));
      },
    );
  }

  /// Clear the validation state.
  void clear() {
    emit(const DiscountValidationState.initial());
  }
}

// ============================================================
// CONTEXT EXTENSIONS
// ============================================================

extension DiscountValidationCubitExtension on BuildContext {
  DiscountValidationCubit get discountValidationCubit =>
      read<DiscountValidationCubit>();
  DiscountValidationCubit get watchDiscountValidationCubit =>
      watch<DiscountValidationCubit>();
}
