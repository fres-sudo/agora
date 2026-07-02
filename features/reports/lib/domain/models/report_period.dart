/// Selectable reporting window for the end-of-day / sales report.
///
/// Each period resolves to a concrete `[start, end]` [DateTime] range against
/// which orders are aggregated. Ranges are inclusive of the current moment.
enum ReportPeriod {
  today('Today'),
  week('This Week'),
  month('This Month'),
  all('All Time');

  const ReportPeriod(this.label);

  /// Human-readable label shown in the period selector.
  final String label;

  /// Resolves this period into a concrete date range ending "now".
  ///
  /// [now] is injectable for testing; it defaults to [DateTime.now].
  DateTimeRangeValue range({DateTime? now}) {
    final current = now ?? DateTime.now();
    final endOfDay = DateTime(
      current.year,
      current.month,
      current.day,
      23,
      59,
      59,
      999,
    );

    switch (this) {
      case ReportPeriod.today:
        final start = DateTime(current.year, current.month, current.day);
        return DateTimeRangeValue(start: start, end: endOfDay);
      case ReportPeriod.week:
        // Monday as the start of the week.
        final startOfToday = DateTime(
          current.year,
          current.month,
          current.day,
        );
        final start = startOfToday.subtract(
          Duration(days: current.weekday - 1),
        );
        return DateTimeRangeValue(start: start, end: endOfDay);
      case ReportPeriod.month:
        final start = DateTime(current.year, current.month, 1);
        return DateTimeRangeValue(start: start, end: endOfDay);
      case ReportPeriod.all:
        return DateTimeRangeValue(
          start: DateTime.fromMillisecondsSinceEpoch(0),
          end: endOfDay,
        );
    }
  }
}

/// A simple inclusive date range value object (avoids a Flutter-widget
/// `DateTimeRange` dependency in the domain layer).
class DateTimeRangeValue {
  const DateTimeRangeValue({required this.start, required this.end});

  final DateTime start;
  final DateTime end;
}
