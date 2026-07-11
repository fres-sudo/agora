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
    this.prefixText,
    this.suffix,
    this.suffixText,
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
    this.validator,
    this.autovalidateMode,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final Widget? prefix;

  /// Inline text shown before the input (e.g. a currency symbol).
  final String? prefixText;
  final Widget? suffix;

  /// Inline text shown after the input (e.g. a unit like `%`).
  final String? suffixText;
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

  /// When provided, the field participates in an enclosing [Form] and shows the
  /// returned message. Use this instead of a raw `TextFormField`.
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;

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

    final field = TextFormField(
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
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      validator: validator,
      autovalidateMode: autovalidateMode,
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
        prefixText: prefixText,
        prefixStyle: context.typography.body.copyWith(color: colors.foreground),
        suffixIcon: suffix,
        suffixText: suffixText,
        suffixStyle: context.typography.body.copyWith(color: colors.foreground),
        contentPadding: EdgeInsets.symmetric(
          horizontal: tokens.spaceSm,
          vertical: tokens.spaceXs,
        ),
        counterText: '',
        enabledBorder: _border(colors.input, tokens.borderHairline, context),
        disabledBorder: _border(colors.border, tokens.borderHairline, context),
        focusedBorder: _border(colors.ring, tokens.borderThin, context),
        errorBorder: _border(colors.destructive, tokens.borderThin, context),
        focusedErrorBorder: _border(
          colors.destructive,
          tokens.borderThin,
          context,
        ),
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
        Semantics(label: label, textField: true, child: field),
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
