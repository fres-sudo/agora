import 'package:flutter/material.dart';

class AppShellNavItem {
  const AppShellNavItem({
    required this.icon,
    required this.label,
    this.isEnabled = true,
  });

  final IconData icon;
  final String label;
  final bool isEnabled;
}
