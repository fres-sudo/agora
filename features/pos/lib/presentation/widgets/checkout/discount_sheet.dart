import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_discounts/feature_discounts.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:utils/utils.dart';

/// Discount entry at checkout (P6-1).
///
/// Lets the operator either enter a voucher **code** (validated via
/// [DiscountValidationCubit]) or pick from the list of currently-valid active
/// discounts (from [DiscountsBloc], filtered client-side by [Discount.isValid]
/// so the shared bloc filter is left untouched). Resolves with the chosen
/// [Discount], or `null` if dismissed.
class DiscountSheet extends StatefulWidget {
  const DiscountSheet({super.key, this.scrollController});

  final ScrollController? scrollController;

  static Future<Discount?> show(BuildContext context) {
    // Capture the already-registered blocs so the sheet (built under the root
    // navigator) can access them regardless of tree position — mirrors
    // CheckoutSheet.show.
    final discountsBloc = context.read<DiscountsBloc>();
    final validationCubit = context.read<DiscountValidationCubit>();

    // Ensure the discounts stream is running and start from a clean slate.
    discountsBloc.add(const DiscountsEvent.started());
    validationCubit.clear();

    return AdaptiveSheet.show<Discount>(
      context: context,
      builder: (sheetContext, scrollController) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<DiscountsBloc>.value(value: discountsBloc),
            BlocProvider<DiscountValidationCubit>.value(value: validationCubit),
          ],
          child: DiscountSheet(scrollController: scrollController),
        );
      },
    ).whenComplete(validationCubit.clear);
  }

  @override
  State<DiscountSheet> createState() => _DiscountSheetState();
}

class _DiscountSheetState extends State<DiscountSheet> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _applyCode() {
    context.read<DiscountValidationCubit>().validate(_codeController.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.scaffoldBackgroundColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(Sizes.lg)),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.lg),
          child: BlocListener<DiscountValidationCubit, DiscountValidationState>(
            listener: (context, state) {
              if (state is DiscountValidationValid) {
                Navigator.of(context).pop(state.discount);
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: Sizes.md),
                    decoration: BoxDecoration(
                      color: AppPalette.neutral300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'Apply Discount',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: Sizes.md),

                // Voucher code entry.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _codeController,
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(
                          labelText: 'Voucher code',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.confirmation_number_outlined),
                        ),
                        onSubmitted: (_) => _applyCode(),
                      ),
                    ),
                    const SizedBox(width: Sizes.sm),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: AppButton.primary(
                        label: 'Apply',
                        onPressed: _applyCode,
                      ),
                    ),
                  ],
                ),

                // Code validation feedback.
                BlocBuilder<DiscountValidationCubit, DiscountValidationState>(
                  builder: (context, state) {
                    final message = state.maybeMap(
                      invalid: (s) => s.reason,
                      error: (s) => s.message,
                      orElse: () => null,
                    );
                    if (message == null) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(top: Sizes.sm),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppPalette.error500,
                            size: 18,
                          ),
                          const SizedBox(width: Sizes.xs),
                          Expanded(
                            child: Text(
                              message,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppPalette.error500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: Sizes.lg),
                Text(
                  'Active discounts',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: Sizes.sm),

                // Selectable list of valid active discounts.
                Flexible(
                  child: BlocBuilder<DiscountsBloc, DiscountsState>(
                    builder: (context, state) {
                      final available = state.discounts
                          .where((d) => d.isValid)
                          .toList();

                      if (available.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: Sizes.lg,
                          ),
                          child: Text(
                            'No active discounts. Create one in '
                            'Settings → Discount & Voucher.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppPalette.neutral500,
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        controller: widget.scrollController,
                        itemCount: available.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: Sizes.xs),
                        itemBuilder: (context, index) {
                          final discount = available[index];
                          return _DiscountTile(
                            discount: discount,
                            onTap: () =>
                                Navigator.of(context).pop(discount),
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: Sizes.md),
                AppButton.outline(
                  label: 'Cancel',
                  fullWidth: true,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DiscountTile extends StatelessWidget {
  const _DiscountTile({required this.discount, required this.onTap});

  final Discount discount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final valueLabel = discount.isPercentage
        ? '${discount.value}%'
        : formatCents(discount.value);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(Sizes.md),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(Sizes.md),
          decoration: BoxDecoration(
            border: Border.all(color: AppPalette.neutral200),
            borderRadius: BorderRadius.circular(Sizes.md),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.local_offer_outlined,
                color: AppPalette.primary500,
              ),
              const SizedBox(width: Sizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      discount.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (discount.code != null)
                      Text(
                        discount.code!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppPalette.neutral500,
                        ),
                      ),
                  ],
                ),
              ),
              Text(
                '-$valueLabel',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppPalette.primary500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
