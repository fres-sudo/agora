import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/services.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:catalog/models/modifier_group.dart';
import 'package:catalog/models/modifier_option.dart';

/// Create/edit form for a [ModifierGroup] and its nested [ModifierOption]s.
///
/// Unlike [CategoryForm], this form manages a parent (the group: name +
/// single/multi-select) plus an editable list of children (the options: name
/// + price change). The repository only persists group-level fields via
/// `updateModifier` — option add/edit/remove must go through separate
/// `ModifiersEvent.optionCreated/optionUpdated/optionDeleted` events. To keep
/// this form simple, it always returns the *full* desired [ModifierGroup]
/// (including options with `id == 0` for new ones); the caller is
/// responsible for diffing against the original group and dispatching the
/// right granular events (see `ModifierSection._onEditModifier`).
class ModifierForm extends StatefulWidget {
  const ModifierForm({super.key, this.initialGroup, this.scrollController});

  /// Scroll controller supplied by [AdaptiveModal] when this form is shown as
  /// a phone bottom sheet. Attaching it is what lets a drag on the fields move
  /// the sheet itself; null in the dialog presentation.
  final ScrollController? scrollController;

  final ModifierGroup? initialGroup;

  @override
  State<ModifierForm> createState() => _ModifierFormState();
}

class _ModifierFormState extends State<ModifierForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late bool _isMultiSelect;
  late List<_OptionDraft> _options;
  String? _optionsError;

  @override
  void initState() {
    super.initState();
    final group = widget.initialGroup;
    _nameController = TextEditingController(text: group?.name ?? '');
    _isMultiSelect = group?.isMultiSelect ?? false;
    _options = (group?.options ?? const <ModifierOption>[])
        .map(_OptionDraft.fromOption)
        .toList();
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (final option in _options) {
      option.dispose();
    }
    super.dispose();
  }

  void _addOption() {
    setState(() => _options.add(_OptionDraft.blank()));
  }

  void _removeOption(_OptionDraft option) {
    setState(() {
      _options.remove(option);
      option.dispose();
    });
  }

  void _onSave() {
    final isNameValid = _formKey.currentState?.validate() ?? false;
    final options = _options
        .where((o) => o.nameController.text.trim().isNotEmpty)
        .toList();

    setState(() {
      _optionsError = options.isEmpty ? 'Add at least one option' : null;
    });

    if (!isNameValid || options.isEmpty) return;

    final group = ModifierGroup(
      id: widget.initialGroup?.id ?? 0,
      name: _nameController.text.trim(),
      isMultiSelect: _isMultiSelect,
      options: options.map((o) => o.toOption()).toList(),
    );
    Navigator.of(context).pop(group);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isEditing = widget.initialGroup != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.all(context.tokens.spacing.lg),
          child: AppText.headingSm(
            isEditing ? 'Edit Modifier' : 'New Modifier',
            textAlign: TextAlign.center,
          ),
        ),
        const Divider(height: 1),

        // Form Content
        Flexible(
          child: SingleChildScrollView(
            controller: widget.scrollController,
            padding: EdgeInsets.all(context.tokens.spacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name Field
                  AppTextField(
                    controller: _nameController,
                    label: 'Modifier Name',
                    hintText: 'e.g. Size, Milk Option',
                    prefix: const Icon(AgoraIcons.tag),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: context.tokens.spacing.lg),

                  // Single vs multi select
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const AppText.body('Allow multiple selections'),
                    subtitle: const AppText.caption(
                      'On: customers can pick several options (checkboxes). '
                      'Off: customers pick exactly one (radio buttons).',
                    ),
                    value: _isMultiSelect,
                    onChanged: (value) =>
                        setState(() => _isMultiSelect = value),
                  ),
                  SizedBox(height: context.tokens.spacing.lg),

                  // Options section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppText.titleMd('Options'),
                      AppButton.ghost(
                        onPressed: _addOption,
                        label: 'Add Option',
                        leadingIcon: const Icon(AgoraIcons.plus, size: 18),
                      ),
                    ],
                  ),
                  SizedBox(height: context.tokens.spacing.sm),

                  if (_options.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(context.tokens.spacing.md),
                      decoration: BoxDecoration(
                        color: colors.muted,
                        borderRadius: BorderRadius.circular(
                          context.tokens.radius.sm,
                        ),
                        border: Border.all(color: colors.border),
                      ),
                      child: AppText.bodySm(
                        'No options yet. Add at least one, '
                        'e.g. "Small" / "Large".',
                        color: colors.mutedForeground,
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    ..._options.map(
                      (option) => Padding(
                        key: option.localKey,
                        padding: EdgeInsets.only(
                          bottom: context.tokens.spacing.xs,
                        ),
                        child: _OptionRow(
                          option: option,
                          onRemove: () => _removeOption(option),
                        ),
                      ),
                    ),

                  if (_optionsError != null) ...[
                    SizedBox(height: context.tokens.spacing.xs),
                    AppText.bodySm(_optionsError!, color: colors.destructive),
                  ],
                ],
              ),
            ),
          ),
        ),

        const Divider(height: 1),

        // Actions
        Padding(
          padding: EdgeInsets.all(context.tokens.spacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton.ghost(
                onPressed: () => Navigator.of(context).pop(),
                label: 'Cancel',
              ),
              SizedBox(width: context.tokens.spacing.md),
              AppButton.primary(onPressed: _onSave, label: 'Save'),
            ],
          ),
        ),
      ],
    );
  }
}

/// Mutable, controller-backed draft of a [ModifierOption] being edited.
///
/// Keeping stable [TextEditingController]s per row (rather than recreating
/// them on every build, as `ingredients_step.dart` does) avoids losing focus
/// / cursor position while typing.
class _OptionDraft {
  _OptionDraft._({
    required this.id,
    required this.localKey,
    required this.nameController,
    required this.priceController,
  });

  factory _OptionDraft.fromOption(ModifierOption option) => _OptionDraft._(
    id: option.id,
    localKey: ValueKey('modifier_option_${option.id}'),
    nameController: TextEditingController(text: option.name),
    priceController: TextEditingController(
      text: option.priceChangeCents == 0
          ? ''
          : (option.priceChangeCents / 100).toStringAsFixed(2),
    ),
  );

  factory _OptionDraft.blank() => _OptionDraft._(
    id: 0,
    localKey: UniqueKey(),
    nameController: TextEditingController(),
    priceController: TextEditingController(),
  );

  /// The persisted option id, or `0` if this row is a new, unsaved option.
  final int id;
  final Key localKey;
  final TextEditingController nameController;
  final TextEditingController priceController;

  ModifierOption toOption() {
    final parsedPrice = double.tryParse(priceController.text) ?? 0;
    return ModifierOption(
      id: id,
      name: nameController.text.trim(),
      priceChangeCents: (parsedPrice * 100).round(),
    );
  }

  void dispose() {
    nameController.dispose();
    priceController.dispose();
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({required this.option, required this.onRemove});

  final _OptionDraft option;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: AppTextField(
            controller: option.nameController,
            hintText: 'Option name',
          ),
        ),
        SizedBox(width: context.tokens.spacing.xs),
        Expanded(
          flex: 2,
          child: AppTextField(
            controller: option.priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            prefixText: '+${context.currencySymbol} ',
            hintText: '0.00',
          ),
        ),
        AppIconButton.ghost(
          onPressed: onRemove,
          icon: Icon(
            AgoraIcons.x_mark,
            size: 18,
            color: context.colors.mutedForeground,
          ),
          tooltip: 'Remove option',
        ),
      ],
    );
  }
}
