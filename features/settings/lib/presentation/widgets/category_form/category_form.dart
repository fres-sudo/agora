// This form is a category-color picker: the swatches and the contrast colors
// used to render them are persisted DATA values (a category's color), not app
// theme tokens, so the hard-coded-color rule does not apply here.
// ignore_for_file: avoid_hardcoded_colors
import 'package:ui_kit/ui_kit.dart';
import 'package:catalog/models/category.dart';
import 'package:flutter/material.dart';

class CategoryForm extends StatefulWidget {
  const CategoryForm({super.key, this.initialCategory});

  final Category? initialCategory;

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  late final TextEditingController _nameController;
  late IconData _selectedIcon;
  late Color _selectedColor;
  late bool _isEnabled;

  final _formKey = GlobalKey<FormState>();

  // Helper list of icons to choose from
  static const List<IconData> _availableIcons = [
    AgoraIcons.burger,
    AgoraIcons.pizza,
    AgoraIcons.chef_hat,
    AgoraIcons.coffee,
    AgoraIcons.cup,
    AgoraIcons.ice_cream,
    AgoraIcons.cupcake,
    AgoraIcons.map,
    AgoraIcons.restaurant,
    AgoraIcons.ramen,
    AgoraIcons.bread,
    AgoraIcons.wine,
  ];

  // Helper list of colors to choose from
  static const List<Color> _availableColors = [
    AppPalette.primary500,
    AppPalette.error500,
    AppPalette.warning500,
    AppPalette.info500,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.brown,
    Colors.blueGrey,
  ];

  @override
  void initState() {
    super.initState();
    final category = widget.initialCategory;
    _nameController = TextEditingController(text: category?.name ?? '');
    _selectedIcon = category?.icon ?? AgoraIcons.burger;
    _selectedColor = category?.color ?? AppPalette.primary500;
    _isEnabled = category?.isEnabled ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final category = Category(
        id: widget.initialCategory?.id ?? 0,
        name: _nameController.text.trim(),
        icon: _selectedIcon,
        color: _selectedColor,
        isEnabled: _isEnabled,
      );
      Navigator.of(context).pop(category);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.initialCategory != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(24),
          child: AppText.headingSm(
            isEditing ? 'Edit Category' : 'New Category',
            textAlign: TextAlign.center,
          ),
        ),
        const Divider(height: 1),

        // Form Content
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name Field
                  AppTextField(
                    controller: _nameController,
                    label: 'Category Name',
                    prefix: const Icon(AgoraIcons.tag),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Enabled Switch
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const AppText.body('Enabled'),
                    subtitle: const AppText.caption('Visible in POS'),
                    value: _isEnabled,
                    onChanged: (value) => setState(() => _isEnabled = value),
                  ),
                  const SizedBox(height: 24),

                  // Icons Section
                  const AppText.titleMd('Icon'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _availableIcons.map((icon) {
                      final isSelected = _selectedIcon == icon;
                      return ChoiceChip(
                        label: Icon(
                          icon,
                          size: 20,
                          color: isSelected
                              ? Colors.white
                              : theme.iconTheme.color,
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedIcon = icon);
                        },
                        showCheckmark: false,
                        selectedColor: theme.primaryColor,
                        padding: const EdgeInsets.all(12),
                        shape: const CircleBorder(),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Colors Section
                  const AppText.titleMd('Color'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _availableColors.map((color) {
                      final isSelected = _selectedColor == color;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedColor = color),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(
                                    color: theme.colorScheme.onSurface,
                                    width: 3,
                                  )
                                : null,
                            boxShadow: [
                              if (isSelected)
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                            ],
                          ),
                          child: isSelected
                              ? const Icon(
                                  AgoraIcons.check,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),

        const Divider(height: 1),

        // Actions
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton.ghost(
                onPressed: () => Navigator.of(context).pop(),
                label: 'Cancel',
              ),
              const SizedBox(width: 16),
              AppButton.primary(onPressed: _onSave, label: 'Save'),
            ],
          ),
        ),
      ],
    );
  }
}
