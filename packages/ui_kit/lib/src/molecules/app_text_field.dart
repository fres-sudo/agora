import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_kit/src/atoms/app_text.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// A labelled text input bound to design tokens.
///
/// Composes an optional [label], the field itself, and an [errorText]/[helperText]
/// slot. The focus ring uses `context.colors.ring` and the error state uses
/// `context.colors.destructive` — all resolved per theme.
///
/// Accessibility: [label] is wired as the field's `label` semantics; when
/// [errorText] is set the field is marked as errored for assistive tech.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefix,
    this.suffix,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.autofocus = false,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final Widget? prefix;
  final Widget? suffix;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool autofocus;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;

  OutlineInputBorder _border(Color color, double width, BuildContext context) =>
      OutlineInputBorder(
        borderRadius: context.tokens.borderRadiusMd,
        borderSide: BorderSide(color: color, width: width),
      );

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tokens = context.tokens;
    final hasError = errorText != null;

    final field = TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      readOnly: readOnly,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      maxLines: obscureText ? 1 : maxLines,
      minLines: minLines,
      maxLength: maxLength,
      autofocus: autofocus,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      style: context.typography.body.copyWith(color: colors.foreground),
      cursorColor: colors.ring,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: enabled ? colors.background : colors.muted,
        hintText: hintText,
        hintStyle: context.typography.body.copyWith(
          color: colors.mutedForeground,
        ),
        prefixIcon: prefix,
        suffixIcon: suffix,
        contentPadding: EdgeInsets.symmetric(
          horizontal: tokens.spaceMd,
          vertical: tokens.spaceMd,
        ),
        counterText: '',
        enabledBorder: _border(colors.input, tokens.borderHairline, context),
        disabledBorder: _border(colors.border, tokens.borderHairline, context),
        focusedBorder: _border(colors.ring, tokens.borderThin, context),
        errorBorder: _border(colors.destructive, tokens.borderThin, context),
        focusedErrorBorder:
            _border(colors.destructive, tokens.borderThin, context),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          AppText.label(label!),
          SizedBox(height: tokens.spaceXs),
        ],
        Semantics(
          label: label,
          textField: true,
          child: field,
        ),
        if (hasError || helperText != null) ...[
          SizedBox(height: tokens.spaceXs),
          AppText.caption(
            errorText ?? helperText!,
            color: hasError ? colors.destructive : colors.mutedForeground,
          ),
        ],
      ],
    );
  }
}
