import 'package:agora/core/ui/theme.dart';
import 'package:agora/products/models/category/category.dart';
import 'package:flutter/material.dart';

class CategoryForm extends StatefulWidget {
  const CategoryForm({
    super.key,
    this.initialCategory,
  });

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
    Icons.fastfood,
    Icons.local_pizza,
    Icons.lunch_dining,
    Icons.local_cafe,
    Icons.local_bar,
    Icons.icecream,
    Icons.cake,
    Icons.restaurant,
    Icons.local_dining,
    Icons.ramen_dining,
    Icons.bakery_dining,
    Icons.liquor,
  ];

  // Helper list of colors to choose from
  static const List<Color> _availableColors = [
    AppColors.primary500,
    AppColors.error500,
    AppColors.warning500,
    AppColors.info500,
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
    _selectedIcon = category?.icon ?? Icons.fastfood;
    _selectedColor = category?.color ?? AppColors.primary500;
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
          child: Text(
            isEditing ? 'Edit Category' : 'New Category',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
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
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Category Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.label_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 24),

                  // Enabled Switch
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Enabled'),
                    subtitle: const Text('Visible in POS'),
                    value: _isEnabled,
                    onChanged: (value) => setState(() => _isEnabled = value),
                  ),
                  const SizedBox(height: 24),

                  // Icons Section
                  Text(
                    'Icon',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                          color: isSelected ? Colors.white : theme.iconTheme.color,
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
                  Text(
                    'Color',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                            ],
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, color: Colors.white)
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
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 16),
              FilledButton(
                onPressed: _onSave,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
