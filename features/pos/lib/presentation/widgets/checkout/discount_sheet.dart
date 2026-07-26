import 'package:bloc_exports/bloc_exports.dart';
import 'package:app_settings/app_settings.dart';
import 'package:discounts/discounts.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

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

    return AdaptiveModal.show<Discount>(
      context: context,
      style: AdaptiveModalStyle.sideSheet,
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
    final colors = context.colors;

    return Material(
      color: colors.background,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(context.tokens.radius.lg),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.all(context.tokens.spacing.md),
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
                    margin: EdgeInsets.only(bottom: context.tokens.spacing.sm),
                    decoration: BoxDecoration(
                      color: colors.border,
                      borderRadius: context.tokens.radius.borderFull,
                    ),
                  ),
                ),
                const AppText.headingSm('Apply Discount'),
                SizedBox(height: context.tokens.spacing.sm),

                // Voucher code entry.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _codeController,
                        label: 'Voucher code',
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.characters,
                        prefix: const Icon(AgoraIcons.tag),
                        onSubmitted: (_) => _applyCode(),
                      ),
                    ),
                    SizedBox(width: context.tokens.spacing.xs),
                    AppButton.primary(label: 'Apply', onPressed: _applyCode),
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
                      padding: EdgeInsets.only(top: context.tokens.spacing.xs),
                      child: Row(
                        children: [
                          Icon(
                            AgoraIcons.alert_triangle,
                            color: colors.destructive,
                            size: 18,
                          ),
                          SizedBox(width: context.tokens.spacing.xxs),
                          Expanded(
                            child: AppText.bodySm(
                              message,
                              color: colors.destructive,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                SizedBox(height: context.tokens.spacing.md),
                const AppText.titleMd('Active discounts'),
                SizedBox(height: context.tokens.spacing.xs),

                // Selectable list of valid active discounts.
                Flexible(
                  child: BlocBuilder<DiscountsBloc, DiscountsState>(
                    builder: (context, state) {
                      final available = state.discounts
                          .where((d) => d.isValid)
                          .toList();

                      if (available.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: context.tokens.spacing.md,
                          ),
                          child: AppText.body(
                            'No active discounts. Create one in '
                            'Settings → Discount & Voucher.',
                            color: colors.mutedForeground,
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        controller: widget.scrollController,
                        itemCount: available.length,
                        separatorBuilder: (_, _) =>
                            SizedBox(height: context.tokens.spacing.xxs),
                        itemBuilder: (context, index) {
                          final discount = available[index];
                          return _DiscountTile(
                            discount: discount,
                            onTap: () => Navigator.of(context).pop(discount),
                          );
                        },
                      );
                    },
                  ),
                ),

                SizedBox(height: context.tokens.spacing.sm),
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
    final colors = context.colors;
    final valueLabel = discount.isPercentage
        ? '${discount.value}%'
        : context.formatCurrency(discount.value);

    return Material(
      color: colors.card,
      borderRadius: BorderRadius.circular(context.tokens.radius.md),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(context.tokens.spacing.sm),
          decoration: BoxDecoration(
            border: Border.all(color: colors.border),
            borderRadius: BorderRadius.circular(context.tokens.radius.md),
          ),
          child: Row(
            children: [
              Icon(AgoraIcons.discount, color: colors.primary),
              SizedBox(width: context.tokens.spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.titleMd(discount.name),
                    if (discount.code != null)
                      AppText.bodySm(
                        discount.code!,
                        color: colors.mutedForeground,
                      ),
                  ],
                ),
              ),
              AppText.titleMd('-$valueLabel', color: colors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
