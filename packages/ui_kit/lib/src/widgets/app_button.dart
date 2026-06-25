import 'package:flutter/material.dart';

enum _ButtonVariant { primary, secondary, ghost, outline }

class AppButton extends StatelessWidget {
  const AppButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.onLongPress,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.fullWidth = false,
    this.autofocus = false,
    this.focusNode,
    this.style,
  }) : _variant = _ButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.onLongPress,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.fullWidth = false,
    this.autofocus = false,
    this.focusNode,
    this.style,
  }) : _variant = _ButtonVariant.secondary;

  const AppButton.ghost({
    super.key,
    required this.label,
    this.onPressed,
    this.onLongPress,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.fullWidth = false,
    this.autofocus = false,
    this.focusNode,
    this.style,
  }) : _variant = _ButtonVariant.ghost;

  const AppButton.outline({
    super.key,
    required this.label,
    this.onPressed,
    this.onLongPress,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.fullWidth = false,
    this.autofocus = false,
    this.focusNode,
    this.style,
  }) : _variant = _ButtonVariant.outline;

  final String label;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final bool isLoading;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool fullWidth;
  final bool autofocus;
  final FocusNode? focusNode;
  final ButtonStyle? style;
  final _ButtonVariant _variant;

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            _indicatorColor(context),
          ),
        ),
      );
    }

    if (leadingIcon == null && trailingIcon == null) {
      return Text(label);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leadingIcon != null) ...[
          leadingIcon!,
          const SizedBox(width: 8),
        ],
        Text(label),
        if (trailingIcon != null) ...[
          const SizedBox(width: 8),
          trailingIcon!,
        ],
      ],
    );
  }

  Color _indicatorColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (_variant) {
      _ButtonVariant.primary => colorScheme.onPrimary,
      _ButtonVariant.secondary => colorScheme.onSecondaryContainer,
      _ButtonVariant.ghost => colorScheme.primary,
      _ButtonVariant.outline => colorScheme.primary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;
    final effectiveOnLongPress = isLoading ? null : onLongPress;
    final content = _buildContent(context);

    final Widget button = switch (_variant) {
      _ButtonVariant.primary => FilledButton(
        onPressed: effectiveOnPressed,
        onLongPress: effectiveOnLongPress,
        autofocus: autofocus,
        focusNode: focusNode,
        style: style,
        child: content,
      ),
      _ButtonVariant.secondary => FilledButton.tonal(
        onPressed: effectiveOnPressed,
        onLongPress: effectiveOnLongPress,
        autofocus: autofocus,
        focusNode: focusNode,
        style: style,
        child: content,
      ),
      _ButtonVariant.ghost => TextButton(
        onPressed: effectiveOnPressed,
        onLongPress: effectiveOnLongPress,
        autofocus: autofocus,
        focusNode: focusNode,
        style: style,
        child: content,
      ),
      _ButtonVariant.outline => OutlinedButton(
        onPressed: effectiveOnPressed,
        onLongPress: effectiveOnLongPress,
        autofocus: autofocus,
        focusNode: focusNode,
        style: style,
        child: content,
      ),
    };

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
