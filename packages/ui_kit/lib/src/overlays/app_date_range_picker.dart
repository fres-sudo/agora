import 'package:flutter/material.dart';
import 'package:ui_kit/src/atoms/app_button.dart';
import 'package:ui_kit/src/overlays/app_calendar_picker_support.dart';

/// Agora's compact, token-driven date range picker.
///
/// The implementation dependency stays private to `ui_kit`; consumers only
/// exchange Flutter's [DateTimeRange].
abstract final class AppDateRangePicker {
  /// Opens a compact dialog and returns the range confirmed by the user.
  ///
  /// Dismissing or cancelling the dialog returns `null`. Dates are normalized
  /// to date-only values before being returned.
  static Future<DateTimeRange?> show({
    required BuildContext context,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTimeRange? initialRange,
    String title = 'Select date range',
  }) {
    final normalizedFirstDate = DateUtils.dateOnly(firstDate);
    final normalizedLastDate = DateUtils.dateOnly(lastDate);
    final normalizedInitialStart = initialRange == null
        ? null
        : DateUtils.dateOnly(initialRange.start);
    final normalizedInitialEnd = initialRange == null
        ? null
        : DateUtils.dateOnly(initialRange.end);

    assert(
      !normalizedLastDate.isBefore(normalizedFirstDate),
      'lastDate must follow firstDate',
    );
    assert(
      normalizedInitialStart == null ||
          !normalizedInitialStart.isBefore(normalizedFirstDate),
      'initialRange must start on or after firstDate',
    );
    assert(
      normalizedInitialEnd == null ||
          !normalizedInitialEnd.isAfter(normalizedLastDate),
      'initialRange must end on or before lastDate',
    );

    return showDialog<DateTimeRange>(
      context: context,
      useRootNavigator: false,
      builder: (_) => _AppDateRangePickerDialog(
        firstDate: normalizedFirstDate,
        lastDate: normalizedLastDate,
        initialRange: initialRange,
        title: title,
      ),
    );
  }
}

class _AppDateRangePickerDialog extends StatefulWidget {
  const _AppDateRangePickerDialog({
    required this.firstDate,
    required this.lastDate,
    required this.initialRange,
    required this.title,
  });

  final DateTime firstDate;
  final DateTime lastDate;
  final DateTimeRange? initialRange;
  final String title;

  @override
  State<_AppDateRangePickerDialog> createState() =>
      _AppDateRangePickerDialogState();
}

class _AppDateRangePickerDialogState extends State<_AppDateRangePickerDialog> {
  late List<DateTime?> _dates;

  @override
  void initState() {
    super.initState();
    _dates = [
      if (widget.initialRange != null) ...[
        DateUtils.dateOnly(widget.initialRange!.start),
        DateUtils.dateOnly(widget.initialRange!.end),
      ],
    ];
  }

  bool get _hasRange =>
      _dates.length == 2 && _dates.every((date) => date != null);

  String _selectionHint(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    if (_dates.isEmpty) return 'Choose the first day';
    if (!_hasRange) {
      return '${localizations.formatMediumDate(_dates.first!)} — choose the last day';
    }
    return '${localizations.formatMediumDate(_dates[0]!)} — '
        '${localizations.formatMediumDate(_dates[1]!)}';
  }

  void _apply() {
    if (!_hasRange) return;
    Navigator.of(
      context,
    ).pop(DateTimeRange(start: _dates[0]!, end: _dates[1]!));
  }

  @override
  Widget build(BuildContext context) {
    return AppCalendarPickerDialogLayout(
      surfaceKey: const ValueKey('app-date-range-picker-dialog'),
      title: widget.title,
      subtitle: _selectionHint(context),
      content: AppCalendarPickerView.range(
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
        value: _dates,
        displayedMonthDate: widget.initialRange?.start ?? DateTime.now(),
        onValueChanged: (dates) => setState(() => _dates = dates),
      ),
      actions: [
        AppButton.ghost(
          label: 'Cancel',
          onPressed: () => Navigator.of(context).pop(),
        ),
        AppButton.primary(label: 'Apply', onPressed: _hasRange ? _apply : null),
      ],
    );
  }
}
