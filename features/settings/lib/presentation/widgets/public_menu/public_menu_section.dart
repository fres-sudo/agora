import 'dart:async';

import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_settings/domain/models/public_menu_models.dart';
import 'package:feature_settings/domain/services/public_menu_exporter.dart';
import 'package:feature_settings/presentation/blocs/public_menu_cubit.dart';
import 'package:feature_settings/presentation/widgets/settings_section_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:result/result.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Public menu publisher UI. It sends a fresh catalog snapshot only after the
/// host taps Preview, Publish, or Update — catalog edits alone never leave the
/// device.
class PublicMenuSection extends StatefulWidget {
  const PublicMenuSection({super.key});

  @override
  State<PublicMenuSection> createState() => _PublicMenuSectionState();
}

class _PublicMenuSectionState extends State<PublicMenuSection> {
  final _title = TextEditingController();
  final _subtitle = TextEditingController();
  final _disclaimer = TextEditingController();
  PublicMenuConfiguration? _configuration;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final cubit = context.read<PublicMenuCubit>();
    await cubit.load();
    if (cubit.state is PublicMenuReady) await cubit.refreshTemplates();
  }

  @override
  void dispose() {
    _title.dispose();
    _subtitle.dispose();
    _disclaimer.dispose();
    super.dispose();
  }

  void _setInitialValues(PublicMenuConfiguration configuration) {
    if (_initialized) return;
    _initialized = true;
    _configuration = configuration;
    _title.text = configuration.title;
    _subtitle.text = configuration.subtitle;
    _disclaimer.text = configuration.disclaimer;
  }

  PublicMenuConfiguration _currentConfiguration() {
    final base = _configuration ?? const PublicMenuConfiguration(title: '');
    return base.copyWith(
      title: _title.text,
      subtitle: _subtitle.text,
      disclaimer: _disclaimer.text,
    );
  }

  void _updateConfiguration(PublicMenuConfiguration configuration) {
    setState(() => _configuration = configuration);
  }

  Future<void> _save() async {
    final configuration = _currentConfiguration();
    final result = await context.read<PublicMenuCubit>().saveConfiguration(
      configuration,
    );
    if (!mounted) return;
    result.when(
      success: (_) {
        _updateConfiguration(configuration);
        AppToast.success(context, message: 'Public menu settings saved');
      },
      error: (error) => _showError(error),
    );
  }

  Future<void> _preview() async {
    final configuration = _currentConfiguration();
    final cubit = context.read<PublicMenuCubit>();
    final save = await cubit.saveConfiguration(configuration);
    if (save.isError || !mounted) {
      if (save is Error<void>) _showError(save.error);
      return;
    }
    _updateConfiguration(configuration);
    final result = await cubit.preview(configuration);
    if (!mounted) return;
    result.when(
      success: (url) => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => _MenuPreviewSheet(url: url),
      ),
      error: _showError,
    );
  }

  Future<void> _publish() async {
    final configuration = _currentConfiguration();
    final result = await context.read<PublicMenuCubit>().publish(configuration);
    if (!mounted) return;
    result.when(
      success: (_) {
        _updateConfiguration(configuration);
        AppToast.success(context, message: 'Public menu published');
      },
      error: _showError,
    );
  }

  Future<void> _unpublish() async {
    final confirmed = await ConfirmationDialog.showDelete(
      context: context,
      title: 'Unpublish public menu?',
      message:
          'Guests will no longer be able to open this menu from its QR code.',
      confirmButtonLabel: 'Unpublish',
    );
    if (!confirmed || !mounted) return;
    final result = await context.read<PublicMenuCubit>().unpublish();
    if (!mounted) return;
    result.when(
      success: (_) =>
          AppToast.success(context, message: 'Public menu unpublished'),
      error: _showError,
    );
  }

  void _showError(Exception error) =>
      AppToast.error(context, message: error.toString());

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PublicMenuCubit, PublicMenuState>(
      listener: (context, state) {
        if (state case PublicMenuFailure(:final message)) {
          AppToast.error(context, message: message);
        }
      },
      builder: (context, state) {
        return switch (state) {
          PublicMenuLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          PublicMenuFailure(:final previous) when previous == null =>
            _Unavailable(onRetry: _load),
          PublicMenuReady(:final data) ||
          PublicMenuFailure(
            previous: final data?,
          ) => _buildReady(data, state is PublicMenuReady && state.isWorking),
          _ => _Unavailable(onRetry: _load),
        };
      },
    );
  }

  Widget _buildReady(PublicMenuData data, bool isWorking) {
    _setInitialValues(data.configuration);
    final configuration = _currentConfiguration();
    final publication = data.publication;
    return SettingsSectionScaffold(
      title: 'Public Menu',
      actionButton: AppButton.primary(
        label: 'Save changes',
        isLoading: isWorking,
        onPressed: isWorking ? null : _save,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatusBanner(publication: publication, hasUpdate: data.hasUpdate),
          SizedBox(height: context.tokens.spacing.xl),
          AppText.titleMd('Menu details'),
          SizedBox(height: context.tokens.spacing.xs),
          AppText.body(
            'Only active products in enabled categories and enabled combos are published. '
            'Prices and items stay local until you publish or update.',
            color: context.colors.mutedForeground,
          ),
          SizedBox(height: context.tokens.spacing.lg),
          AppTextField(label: 'Public menu title', controller: _title),
          SizedBox(height: context.tokens.spacing.md),
          AppTextField(label: 'Subtitle (optional)', controller: _subtitle),
          SizedBox(height: context.tokens.spacing.md),
          AppTextField(
            label: 'Disclaimer (optional)',
            controller: _disclaimer,
            maxLines: 2,
            hintText: 'e.g. Allergens: ask our staff',
          ),
          SizedBox(height: context.tokens.spacing.xl),
          Row(
            children: [
              Expanded(child: AppText.titleMd('Choose a template')),
              AppButton.outline(
                label: 'Refresh',
                size: AppButtonSize.sm,
                onPressed: isWorking
                    ? null
                    : () async {
                        final result = await context
                            .read<PublicMenuCubit>()
                            .refreshTemplates();
                        if (!mounted || result.isSuccess) return;
                        if (result is Error<void>) _showError(result.error);
                      },
              ),
            ],
          ),
          SizedBox(height: context.tokens.spacing.md),
          if (data.templates.isEmpty)
            _NoTemplates(onRetry: _load)
          else
            _TemplateGallery(
              templates: data.templates,
              selectedId: configuration.templateId,
              onSelected: (template) => _updateConfiguration(
                configuration.copyWith(
                  templateId: template.id,
                  templateVersion: template.version,
                ),
              ),
            ),
          SizedBox(height: context.tokens.spacing.xl),
          AppText.titleMd('Presentation'),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const AppText.body('Show product descriptions'),
            value: configuration.showDescriptions,
            onChanged: (value) => _updateConfiguration(
              configuration.copyWith(showDescriptions: value),
            ),
          ),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const AppText.body('Show category icons'),
            value: configuration.showCategoryIcons,
            onChanged: (value) => _updateConfiguration(
              configuration.copyWith(showCategoryIcons: value),
            ),
          ),
          SizedBox(height: context.tokens.spacing.lg),
          Wrap(
            spacing: context.tokens.spacing.sm,
            runSpacing: context.tokens.spacing.sm,
            children: [
              AppButton.outline(
                label: 'Preview',
                leadingIcon: const Icon(AgoraIcons.eye),
                onPressed: isWorking ? null : _preview,
              ),
              AppButton.primary(
                label: publication == null
                    ? 'Publish & generate QR'
                    : 'Update menu',
                leadingIcon: const Icon(AgoraIcons.scan_qr_code),
                isLoading: isWorking,
                onPressed: isWorking ? null : _publish,
              ),
              if (publication != null)
                AppButton.destructive(
                  label: 'Unpublish',
                  onPressed: isWorking ? null : _unpublish,
                ),
            ],
          ),
          if (publication != null) ...[
            SizedBox(height: context.tokens.spacing.xl),
            _PublicationCard(publication: publication),
          ],
        ],
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.publication, required this.hasUpdate});

  final MenuPublication? publication;
  final bool hasUpdate;

  @override
  Widget build(BuildContext context) {
    final message = publication == null
        ? 'Unpublished — guests cannot see your catalog yet.'
        : hasUpdate
        ? 'Update available — your local catalog differs from the published menu.'
        : 'Published — the QR code points to your current published menu.';
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.muted,
        borderRadius: BorderRadius.circular(context.tokens.radius.md),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.tokens.spacing.md),
        child: Row(
          children: [
            Icon(
              publication == null ? AgoraIcons.cloud : AgoraIcons.scan_qr_code,
              color: context.colors.mutedForeground,
            ),
            SizedBox(width: context.tokens.spacing.sm),
            Expanded(child: AppText.body(message)),
          ],
        ),
      ),
    );
  }
}

