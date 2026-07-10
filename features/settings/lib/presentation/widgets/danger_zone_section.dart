import 'package:app_reset/app_reset.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_settings/presentation/widgets/settings_section_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// Destructive actions. Currently a full "Reset app & data" that wipes the
/// local database, clears the business profile + session, and returns the app
/// to onboarding. Guarded by an explicit confirmation dialog.
class DangerZoneSection extends StatelessWidget {
  const DangerZoneSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSectionScaffold(
      title: 'Reset',
      actionButton: const SizedBox.shrink(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.titleMd('Reset app & data'),
          const SizedBox(height: 8),
          AppText.body(
            'This permanently deletes all products, orders, inventory, staff and '
            'settings on this device, and starts the setup wizard again. This '
            'cannot be undone.',
            color: context.colors.mutedForeground,
          ),
          const SizedBox(height: 24),
          AppButton.destructive(
            label: 'Reset everything',
            leadingIcon: const Icon(AgoraIcons.trash),
            onPressed: () => _confirm(context),
          ),
        ],
      ),
    );
  }

  Future<void> _confirm(BuildContext context) async {
    final resetService = context.read<AppResetService>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AppDialog(
        title: 'Reset everything?',
        content: AppText.body(
          'All data on this device will be erased and you will be taken back to '
          'setup. This cannot be undone.',
        ),
        actions: [
          AppButton.outline(
            label: 'Cancel',
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
          AppButton.destructive(
            label: 'Reset',
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await resetService.resetEverything();
    }
  }
}
