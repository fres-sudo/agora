import 'package:bloc_exports/bloc_exports.dart';

part 'clock_record.freezed.dart';

@freezed
abstract class ClockRecord with _$ClockRecord {
  const factory ClockRecord({
    required int id,
    required int employeeId,
    required String employeeName,
    required DateTime clockedInAt,
    DateTime? clockedOutAt,
    String? note,
  }) = _ClockRecord;

  const ClockRecord._();

  bool get isActive => clockedOutAt == null;

  Duration? get duration => clockedOutAt?.difference(clockedInAt);

  String get formattedDuration {
    final d = duration;
    if (d == null) return 'Active';
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }
}
