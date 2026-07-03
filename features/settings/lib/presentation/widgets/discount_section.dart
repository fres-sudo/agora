import 'package:feature_discounts/feature_discounts.dart';
import 'package:feature_settings/presentation/widgets/discount_form/discount_form_wrapper.dart';
import 'package:feature_settings/presentation/widgets/discount_list_item.dart';
import 'package:flutter/material.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:ui_kit/ui_kit.dart';

/// Discount & voucher settings section (Settings → Discount & Voucher, P6-3).
/// Mirrors [CategorySection]/[ModifierSection]: CRUD over the global
/// [DiscountsBloc].
class DiscountVoucherSection extends StatefulWidget {
  const DiscountVoucherSection({super.key});

  @override
  State<DiscountVoucherSection> createState() => _DiscountVoucherSectionState();
}

class _DiscountVoucherSectionState extends State<DiscountVoucherSection> {
  @override
  void initState() {
    super.initState();
    context.read<DiscountsBloc>().add(const DiscountsEvent.started());
  }

  Future<void> _onAddDiscount() async {
    final result = await DiscountFormWrapper.showCreate(context);
    if (result != null && mounted) {
      context.read<DiscountsBloc>().add(DiscountsEvent.created(result));
    }
  }

  Future<void> _onEditDiscount(Discount original) async {
    final result = await DiscountFormWrapper.showEdit(context, original);
    if (result != null && mounted) {
      context.read<DiscountsBloc>().add(DiscountsEvent.updated(result));
    }
  }

  void _onToggleDiscount(Discount discount, bool isActive) {
    context.read<DiscountsBloc>().add(
      DiscountsEvent.toggled(id: discount.id, isActive: isActive),
    );
  }

  Future<void> _onDeleteDiscount(Discount discount) async {
    final confirmed = await ConfirmationDialog.showDelete(
      context: context,
      title: 'Delete Discount?',
      message:
          'Are you sure you want to delete "${discount.name}"? It will no '
          'longer be available at checkout.',
    );
    if (confirmed && mounted) {
      context.read<DiscountsBloc>().add(DiscountsEvent.deleted(discount.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return EffectListener<DiscountsBloc, DiscountsEffect>(
      onEffect: (context, effect) {
        if (effect is DiscountsShowError) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: AppText.body(
                  effect.message,
                  color: context.colors.destructiveForeground,
                ),
                backgroundColor: context.colors.destructive,
              ),
            );
        }
      },
      child: Container(
        color: context.colors.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppText.headingSm('Discount & Voucher'),
                  AppButton.primary(
                    onPressed: _onAddDiscount,
                    label: 'Add Discount',
                    leadingIcon: const Icon(Icons.add, size: 20),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: BlocBuilder<DiscountsBloc, DiscountsState>(
                builder: (context, state) {
                  return state.map(
                    initial: (_) =>
                        const Center(child: CircularProgressIndicator()),
                    loading: (_) =>
                        const Center(child: CircularProgressIndicator()),
                    loaded: (loaded) => _buildList(loaded.discounts),
                    error: (error) => _buildErrorState(error.message),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<Discount> discounts) {
    if (discounts.isEmpty) return _buildEmptyState();

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: discounts.length,
      separatorBuilder: (_, _) => const SizedBox(height: Sizes.md),
      itemBuilder: (context, index) {
        final discount = discounts[index];
        return DiscountListItem(
          discount: discount,
          onTap: () => _onEditDiscount(discount),
          onToggle: (isActive) => _onToggleDiscount(discount, isActive),
          onDelete: () => _onDeleteDiscount(discount),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_offer_outlined,
            size: 64,
            color: AppPalette.neutral300,
          ),
          const SizedBox(height: Sizes.md),
          AppText.titleMd(
            'No discounts yet',
            color: context.colors.mutedForeground,
          ),
          const SizedBox(height: Sizes.sm),
          AppText.body(
            'Add a discount (e.g. "10% off" or a voucher code) to get started',
            color: context.colors.mutedForeground,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: AppPalette.error500),
          const SizedBox(height: Sizes.md),
          const AppText.titleMd('Failed to load discounts'),
          const SizedBox(height: Sizes.sm),
          AppText.body(message, color: context.colors.mutedForeground),
          const SizedBox(height: Sizes.lg),
          AppButton.primary(
            onPressed: () =>
                context.read<DiscountsBloc>().add(const DiscountsEvent.started()),
            label: 'Retry',
          ),
        ],
      ),
    );
  }
}
