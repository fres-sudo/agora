import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:i18n/i18n.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ui_kit/ui_kit.dart';

/// A staged picker for a product visual.
///
/// Choices update the preview in place and are only returned after the user
/// taps Save. This keeps an exploratory tap on an icon or stock illustration
/// from unexpectedly replacing the product's existing visual.
class ProductPhotoPickerSheet extends StatefulWidget {
  const ProductPhotoPickerSheet({
    this.initialValue,
    this.scrollController,
    super.key,
  });

  final String? initialValue;
  final ScrollController? scrollController;

  @override
  State<ProductPhotoPickerSheet> createState() =>
      _ProductPhotoPickerSheetState();
}

class _ProductPhotoPickerSheetState extends State<ProductPhotoPickerSheet> {
  final _temporaryFiles = <String>{};
  bool _isUploading = false;
  late String? _selectedValue;
  late ProductIconType _selectedIconType;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
    _selectedIconType =
        resolveProductIconType(widget.initialValue) ?? ProductIconType.outline;
  }

  @override
  void dispose() {
    // Barrier dismissals and the system back action bypass the sheet's close
    // callback, so clean up staged files here as well.
    for (final path in _temporaryFiles) {
      unawaited(_deleteFile(path));
    }
    super.dispose();
  }

  Future<void> _pickFromDevice(ImageSource source) async {
    setState(() => _isUploading = true);
    try {
      final picked = await ImagePicker().pickImage(source: source);
      if (picked == null || !mounted) return;

      final documentsDir = await getApplicationDocumentsDirectory();
      final productImagesDir = Directory('${documentsDir.path}/product_images');
      await productImagesDir.create(recursive: true);

      final extension = _fileExtension(picked.path);
      final fileName = '${DateTime.now().microsecondsSinceEpoch}$extension';
      final savedPath = '${productImagesDir.path}/$fileName';
      await File(picked.path).copy(savedPath);

      if (!mounted) return;
      _temporaryFiles.add(savedPath);
      setState(() => _selectedValue = savedPath);
    } catch (_) {
      if (mounted) {
        AppToast.error(
          context,
          message: 'Unable to add this photo. Please try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  String _fileExtension(String path) {
    final fileName = path.split(Platform.pathSeparator).last;
    final dotIndex = fileName.lastIndexOf('.');
    return dotIndex > 0 ? fileName.substring(dotIndex) : '.jpg';
  }

  Future<void> _removePhoto() async {
    final selectedValue = _selectedValue;
    if (selectedValue != null && _temporaryFiles.remove(selectedValue)) {
      await _deleteFile(selectedValue);
    }
    if (mounted) setState(() => _selectedValue = null);
  }

  Future<void> _cancel() async {
    await _deleteTemporaryFiles();
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _save() async {
    await _deleteTemporaryFiles(except: _selectedValue);
    // The selected file is now owned by the product form, not this sheet.
    _temporaryFiles.clear();
    if (mounted) Navigator.of(context).pop(_selectedValue ?? '');
  }

  Future<void> _deleteTemporaryFiles({String? except}) async {
    final filesToDelete = _temporaryFiles
        .where((path) => path != except)
        .toList();
    _temporaryFiles.removeAll(filesToDelete);
    for (final path in filesToDelete) {
      await _deleteFile(path);
    }
  }

  Future<void> _deleteFile(String path) async {
    try {
      await File(path).delete();
    } on FileSystemException {
      // A failed cleanup must not block the user from closing the picker.
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final hasSelection = _selectedValue != null && _selectedValue!.isNotEmpty;

    return AppSheetScaffold(
      title: t.products.form.photo.title,
      scrollController: widget.scrollController,
      onClose: _cancel,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: AppSourcedImage(
                key: ValueKey(_selectedValue),
                source: _selectedValue,
                size: 112,
                borderRadius: context.tokens.radius.borderLg,
              ),
            ),
          ),
          SizedBox(height: context.tokens.spacing.lg),
          AppText.label(t.products.form.photo.upload_section),
          SizedBox(height: context.tokens.spacing.xs),
          AppButton.primary(
            label: t.products.form.photo.choose_from_gallery,
            fullWidth: true,
            isLoading: _isUploading,
            leadingIcon: const Icon(AgoraIcons.gallery),
            onPressed: _isUploading
                ? null
                : () => _pickFromDevice(ImageSource.gallery),
          ),
          SizedBox(height: context.tokens.spacing.xs),
          AppButton.outline(
            label: t.products.form.photo.take_photo,
            fullWidth: true,
            isLoading: _isUploading,
            leadingIcon: const Icon(AgoraIcons.camera),
            onPressed: _isUploading
                ? null
                : () => _pickFromDevice(ImageSource.camera),
          ),
          SizedBox(height: context.tokens.spacing.lg),
          AppText.label(t.products.form.photo.stock_gallery_section),
          SizedBox(height: context.tokens.spacing.xs),
          _VisualGrid(
            children: [
              for (final stock in kProductStockGallery)
                _VisualTile(
                  label: stock.label,
                  isSelected:
                      _selectedValue == '$kProductStockImagePrefix${stock.id}',
                  onTap: () => setState(
                    () =>
                        _selectedValue = '$kProductStockImagePrefix${stock.id}',
                  ),
                  child: AppSourcedImage(
                    source: '$kProductStockImagePrefix${stock.id}',
                    size: 42,
                    placeholderIcon: AgoraIcons.gallery,
                  ),
                ),
            ],
          ),
          SizedBox(height: context.tokens.spacing.lg),
          const AppText.label('Or choose an Agora icon'),
          SizedBox(height: context.tokens.spacing.xs),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: AppSegmentedControl<ProductIconType>(
              selected: _selectedIconType,
              onChanged: (type) => setState(() => _selectedIconType = type),
              segments: [
                for (final type in ProductIconType.values)
                  AppSegment(value: type, label: type.label),
              ],
            ),
          ),
          SizedBox(height: context.tokens.spacing.xs),
          _VisualGrid(
            children: [
              for (final icon in kProductIconGallery)
                _VisualTile(
                  label: '${icon.label} ${_selectedIconType.label}',
                  isSelected:
                      _selectedValue ==
                      encodeProductIcon(icon, _selectedIconType),
                  onTap: () => setState(
                    () => _selectedValue = encodeProductIcon(
                      icon,
                      _selectedIconType,
                    ),
                  ),
                  child: Icon(
                    icon.iconFor(_selectedIconType),
                    size: 30,
                    color: context.colors.foreground,
                  ),
                ),
            ],
          ),
        ],
      ),
      actions: [
        if (hasSelection)
          AppButton.ghost(
            label: t.products.form.photo.remove_photo,
            leadingIcon: const Icon(AgoraIcons.trash),
            onPressed: _removePhoto,
          ),
        AppButton.primary(
          label: t.save,
          onPressed: _isUploading ? null : _save,
        ),
      ],
    );
  }
}

class _VisualGrid extends StatelessWidget {
  const _VisualGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: context.tokens.spacing.xs,
      runSpacing: context.tokens.spacing.xs,
      children: children,
    );
  }
}

class _VisualTile extends StatelessWidget {
  const _VisualTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.child,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: Material(
        color: Colors.transparent,
        borderRadius: context.tokens.radius.borderMd,
        child: InkWell(
          onTap: onTap,
          borderRadius: context.tokens.radius.borderMd,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.colors.muted,
              borderRadius: context.tokens.radius.borderMd,
              border: Border.all(
                color: isSelected
                    ? context.colors.primary
                    : context.colors.border,
                width: isSelected ? 2 : context.tokens.border.hairline,
              ),
            ),
            child: ExcludeSemantics(child: child),
          ),
        ),
      ),
    );
  }
}
