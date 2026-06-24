import 'package:flutter/material.dart';

class QuantityButton extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  final int min;
  final int? max;

  const QuantityButton({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.min = 0,
    this.max,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: ShapeDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        shape: const StadiumBorder(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CircularButton(
              icon: Icons.remove,
              onPressed: quantity > min ? () => onChanged(quantity - 1) : null,
              enabled: quantity > min,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                quantity.toString(),
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _CircularButton(
              icon: Icons.add,
              onPressed: (max == null || quantity < max!) ? () => onChanged(quantity + 1) : null,
              enabled: max == null || quantity < max!,
            ),
          ],
        ),
      ),
    );
  }
}

class _CircularButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool enabled;

  const _CircularButton({
    required this.icon,
    this.onPressed,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? colorScheme.onSurface : colorScheme.onSurface.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
