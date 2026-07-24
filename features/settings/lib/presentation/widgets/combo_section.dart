import 'package:feature_settings/presentation/widgets/combo_form/combo_form_wrapper.dart';
import 'package:feature_settings/presentation/widgets/combo_list_item.dart';
import 'package:flutter/material.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:catalog/blocs/combos/combos_bloc.dart';
import 'package:catalog/blocs/products/products_bloc.dart';
import 'package:catalog/models/combo.dart';

/// Combo settings section for managing combos (Settings -> Combo). Mirrors
/// [ModifierSection]'s pattern; unlike modifiers, a combo has no
/// independently-persisted nested list, so edits don't need client-side
/// diffing — the whole [Combo] is sent as-is.
class ComboSection extends StatefulWidget {
  const ComboSection({super.key});

  @override
  State<ComboSection> createState() => _ComboSectionState();
}

class _ComboSectionState extends State<ComboSection> {
  @override
  void initState() {
    super.initState();
    context.read<CombosBloc>().add(const CombosEvent.started());
    // The combo form's product picker needs the live catalog; not every
    // route that reaches Settings first visited POS/Products, which is
    // where ProductsBloc is otherwise started (see feature_pos/pos_page.dart).
    context.read<ProductsBloc>().add(const ProductsEvent.started());
  }

  Future<void> _onAddCombo() async {
    final result = await ComboFormWrapper.showCreate(context);
    if (result != null && mounted) {
      context.read<CombosBloc>().add(CombosEvent.created(result));
    }
  }

  Future<void> _onEditCombo(Combo original) async {
    final result = await ComboFormWrapper.showEdit(context, original);
    if (result == null || !mounted) return;
    context.read<CombosBloc>().add(CombosEvent.updated(result));
  }

  Future<void> _onDeleteCombo(Combo combo) async {
    final confirmed = await ConfirmationDialog.showDelete(
      context: context,
      title: 'Delete Combo?',
      message:
          'Are you sure you want to delete this combo? It will no longer '
          'appear on the POS grid. Constituent product stock is never '
          'affected by deleting a combo.',
    );

    if (confirmed && mounted) {
      context.read<CombosBloc>().add(CombosEvent.deleted(combo.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return EffectListener<CombosBloc, CombosEffect>(
      onEffect: (context, effect) {
        if (effect is CombosShowError) {
          AppToast.error(context, message: effect.message);
        }
      },
      child: Container(
        color: context.colors.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(context.tokens.spaceLg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppText.headingSm('Combo'),
                  AppButton.primary(
                    onPressed: _onAddCombo,
                    label: 'Add Combo',
                    leadingIcon: const Icon(AgoraIcons.plus, size: 20),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Content
            Expanded(
              child: BlocBuilder<CombosBloc, CombosState>(
                builder: (context, state) {
                  return state.map(
                    initial: (_) =>
                        const Center(child: CircularProgressIndicator()),
                    loading: (_) =>
                        const Center(child: CircularProgressIndicator()),
                    loaded: (loaded) => _buildComboList(loaded.combos),
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

  Widget _buildComboList(List<Combo> combos) {
    if (combos.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: EdgeInsets.all(context.tokens.spaceLg),
      itemCount: combos.length,
      separatorBuilder: (context, index) => const SizedBox(height: Sizes.md),
      itemBuilder: (context, index) {
        final combo = combos[index];
        return ComboListItem(
          combo: combo,
          onTap: () => _onEditCombo(combo),
          onDelete: () => _onDeleteCombo(combo),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(AgoraIcons.gift, size: 64, color: context.colors.border),
          const SizedBox(height: Sizes.md),
          AppText.titleMd(
            'No combos yet',
            color: context.colors.mutedForeground,
          ),
          const SizedBox(height: Sizes.sm),
          AppText.body(
            'Add a combo (e.g. "Menu Completo") to bundle products at one price',
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
          Icon(
            AgoraIcons.alert_triangle,
            size: 48,
            color: context.colors.destructive,
          ),
          const SizedBox(height: Sizes.md),
          const AppText.titleMd('Failed to load combos'),
          const SizedBox(height: Sizes.sm),
          AppText.body(message, color: context.colors.mutedForeground),
          const SizedBox(height: Sizes.lg),
          AppButton.primary(
            onPressed: () =>
                context.read<CombosBloc>().add(const CombosEvent.started()),
            label: 'Retry',
          ),
        ],
      ),
    );
  }
}
