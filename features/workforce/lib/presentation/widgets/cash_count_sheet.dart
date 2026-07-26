import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:ui_kit/ui_kit.dart';

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
  }) => AdaptiveModal.show<CashCountResult?>(
    context: context,
    style: AdaptiveModalStyle.sideSheet,
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
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(context.tokens.radius.lg),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.all(context.tokens.spacing.md),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.only(bottom: context.tokens.spacing.sm),
                    decoration: BoxDecoration(
                      color: context.colors.border,
                      borderRadius: context.tokens.radius.borderFull,
                    ),
                  ),
                ),
                const AppText.headingSm('Count the Drawer'),
                SizedBox(height: context.tokens.spacing.xs),
                AppText.body(
                  'Expected cash: ${context.formatCurrency(widget.expectedCents)}',
                  color: context.colors.mutedForeground,
                ),
                SizedBox(height: context.tokens.spacing.md),
                Center(
                  child: AppText.headingSm(
                    context.formatCurrency(_countedCents),
                  ),
                ),
                SizedBox(height: context.tokens.spacing.sm),
                MoneyKeypad(
                  valueCents: _countedCents,
                  onChanged: (value) => setState(() => _countedCents = value),
                ),
                SizedBox(height: context.tokens.spacing.sm),
                AppTextField(
                  controller: _noteController,
                  label: 'Note (optional)',
                ),
                SizedBox(height: context.tokens.spacing.md),
                Row(
                  children: [
                    Expanded(
                      child: AppButton.ghost(
                        label: 'Skip',
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    SizedBox(width: context.tokens.spacing.xs),
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
