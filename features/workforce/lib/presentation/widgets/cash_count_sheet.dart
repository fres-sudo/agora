import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:utils/utils.dart';

/// What the volunteer entered when counting the drawer at clock-out.
class CashCountResult {
  const CashCountResult({required this.countedCents, this.note});

  final int countedCents;
  final String? note;
}

/// Skippable cash-count step shown at clock-out
/// (docs/features/04-volunteer-shift-accountability.md). Resolves to a
/// [CashCountResult] on "Confirm Count", or `null` on "Skip" / barrier
/// dismiss — both treated identically by the caller: the count was skipped,
/// clock-out proceeds regardless.
class CashCountSheet extends StatefulWidget {
  const CashCountSheet({super.key, required this.expectedCents});

  final int expectedCents;

  static Future<CashCountResult?> show(
    BuildContext context, {
    required int expectedCents,
  }) => AdaptiveSheet.show<CashCountResult?>(
    context: context,
    builder: (ctx, scrollController) =>
        CashCountSheet(expectedCents: expectedCents),
  );

  @override
  State<CashCountSheet> createState() => _CashCountSheetState();
}

class _CashCountSheetState extends State<CashCountSheet> {
  int _countedCents = 0;
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(Sizes.lg)),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.lg),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: Sizes.md),
                    decoration: BoxDecoration(
                      color: context.colors.border,
                      borderRadius: context.tokens.borderRadiusFull,
                    ),
                  ),
                ),
                const AppText.headingSm('Count the Drawer'),
                const SizedBox(height: Sizes.sm),
                AppText.body(
                  'Expected cash: ${formatCents(widget.expectedCents)}',
                  color: context.colors.mutedForeground,
                ),
                const SizedBox(height: Sizes.lg),
                Center(
                  child: AppText.headingSm(formatCents(_countedCents)),
                ),
                const SizedBox(height: Sizes.md),
                MoneyKeypad(
                  valueCents: _countedCents,
                  onChanged: (value) => setState(() => _countedCents = value),
                ),
                const SizedBox(height: Sizes.md),
                AppTextField(
                  controller: _noteController,
                  label: 'Note (optional)',
                ),
                const SizedBox(height: Sizes.lg),
                Row(
                  children: [
                    Expanded(
                      child: AppButton.ghost(
                        label: 'Skip',
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: Sizes.sm),
                    Expanded(
                      child: AppButton.primary(
                        label: 'Confirm Count',
                        onPressed: () => Navigator.of(context).pop(
                          CashCountResult(
                            countedCents: _countedCents,
                            note: _noteController.text.trim().isEmpty
                                ? null
                                : _noteController.text.trim(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
