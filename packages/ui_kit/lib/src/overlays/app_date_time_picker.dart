import 'package:flutter/material.dart';
import 'package:ui_kit/src/atoms/app_button.dart';
import 'package:ui_kit/src/atoms/app_text.dart';
import 'package:ui_kit/src/overlays/app_calendar_picker_support.dart';
import 'package:ui_kit/src/overlays/app_select.dart';
import 'package:ui_kit/src/theme/agora_icons.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// Agora's compact date-and-time picker.
abstract final class AppDateTimePicker {
  /// Opens a combined calendar and time picker.
  ///
  /// [firstDate] and [lastDate] constrain calendar days. The time follows the
  /// user's 12/24-hour preference and minutes use [minuteInterval]. If the
  /// initial minute is between intervals, it is rounded down to the nearest
  /// available value.
  static Future<DateTime?> show({
    required BuildContext context,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTime? initialDateTime,
    int minuteInterval = 1,
    String title = 'Select date and time',
  }) {
    final normalizedFirstDate = DateUtils.dateOnly(firstDate);
    final normalizedLastDate = DateUtils.dateOnly(lastDate);
    final normalizedInitialDate = initialDateTime == null
        ? null
        : DateUtils.dateOnly(initialDateTime);

    if (minuteInterval < 1 || minuteInterval > 30 || 60 % minuteInterval != 0) {
      throw ArgumentError.value(
        minuteInterval,
        'minuteInterval',
        'must divide evenly into 60 and be between 1 and 30',
      );
    }

    assert(
      !normalizedLastDate.isBefore(normalizedFirstDate),
      'lastDate must follow firstDate',
    );
    assert(
      normalizedInitialDate == null ||
          !normalizedInitialDate.isBefore(normalizedFirstDate),
      'initialDateTime must be on or after firstDate',
    );
    assert(
      normalizedInitialDate == null ||
          !normalizedInitialDate.isAfter(normalizedLastDate),
      'initialDateTime must be on or before lastDate',
    );
    return showDialog<DateTime>(
      context: context,
      useRootNavigator: false,
      builder: (_) => _AppDateTimePickerDialog(
        firstDate: normalizedFirstDate,
        lastDate: normalizedLastDate,
        initialDateTime: initialDateTime,
        minuteInterval: minuteInterval,
        title: title,
      ),
    );
  }
}

class _AppDateTimePickerDialog extends StatefulWidget {
  const _AppDateTimePickerDialog({
    required this.firstDate,
    required this.lastDate,
    required this.initialDateTime,
    required this.minuteInterval,
    required this.title,
  });

  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? initialDateTime;
  final int minuteInterval;
  final String title;

  @override
  State<_AppDateTimePickerDialog> createState() =>
      _AppDateTimePickerDialogState();
}

class _AppDateTimePickerDialogState extends State<_AppDateTimePickerDialog> {
  late List<DateTime?> _dates;
  late int _hour;
  late int _minute;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialDateTime ?? DateTime.now();
    _dates = [clampCalendarDate(initial, widget.firstDate, widget.lastDate)];
    _hour = initial.hour;
    _minute = (initial.minute ~/ widget.minuteInterval) * widget.minuteInterval;
  }

  DateTime get _selectedDate => _dates.first!;

  DateTime get _selectedDateTime => DateTime(
    _selectedDate.year,
    _selectedDate.month,
    _selectedDate.day,
    _hour,
    _minute,
  );

  String _selectionSummary(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final time = localizations.formatTimeOfDay(
      TimeOfDay(hour: _hour, minute: _minute),
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );
    return '${localizations.formatMediumDate(_selectedDate)} · $time';
  }

  @override
  Widget build(BuildContext context) {
    return AppCalendarPickerDialogLayout(
      surfaceKey: const ValueKey('app-date-time-picker-dialog'),
      title: widget.title,
      subtitle: _selectionSummary(context),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppCalendarPickerView.single(
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            value: _dates,
            displayedMonthDate: _selectedDate,
            onValueChanged: (dates) => setState(() => _dates = dates),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.tokens.spacing.lg,
            ),
            child: Divider(color: context.colors.border, height: 1),
          ),
          SizedBox(height: context.tokens.spacing.md),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.tokens.spacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      AgoraIcons.clock,
                      size: context.tokens.iconSize.sm,
                      color: context.colors.mutedForeground,
                    ),
                    SizedBox(width: context.tokens.spacing.xs),
                    const AppText.titleMd('Time'),
                  ],
                ),
                SizedBox(height: context.tokens.spacing.sm),
                _TimeFields(
                  hour: _hour,
                  minute: _minute,
                  minuteInterval: widget.minuteInterval,
                  onHourChanged: (hour) => setState(() => _hour = hour),
                  onMinuteChanged: (minute) => setState(() => _minute = minute),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        AppButton.ghost(
          label: 'Cancel',
          onPressed: () => Navigator.of(context).pop(),
        ),
        AppButton.primary(
          label: 'Apply',
          onPressed: () => Navigator.of(context).pop(_selectedDateTime),
        ),
      ],
    );
  }
}

class _TimeFields extends StatelessWidget {
  const _TimeFields({
    required this.hour,
    required this.minute,
    required this.minuteInterval,
    required this.onHourChanged,
    required this.onMinuteChanged,
  });

  final int hour;
  final int minute;
  final int minuteInterval;
  final ValueChanged<int> onHourChanged;
  final ValueChanged<int> onMinuteChanged;

  @override
  Widget build(BuildContext context) {
    final use24HourFormat = MediaQuery.alwaysUse24HourFormatOf(context);
    final period = hour < 12 ? DayPeriod.am : DayPeriod.pm;
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: AppSelect<int>(
            key: const ValueKey('app-date-time-hour'),
            label: 'Hour',
            value: use24HourFormat ? hour : displayHour,
            items: [
              for (
                var value = use24HourFormat ? 0 : 1;
                value <= (use24HourFormat ? 23 : 12);
                value++
              )
                AppSelectItem(
                  value: value,
                  label: use24HourFormat
                      ? value.toString().padLeft(2, '0')
                      : value.toString(),
                ),
            ],
            onChanged: (value) {
              if (value == null) return;
              if (use24HourFormat) {
                onHourChanged(value);
              } else {
                onHourChanged((value % 12) + (period == DayPeriod.pm ? 12 : 0));
              }
            },
          ),
        ),
        SizedBox(width: context.tokens.spacing.xs),
        Expanded(
          child: AppSelect<int>(
            key: const ValueKey('app-date-time-minute'),
            label: 'Minute',
            value: minute,
            items: [
              for (var value = 0; value < 60; value += minuteInterval)
                AppSelectItem(
                  value: value,
                  label: value.toString().padLeft(2, '0'),
                ),
            ],
            onChanged: (value) {
              if (value != null) onMinuteChanged(value);
            },
          ),
        ),
        if (!use24HourFormat) ...[
          SizedBox(width: context.tokens.spacing.xs),
          Expanded(
            child: AppSelect<DayPeriod>(
              key: const ValueKey('app-date-time-period'),
              label: 'Period',
              value: period,
              items: const [
                AppSelectItem(value: DayPeriod.am, label: 'AM'),
                AppSelectItem(value: DayPeriod.pm, label: 'PM'),
              ],
              onChanged: (value) {
                if (value == null || value == period) return;
                onHourChanged(value == DayPeriod.pm ? hour + 12 : hour - 12);
              },
            ),
          ),
        ],
      ],
    );
  }
}
