import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_kit/ui_kit.dart';

/// A numeric keypad for entering a monetary amount in **cents**.
///
/// The keypad treats typed digits as the low-order digits of a cents value
/// (calculator style): typing `1`, `2`, `3`, `4` yields `1234` cents (€12,34).
/// It is currency-agnostic and reports changes via [onChanged] as an integer
/// number of cents. The amount display is the caller's responsibility, so the
/// widget stays decoupled from any specific money formatter.
class MoneyKeypad extends StatelessWidget {
  const MoneyKeypad({
    super.key,
    required this.valueCents,
    required this.onChanged,
    this.maxCents = 99999999, // €999,999.99 ceiling to avoid overflow
  });

  /// The current amount, in cents.
  final int valueCents;

  /// Called with the new amount (in cents) whenever a key is pressed.
  final ValueChanged<int> onChanged;

  /// Upper bound for the entered amount.
  final int maxCents;

  void _onDigit(int digit) {
    final next = valueCents * 10 + digit;
    if (next > maxCents) return;
    HapticFeedback.selectionClick();
    onChanged(next);
  }

  void _onDoubleZero() {
    final next = valueCents * 100;
    if (next > maxCents) return;
    HapticFeedback.selectionClick();
    onChanged(next);
  }

  void _onBackspace() {
    HapticFeedback.selectionClick();
    onChanged(valueCents ~/ 10);
  }

  void _onClear() {
    HapticFeedback.selectionClick();
    onChanged(0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _row(context, [
          _KeyData.digit(1),
          _KeyData.digit(2),
          _KeyData.digit(3),
        ]),
        _row(context, [
          _KeyData.digit(4),
          _KeyData.digit(5),
          _KeyData.digit(6),
        ]),
        _row(context, [
          _KeyData.digit(7),
          _KeyData.digit(8),
          _KeyData.digit(9),
        ]),
        _row(context, [
          _KeyData(label: '00', onTap: _onDoubleZero),
          _KeyData.digit(0),
          _KeyData(
            icon: AgoraIcons.eraser,
            onTap: _onBackspace,
            onLongPress: _onClear,
          ),
        ]),
      ],
    );
  }

  Widget _row(BuildContext context, List<_KeyData> keys) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.xs),
      child: Row(
        children: [
          for (final key in keys)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.xs),
                child: _KeypadButton(data: key, onDigit: _onDigit),
              ),
            ),
        ],
      ),
    );
  }
}

class _KeyData {
  const _KeyData({
    this.label,
    this.icon,
    this.digit,
    this.onTap,
    this.onLongPress,
  });

  factory _KeyData.digit(int digit) => _KeyData(label: '$digit', digit: digit);

  final String? label;
  final IconData? icon;
  final int? digit;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
}

class _KeypadButton extends StatelessWidget {
  const _KeypadButton({required this.data, required this.onDigit});

  final _KeyData data;
  final ValueChanged<int> onDigit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () {
          if (data.digit != null) {
            onDigit(data.digit!);
          } else {
            data.onTap?.call();
          }
        },
        onLongPress: data.onLongPress,
        child: SizedBox(
          height: 56,
          child: Center(
            child: data.icon != null
                ? Icon(data.icon, size: 24, color: colorScheme.onSurface)
                : Text(
                    data.label ?? '',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
