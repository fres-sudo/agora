import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/src/atoms/app_button.dart';
import 'package:ui_kit/src/atoms/app_text.dart';
import 'package:ui_kit/src/theme/agora_icons.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

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
    final colors = context.colors;
    final tokens = context.tokens;
    final typography = context.typography;

    final calendarConfig = CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.range,
      rangeBidirectional: true,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      firstDayOfWeek: MaterialLocalizations.of(context).firstDayOfWeekIndex,
      controlsHeight: 48,
      controlsTextStyle: typography.titleMd.copyWith(color: colors.foreground),
      centerAlignModePicker: true,
      disableMonthPicker: true,
      customModePickerIcon: Icon(
        AgoraIcons.chevron_down,
        size: tokens.iconSize.sm,
        color: colors.mutedForeground,
      ),
      lastMonthIcon: Icon(
        AgoraIcons.chevron_left,
        size: tokens.iconSize.md,
        color: colors.foreground,
      ),
      nextMonthIcon: Icon(
        AgoraIcons.chevron_right,
        size: tokens.iconSize.md,
        color: colors.foreground,
      ),
      weekdayLabelTextStyle: typography.caption.copyWith(
        color: colors.mutedForeground,
      ),
      dayTextStyle: typography.bodySm.copyWith(color: colors.foreground),
      todayTextStyle: typography.bodySm.copyWith(
        color: colors.foreground,
        fontWeight: FontWeight.w700,
        decoration: TextDecoration.underline,
        decorationColor: colors.ring,
      ),
      disabledDayTextStyle: typography.bodySm.copyWith(
        color: colors.mutedForeground.withValues(alpha: 0.5),
      ),
      selectedDayTextStyle: typography.bodySm.copyWith(
        color: colors.primaryForeground,
        fontWeight: FontWeight.w600,
      ),
      selectedRangeDayTextStyle: typography.bodySm.copyWith(
        color: colors.accentForeground,
      ),
      selectedDayHighlightColor: colors.primary,
      selectedRangeHighlightColor: colors.accent,
      daySplashColor: colors.ring.withValues(alpha: 0.16),
      dayBorderRadius: tokens.radius.borderSm,
      monthBorderRadius: tokens.radius.borderSm,
      yearBorderRadius: tokens.radius.borderSm,
      dayMaxWidth: 46,
      dynamicCalendarRows: false,
      semanticsDictionary: const {
        CalendarDatePicker2SemanticsLabel.selectMonth: 'Select month',
        CalendarDatePicker2SemanticsLabel.selectYear: 'Select year',
      },
    );

    return Dialog(
      backgroundColor: colors.popover,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      insetPadding: EdgeInsets.all(tokens.spacing.xs),
      shape: RoundedRectangleBorder(
        borderRadius: tokens.radius.borderLg,
        side: BorderSide(color: colors.border, width: tokens.border.hairline),
      ),
      child: ConstrainedBox(
        key: const ValueKey('app-date-range-picker-dialog'),
        constraints: const BoxConstraints(maxWidth: 390),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: tokens.spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppText.headingSm(widget.title),
                    SizedBox(height: tokens.spacing.xxs),
                    AppText.bodySm(
                      _selectionHint(context),
                      color: colors.mutedForeground,
                    ),
                  ],
                ),
              ),
              SizedBox(height: tokens.spacing.sm),
              CalendarDatePicker2(
                config: calendarConfig,
                value: _dates,
                displayedMonthDate:
                    widget.initialRange?.start ?? DateTime.now(),
                onValueChanged: (dates) => setState(() => _dates = dates),
              ),
              SizedBox(height: tokens.spacing.md),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton.ghost(
                      label: 'Cancel',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    SizedBox(width: tokens.spacing.sm),
                    AppButton.primary(
                      label: 'Apply',
                      onPressed: _hasRange ? _apply : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
