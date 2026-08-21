import 'package:flutter/material.dart';
import 'package:ui_kit/src/atoms/app_button.dart';
import 'package:ui_kit/src/overlays/app_calendar_picker_support.dart';

/// Agora's compact, token-driven single-date picker.
abstract final class AppDatePicker {
  /// Opens the picker and returns a normalized date-only value when applied.
  static Future<DateTime?> show({
    required BuildContext context,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTime? initialDate,
    String title = 'Select date',
  }) {
    final normalizedFirstDate = DateUtils.dateOnly(firstDate);
    final normalizedLastDate = DateUtils.dateOnly(lastDate);
    final normalizedInitialDate = initialDate == null
        ? null
        : DateUtils.dateOnly(initialDate);

    assert(
      !normalizedLastDate.isBefore(normalizedFirstDate),
      'lastDate must follow firstDate',
    );
    assert(
      normalizedInitialDate == null ||
          !normalizedInitialDate.isBefore(normalizedFirstDate),
      'initialDate must be on or after firstDate',
    );
    assert(
      normalizedInitialDate == null ||
          !normalizedInitialDate.isAfter(normalizedLastDate),
      'initialDate must be on or before lastDate',
    );

    return showDialog<DateTime>(
      context: context,
      useRootNavigator: false,
      builder: (_) => _AppDatePickerDialog(
        firstDate: normalizedFirstDate,
        lastDate: normalizedLastDate,
        initialDate: normalizedInitialDate,
        title: title,
      ),
    );
  }
}

class _AppDatePickerDialog extends StatefulWidget {
  const _AppDatePickerDialog({
    required this.firstDate,
    required this.lastDate,
    required this.initialDate,
    required this.title,
  });

  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? initialDate;
  final String title;

  @override
  State<_AppDatePickerDialog> createState() => _AppDatePickerDialogState();
}

class _AppDatePickerDialogState extends State<_AppDatePickerDialog> {
  late List<DateTime?> _dates;

  @override
  void initState() {
    super.initState();
    _dates = [if (widget.initialDate != null) widget.initialDate];
  }

  DateTime? get _selectedDate => _dates.firstOrNull;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final selectedDate = _selectedDate;

    return AppCalendarPickerDialogLayout(
      surfaceKey: const ValueKey('app-date-picker-dialog'),
      title: widget.title,
      subtitle: selectedDate == null
          ? 'Choose a day'
          : localizations.formatMediumDate(selectedDate),
      content: AppCalendarPickerView.single(
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
        value: _dates,
        displayedMonthDate:
            widget.initialDate ??
            clampCalendarDate(
              DateTime.now(),
              widget.firstDate,
              widget.lastDate,
            ),
        onValueChanged: (dates) => setState(() => _dates = dates),
      ),
      actions: [
        AppButton.ghost(
          label: 'Cancel',
          onPressed: () => Navigator.of(context).pop(),
        ),
        AppButton.primary(
          label: 'Apply',
          onPressed: selectedDate == null
              ? null
              : () => Navigator.of(context).pop(selectedDate),
        ),
      ],
    );
  }
}
