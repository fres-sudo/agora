import 'dart:async';
import 'package:agora/core/ui/theme.dart';
import 'package:flutter/material.dart';

/// A search bar widget for searching products in the POS view.
/// Includes debouncing to avoid excessive search calls.
class PosSearchBar extends StatefulWidget {
  /// Callback when search query changes (debounced).
  final ValueChanged<String> onSearch;

  /// Placeholder text in the search field.
  final String? hintText;

  /// Debounce duration for search. Defaults to 300ms.
  final Duration debounceDuration;

  const PosSearchBar({
    super.key,
    required this.onSearch,
    this.hintText,
    this.debounceDuration = const Duration(milliseconds: 300),
  });

  @override
  State<PosSearchBar> createState() => _PosSearchBarState();
}

class _PosSearchBarState extends State<PosSearchBar> {
  final _controller = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounceDuration, () {
      widget.onSearch(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onChanged,
      decoration: InputDecoration(
        hintText: widget.hintText ?? 'Search Product...',
        hintStyle: TextStyle(color: AppColors.neutral400),
        prefixIcon: Icon(
          Icons.search,
          color: AppColors.neutral400,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.neutral200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.neutral200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary500, width: 2),
        ),
      ),
    );
  }
}