class _TemplateGallery extends StatelessWidget {
  const _TemplateGallery({
    required this.templates,
    required this.selectedId,
    required this.onSelected,
  });

  final List<MenuTemplate> templates;
  final String? selectedId;
  final ValueChanged<MenuTemplate> onSelected;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: context.tokens.spacing.md,
    runSpacing: context.tokens.spacing.md,
    children: templates
        .map((template) {
          final selected = template.id == selectedId;
          return Semantics(
            selected: selected,
            button: true,
            label: template.name,
            child: InkWell(
              onTap: () => onSelected(template),
              borderRadius: BorderRadius.circular(context.tokens.radius.md),
              child: Container(
                width: 220,
                padding: EdgeInsets.all(context.tokens.spacing.md),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selected
                        ? context.colors.primary
                        : context.colors.border,
                    width: selected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(context.tokens.radius.md),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      AgoraIcons.file,
                      color: context.colors.mutedForeground,
                    ),
                    SizedBox(height: context.tokens.spacing.sm),
                    AppText.titleMd(template.name),
                    SizedBox(height: context.tokens.spacing.xxs),
                    AppText.bodySm(
                      template.description,
                      color: context.colors.mutedForeground,
                    ),
                  ],
                ),
              ),
            ),
          );
        })
        .toList(growable: false),
  );
}

