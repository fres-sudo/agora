import 'package:flutter/material.dart';

/// A scaffold widget for settings sections.
///
/// Provides a consistent layout with a header (title + action button)
/// and scrollable content area.
class SettingsSectionScaffold extends StatelessWidget {
  const SettingsSectionScaffold({
    super.key,
    required this.title,
    required this.child,
    this.actionButton,
  });

  /// The title displayed in the header.
  final String title;

  /// The content of the section.
  final Widget child;

  /// Optional action button displayed in the header.
  /// Defaults to a "Save Changes" button if not provided.
  final Widget? actionButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actionButton ??
                    FilledButton(
                      onPressed: () {},
                      child: const Text('Save Changes'),
                    ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
