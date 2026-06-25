import 'package:flutter/material.dart';

enum _ButtonVariant { primary, secondary, ghost, outline }

class AppIconButton extends StatelessWidget {
  const AppIconButton.primary({
    super.key,
    required this.icon,
    this.onPressed,
    this.onLongPress,
    this.isLoading = false,
    this.tooltip,
    this.autofocus = false,
    this.focusNode,
    this.style,
  }) : _variant = _ButtonVariant.primary;

  const AppIconButton.secondary({
    super.key,
    required this.icon,
    this.onPressed,
    this.onLongPress,
    this.isLoading = false,
    this.tooltip,
    this.autofocus = false,
    this.focusNode,
    this.style,
  }) : _variant = _ButtonVariant.secondary;

  const AppIconButton.ghost({
    super.key,
    required this.icon,
    this.onPressed,
    this.onLongPress,
    this.isLoading = false,
    this.tooltip,
    this.autofocus = false,
    this.focusNode,
    this.style,
  }) : _variant = _ButtonVariant.ghost;

  const AppIconButton.outline({
    super.key,
    required this.icon,
    this.onPressed,
    this.onLongPress,
    this.isLoading = false,
    this.tooltip,
    this.autofocus = false,
    this.focusNode,
    this.style,
  }) : _variant = _ButtonVariant.outline;

  final Widget icon;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final bool isLoading;
  final String? tooltip;
  final bool autofocus;
  final FocusNode? focusNode;
  final ButtonStyle? style;
  final _ButtonVariant _variant;

  Widget _buildIcon(BuildContext context) {
    if (!isLoading) return icon;

    final colorScheme = Theme.of(context).colorScheme;
    final color = switch (_variant) {
      _ButtonVariant.primary => colorScheme.onPrimary,
      _ButtonVariant.secondary => colorScheme.onSecondaryContainer,
      _ButtonVariant.ghost => colorScheme.primary,
      _ButtonVariant.outline => colorScheme.primary,
    };

    return SizedBox(
      width: 16,
      height: 16,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isLoading ? null : onPressed;
    final effectiveOnLongPress = isLoading ? null : onLongPress;
    final effectiveIcon = _buildIcon(context);

    return switch (_variant) {
      _ButtonVariant.primary => IconButton.filled(
        onPressed: effectiveOnPressed,
        onLongPress: effectiveOnLongPress,
        icon: effectiveIcon,
        tooltip: tooltip,
        autofocus: autofocus,
        focusNode: focusNode,
        style: style,
      ),
      _ButtonVariant.secondary => IconButton.filledTonal(
        onPressed: effectiveOnPressed,
        onLongPress: effectiveOnLongPress,
        icon: effectiveIcon,
        tooltip: tooltip,
        autofocus: autofocus,
        focusNode: focusNode,
        style: style,
      ),
      _ButtonVariant.ghost => IconButton(
        onPressed: effectiveOnPressed,
        onLongPress: effectiveOnLongPress,
        icon: effectiveIcon,
        tooltip: tooltip,
        autofocus: autofocus,
        focusNode: focusNode,
        style: style,
      ),
      _ButtonVariant.outline => IconButton.outlined(
        onPressed: effectiveOnPressed,
        onLongPress: effectiveOnLongPress,
        icon: effectiveIcon,
        tooltip: tooltip,
        autofocus: autofocus,
        focusNode: focusNode,
        style: style,
      ),
    };
  }
}
