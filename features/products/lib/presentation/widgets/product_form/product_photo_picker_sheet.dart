import 'dart:io';

import 'package:i18n/i18n.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

/// Sheet content for choosing a product visual: an Agora icon or a photo
/// uploaded from the device.
///
/// Pops one of three things via [Navigator.pop]:
/// - `null` — cancelled, no change
/// - `''` (empty string) — the user explicitly removed the current photo
/// - a non-empty `String` — the new `imageUrl` value (`"icon:<type>:<code>"`
///   or a local file path)
class ProductPhotoPickerSheet extends StatefulWidget {
  const ProductPhotoPickerSheet({this.initialValue, super.key});

  final String? initialValue;

  @override
  State<ProductPhotoPickerSheet> createState() =>
      _ProductPhotoPickerSheetState();
}

class _ProductPhotoPickerSheetState extends State<ProductPhotoPickerSheet> {
  bool _isUploading = false;
  ProductIconType _selectedIconType = ProductIconType.outline;

  @override
  void initState() {
    super.initState();
    _selectedIconType =
        resolveProductIconType(widget.initialValue) ?? ProductIconType.outline;
  }

  Future<void> _pickFromDevice(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked == null || !mounted) return;

    setState(() => _isUploading = true);
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      final productImagesDir = Directory('${documentsDir.path}/product_images');
      await productImagesDir.create(recursive: true);

      final extension = picked.path.split('.').last;
      final fileName = '${DateTime.now().microsecondsSinceEpoch}.$extension';
      final savedPath = '${productImagesDir.path}/$fileName';
      await File(picked.path).copy(savedPath);

      if (mounted) Navigator.of(context).pop(savedPath);
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final hasCurrentValue =
        widget.initialValue != null && widget.initialValue!.isNotEmpty;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.titleMd(t.products.form.photo.title),
                AppIconButton.ghost(
                  icon: const Icon(AgoraIcons.x_mark),
                  tooltip: t.products.form.photo.close,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: Sizes.lg),

            AppText.label(t.products.form.photo.upload_section),
            const SizedBox(height: Sizes.sm),
            Row(
              children: [
                Expanded(
                  child: AppButton.outline(
                    label: t.products.form.photo.take_photo,
                    leadingIcon: const Icon(AgoraIcons.camera),
                    isLoading: _isUploading,
                    onPressed: _isUploading
                        ? null
                        : () => _pickFromDevice(ImageSource.camera),
                  ),
                ),
                const SizedBox(width: Sizes.sm),
                Expanded(
                  child: AppButton.outline(
                    label: t.products.form.photo.choose_from_gallery,
                    leadingIcon: const Icon(AgoraIcons.gallery),
                    isLoading: _isUploading,
                    onPressed: _isUploading
                        ? null
                        : () => _pickFromDevice(ImageSource.gallery),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Sizes.lg),

            const AppText.label('Or choose an Agora icon'),
            const SizedBox(height: Sizes.sm),
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
            const SizedBox(height: Sizes.sm),
            Wrap(
              spacing: Sizes.sm,
              runSpacing: Sizes.sm,
              children: kProductIconGallery.map((icon) {
                final value = encodeProductIcon(icon, _selectedIconType);
                final isSelected = widget.initialValue == value;
                return _IconTile(
                  icon: icon,
                  type: _selectedIconType,
                  isSelected: isSelected,
                  onTap: () => Navigator.of(context).pop(value),
                );
              }).toList(),
            ),

            if (hasCurrentValue) ...[
              const SizedBox(height: Sizes.lg),
              AppButton.ghost(
                label: t.products.form.photo.remove_photo,
                leadingIcon: const Icon(AgoraIcons.trash),
                onPressed: () => Navigator.of(context).pop(''),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({
    required this.icon,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  final ProductIcon icon;
  final ProductIconType type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: '${icon.label} ${type.label}',
      child: InkWell(
        onTap: onTap,
        borderRadius: context.tokens.borderRadiusMd,
        child: Container(
          width: 64,
          height: 64,
          padding: const EdgeInsets.all(Sizes.sm),
          decoration: BoxDecoration(
            color: context.colors.muted,
            borderRadius: context.tokens.borderRadiusMd,
            border: Border.all(
              color: isSelected
                  ? context.colors.primary
                  : context.colors.border,
              width: isSelected ? 2 : context.tokens.borderHairline,
            ),
          ),
          child: Icon(
            icon.iconFor(type),
            size: 32,
            color: context.colors.foreground,
          ),
        ),
      ),
    );
  }
}
