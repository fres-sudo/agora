import 'package:flutter/material.dart';
import 'package:ui_kit/src/molecules/app_text_field.dart';

import 'package:ui_kit/src/theme/context_extensions.dart';

import 'package:ui_kit/src/theme/agora_icons.dart';

/// A search input: an [AppTextField] preset with a search icon and clear affordance.
///
/// TODO(design-system): add debounce and recent-search suggestions.
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    this.controller,
    this.hintText = 'Search',
    this.onChanged,
    this.onClear,
    this.focusNode,
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppTextField(
      controller: controller,
      focusNode: focusNode,
      hintText: hintText,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      prefix: Icon(
        AgoraIcons
            .eye, // TODO(agora-icons): placeholder — no AgoraIcons match for Icons.search_rounded
        color: colors.mutedForeground,
        size: context.tokens.iconMd,
      ),
      suffix: onClear == null
          ? null
          : IconButton(
              tooltip: 'Clear search',
              icon: Icon(AgoraIcons.x, color: colors.mutedForeground),
              onPressed: onClear,
            ),
    );
  }
}
