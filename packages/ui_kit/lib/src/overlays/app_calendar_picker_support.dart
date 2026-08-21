import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/src/atoms/app_text.dart';
import 'package:ui_kit/src/theme/agora_icons.dart';
import 'package:ui_kit/src/theme/context_extensions.dart';

/// Internal calendar shared by the public date picker facades.
///
/// This file is intentionally not exported from `ui_kit.dart`, keeping the
/// third-party calendar dependency out of the package's public API.
class AppCalendarPickerView extends StatelessWidget {
  const AppCalendarPickerView.single({
    super.key,
    required this.firstDate,
    required this.lastDate,
    required this.value,
    required this.displayedMonthDate,
    required this.onValueChanged,
  }) : _isRange = false;

  const AppCalendarPickerView.range({
    super.key,
    required this.firstDate,
    required this.lastDate,
    required this.value,
    required this.displayedMonthDate,
    required this.onValueChanged,
  }) : _isRange = true;

  final DateTime firstDate;
  final DateTime lastDate;
  final List<DateTime?> value;
  final DateTime displayedMonthDate;
  final ValueChanged<List<DateTime>> onValueChanged;
  final bool _isRange;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tokens = context.tokens;
    final typography = context.typography;

    final config = CalendarDatePicker2Config(
      calendarType: _isRange
          ? CalendarDatePicker2Type.range
          : CalendarDatePicker2Type.single,
      rangeBidirectional: _isRange,
      firstDate: firstDate,
      lastDate: lastDate,
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

    // The calendar grid has seven fixed columns. Match Flutter's own date
    // picker strategy by capping text growth inside that spatially constrained
    // region; the dialog title, selection summary, and actions remain fully
    // scalable.
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.6,
      child: CalendarDatePicker2(
        config: config,
        value: value,
        displayedMonthDate: clampCalendarDate(
          displayedMonthDate,
          firstDate,
          lastDate,
        ),
        onValueChanged: onValueChanged,
      ),
    );
  }
}

/// Shared compact dialog chrome for the calendar picker family.
class AppCalendarPickerDialogLayout extends StatelessWidget {
  const AppCalendarPickerDialogLayout({
    super.key,
    required this.surfaceKey,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.actions,
  });

  final Key surfaceKey;
  final String title;
  final String subtitle;
  final Widget content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tokens = context.tokens;

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
        key: surfaceKey,
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
                    AppText.headingSm(title),
                    SizedBox(height: tokens.spacing.xxs),
                    AppText.bodySm(subtitle, color: colors.mutedForeground),
                  ],
                ),
              ),
              SizedBox(height: tokens.spacing.sm),
              content,
              SizedBox(height: tokens.spacing.md),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spacing.lg),
                child: OverflowBar(
                  alignment: MainAxisAlignment.end,
                  overflowAlignment: OverflowBarAlignment.end,
                  spacing: tokens.spacing.sm,
                  overflowSpacing: tokens.spacing.sm,
                  children: actions,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

DateTime clampCalendarDate(
  DateTime date,
  DateTime firstDate,
  DateTime lastDate,
) {
  final normalized = DateUtils.dateOnly(date);
  if (normalized.isBefore(firstDate)) return firstDate;
  if (normalized.isAfter(lastDate)) return lastDate;
  return normalized;
}
