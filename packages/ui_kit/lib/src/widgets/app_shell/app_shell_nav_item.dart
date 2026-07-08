import 'package:flutter/material.dart';

class AppShellNavItem {
  const AppShellNavItem({
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.isEnabled = true,
  });

  final IconData icon;

  /// Icon shown when this item is the active tab. Falls back to [icon] when
  /// unset — pass the filled/solid variant of [icon] to get a regular/filled
  /// active-state swap.
  final IconData? selectedIcon;
  final String label;
  final bool isEnabled;
}
