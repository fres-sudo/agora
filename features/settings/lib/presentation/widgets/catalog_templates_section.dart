import 'package:catalog/models/catalog_template.dart';
import 'package:feature_settings/presentation/blocs/catalog_templates_cubit.dart';
import 'package:feature_settings/presentation/widgets/catalog_template_list_item.dart';
import 'package:flutter/material.dart';
import 'package:result/result.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:ui_kit/ui_kit.dart';

/// Catalog Templates settings section (Settings -> Catalog Templates,
/// docs/features/06-season-to-season-catalog-reuse.md). Lets an operator
/// snapshot the current menu/pricing as a named template and restore one at
/// the start of a new season, either additively or by replacing the
/// current catalog outright.
class CatalogTemplatesSection extends StatefulWidget {
  const CatalogTemplatesSection({super.key});

  @override
  State<CatalogTemplatesSection> createState() =>
      _CatalogTemplatesSectionState();
}

class _CatalogTemplatesSectionState extends State<CatalogTemplatesSection> {
  @override
  void initState() {
    super.initState();
    context.read<CatalogTemplatesCubit>().load();
  }

  Future<void> _onSaveAsTemplate() async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => const _SaveCatalogTemplateDialog(),
    );
    if (name == null || !mounted) return;

    final result = await context
        .read<CatalogTemplatesCubit>()
        .saveCurrentAsTemplate(name);
    if (!mounted) return;
    result.when(
      success: (_) => _showSnack('Saved "$name" as a template'),
      error: (error) =>
          _showSnack('Failed to save template: $error', isError: true),
    );
  }

  Future<void> _onRestore(CatalogTemplate template) async {
    final tokens = context.tokens;

    final replaceExisting = await AppDialog.show<bool>(
      context: context,
      dialog: AppDialog(
        title: 'Restore "${template.name}"',
        subtitle: 'Choose how to bring this template into your catalog.',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppButton.outline(
              label: 'Add to current catalog',
              onPressed: () => Navigator.of(context).pop(false),
              fullWidth: true,
            ),
            SizedBox(height: tokens.spaceSm),
            AppButton.primary(
              label: 'Replace current catalog',
              onPressed: () => Navigator.of(context).pop(true),
              fullWidth: true,
            ),
          ],
        ),
        actions: [
          AppButton.outline(
            label: 'Cancel',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
    if (replaceExisting == null || !mounted) return;

    if (replaceExisting) {
      final confirmed = await ConfirmationDialog.showDelete(
        context: context,
        title: 'Replace current catalog?',
        message:
            'Every category, product, modifier and combo currently in the '
            'catalog will be removed and replaced by "${template.name}". '
            'This cannot be undone.',
        confirmButtonLabel: 'Yes, Replace',
      );
      if (!confirmed || !mounted) return;
    }

    final result = await context.read<CatalogTemplatesCubit>().restoreTemplate(
      template.id,
      replaceExisting: replaceExisting,
    );
    if (!mounted) return;
    result.when(
      success: (_) => _showSnack('Restored "${template.name}"'),
      error: (error) =>
          _showSnack('Failed to restore template: $error', isError: true),
    );
  }

  Future<void> _onDelete(CatalogTemplate template) async {
    final confirmed = await ConfirmationDialog.showDelete(
      context: context,
      title: 'Delete template?',
      message:
          'Are you sure you want to delete "${template.name}"? This only '
          'removes the saved template — it never touches the current '
          'catalog.',
    );
    if (!confirmed || !mounted) return;

    final result = await context.read<CatalogTemplatesCubit>().deleteTemplate(
      template.id,
    );
    if (!mounted) return;
    result.when(
      success: (_) {},
      error: (error) =>
          _showSnack('Failed to delete template: $error', isError: true),
    );
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: AppText.body(
            message,
            color: isError
                ? context.colors.destructiveForeground
                : context.colors.primaryForeground,
          ),
          backgroundColor: isError
              ? context.colors.destructive
              : context.colors.primary,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(context.tokens.spaceLg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AppText.headingSm('Catalog Templates'),
                AppButton.primary(
                  onPressed: _onSaveAsTemplate,
                  label: 'Save Current as Template',
                  leadingIcon: const Icon(AgoraIcons.save, size: 20),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: BlocBuilder<CatalogTemplatesCubit, CatalogTemplatesState>(
              builder: (context, state) {
                return state.map(
                  loading: (_) =>
                      const Center(child: CircularProgressIndicator()),
                  loaded: (loaded) => _buildList(loaded.templates),
                  error: (error) => _buildErrorState(error.message),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<CatalogTemplate> templates) {
    if (templates.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: EdgeInsets.all(context.tokens.spaceLg),
      itemCount: templates.length,
      separatorBuilder: (context, index) => const SizedBox(height: Sizes.md),
      itemBuilder: (context, index) {
        final template = templates[index];
        return CatalogTemplateListItem(
          template: template,
          onRestore: () => _onRestore(template),
          onDelete: () => _onDelete(template),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(AgoraIcons.archive, size: 64, color: context.colors.border),
          const SizedBox(height: Sizes.md),
          AppText.titleMd(
            'No saved templates yet',
            color: context.colors.mutedForeground,
          ),
          const SizedBox(height: Sizes.sm),
          AppText.body(
            'Save the current catalog as a template before wiping it or '
            'starting a new season, so you can restore it in one tap.',
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
          const AppText.titleMd('Failed to load templates'),
          const SizedBox(height: Sizes.sm),
          AppText.body(message, color: context.colors.mutedForeground),
          const SizedBox(height: Sizes.lg),
          AppButton.primary(
            onPressed: () => context.read<CatalogTemplatesCubit>().load(),
            label: 'Retry',
          ),
        ],
      ),
    );
  }
}

/// Owns its controller so it remains valid throughout the dialog's exit
/// animation and is disposed only after the dialog widget is removed.
class _SaveCatalogTemplateDialog extends StatefulWidget {
  const _SaveCatalogTemplateDialog();

  @override
  State<_SaveCatalogTemplateDialog> createState() =>
      _SaveCatalogTemplateDialogState();
}

class _SaveCatalogTemplateDialogState
    extends State<_SaveCatalogTemplateDialog> {
  final _controller = TextEditingController();

  void _save() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) Navigator.of(context).pop(name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'Save current catalog as template',
      subtitle:
          'Categories, products, prices, modifiers and combos are saved. '
          'Stock levels are never part of a template.',
      content: AppTextField(
        controller: _controller,
        label: 'Template name',
        hintText: 'e.g. Sagra Estate 2026',
        autofocus: true,
        onSubmitted: (_) => _save(),
      ),
      actions: [
        AppButton.outline(
          label: 'Cancel',
          onPressed: () => Navigator.of(context).pop(),
        ),
        AppButton.primary(label: 'Save', onPressed: _save),
      ],
    );
  }
}
