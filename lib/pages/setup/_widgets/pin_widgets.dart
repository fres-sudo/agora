import 'package:agora/ui/device.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PinDots extends StatelessWidget {
  final List<String> pin;

  const PinDots({super.key, required this.pin});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: Sizes.xxl * 2,
      children: List.generate(
        4,
        (index) => Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                pin[index].isNotEmpty
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}

class PinKeypad extends StatelessWidget {
  final void Function(String) onNumberPressed;
  final VoidCallback onDeletePressed;

  const PinKeypad({
    super.key,
    required this.onNumberPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        KeypadRow(numbers: ['1', '2', '3'], onNumberPressed: onNumberPressed),
        const SizedBox(height: 16),
        KeypadRow(numbers: ['4', '5', '6'], onNumberPressed: onNumberPressed),
        const SizedBox(height: 16),
        KeypadRow(numbers: ['7', '8', '9'], onNumberPressed: onNumberPressed),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 80),
            KeypadButton(number: '0', onPressed: onNumberPressed),
            DeleteButton(onPressed: onDeletePressed),
          ],
        ),
      ],
    );
  }
}

class KeypadRow extends StatelessWidget {
  final List<String> numbers;
  final void Function(String) onNumberPressed;

  const KeypadRow({
    super.key,
    required this.numbers,
    required this.onNumberPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          numbers
              .map(
                (number) =>
                    KeypadButton(number: number, onPressed: onNumberPressed),
              )
              .toList(),
    );
  }
}

class KeypadButton extends StatelessWidget {
  final String number;
  final void Function(String) onPressed;

  const KeypadButton({
    super.key,
    required this.number,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: ShadButton.outline(
        onPressed: () => onPressed(number),
        child: Text(number, style: ShadTheme.of(context).textTheme.h3),
      ),
    );
  }
}

class DeleteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DeleteButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: ShadButton.destructive(
        onPressed: onPressed,
        child: const Icon(LucideIcons.delete, size: 30),
      ),
    );
  }
}