class _PublicationCard extends StatelessWidget {
  const _PublicationCard({required this.publication});

  final MenuPublication publication;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(context.tokens.spacing.lg),
    decoration: BoxDecoration(
      border: Border.all(color: context.colors.border),
      borderRadius: BorderRadius.circular(context.tokens.radius.md),
    ),
    child: Wrap(
      spacing: context.tokens.spacing.xl,
      runSpacing: context.tokens.spacing.md,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        QrImageView(data: publication.publicUrl, size: 180),
        SizedBox(
          width: 380,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText.titleMd('Your public menu QR code'),
              SizedBox(height: context.tokens.spacing.xs),
              SelectableText(publication.publicUrl),
              SizedBox(height: context.tokens.spacing.md),
              AppButton.outline(
                label: 'Copy public link',
                leadingIcon: const Icon(AgoraIcons.copy),
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(text: publication.publicUrl),
                  );
                  if (context.mounted) {
                    AppToast.success(context, message: 'Public link copied');
                  }
                },
              ),
              SizedBox(height: context.tokens.spacing.sm),
              Wrap(
                spacing: context.tokens.spacing.sm,
                runSpacing: context.tokens.spacing.sm,
                children: [
                  AppButton.outline(
                    label: 'Share QR PNG',
                    leadingIcon: const Icon(AgoraIcons.share),
                    onPressed: () => _export(
                      context,
                      (exporter) => exporter.shareQrPng(publication),
                    ),
                  ),
                  AppButton.outline(
                    label: 'Share A4 poster',
                    leadingIcon: const Icon(AgoraIcons.file),
                    onPressed: () => _export(
                      context,
                      (exporter) => exporter.shareA4Poster(publication),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Future<void> _export(
    BuildContext context,
    Future<void> Function(PublicMenuExporter exporter) action,
  ) async {
    try {
      await action(const PublicMenuExporter());
    } on Exception catch (error) {
      if (context.mounted) AppToast.error(context, message: error.toString());
    }
  }
}

class _MenuPreviewSheet extends StatefulWidget {
  const _MenuPreviewSheet({required this.url});

  final String url;

  @override
  State<_MenuPreviewSheet> createState() => _MenuPreviewSheetState();
}

class _MenuPreviewSheetState extends State<_MenuPreviewSheet> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: SizedBox(
      height: MediaQuery.sizeOf(context).height * .9,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(context.tokens.spacing.md),
            child: Row(
              children: [
                const Expanded(child: AppText.headingSm('Menu preview')),
                AppIconButton.secondary(
                  tooltip: 'Close',
                  icon: const Icon(AgoraIcons.x_mark),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(child: WebViewWidget(controller: _controller)),
        ],
      ),
    ),
  );
}

class _NoTemplates extends StatelessWidget {
  const _NoTemplates({required this.onRetry});
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppText.body(
        'No templates are available yet. Connect to the internet and refresh.',
        color: context.colors.mutedForeground,
      ),
    ],
  );
}

class _Unavailable extends StatelessWidget {
  const _Unavailable({required this.onRetry});
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(AgoraIcons.cloud, size: 48),
        SizedBox(height: context.tokens.spacing.sm),
        const AppText.titleMd('Public menu is unavailable'),
        SizedBox(height: context.tokens.spacing.xs),
        AppButton.outline(label: 'Retry', onPressed: onRetry),
      ],
    ),
  );
}
