import 'package:auto_route/auto_route.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_workforce/domain/models/clock_record.dart';
import 'package:feature_workforce/domain/repositories/workforce_repository.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class ClockRecordsPage extends StatelessWidget {
  const ClockRecordsPage({super.key, this.employeeId});

  final int? employeeId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const AppShellMenuButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: StreamBuilder<List<ClockRecord>>(
        stream: context.read<WorkforceRepository>().watchClockRecords(
          employeeId: employeeId,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: AppText.body('Error: ${snapshot.error}'));
          }
          final records = snapshot.data ?? [];
          if (records.isEmpty) {
            return const _EmptyState();
          }
          return _RecordsList(records: records);
        },
      ),
    );
  }
}

class _RecordsList extends StatelessWidget {
  const _RecordsList({required this.records});
  final List<ClockRecord> records;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: records.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) => _RecordTile(record: records[index]),
    );
  }
}

class _RecordTile extends StatelessWidget {
  const _RecordTile({required this.record});
  final ClockRecord record;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final timeIn = _formatTime(record.clockedInAt);
    final timeOut = record.clockedOutAt != null
        ? _formatTime(record.clockedOutAt!)
        : null;
    final statusColor = record.isActive
        ? colors.success
        : colors.mutedForeground;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: record.isActive
            ? colors.success.withValues(alpha: 0.12)
            : colors.muted,
        child: Icon(
          record.isActive
              ? AgoraIcons.openTab
              : AgoraIcons
                    .logout, // TODO(agora-icons): placeholder — no AgoraIcons match for Icons.login
          color: statusColor,
          size: 20,
        ),
      ),
      title: AppText.body(record.employeeName),
      subtitle: AppText.bodySm(
        '$timeIn${timeOut != null ? ' → $timeOut' : ''}',
        color: colors.mutedForeground,
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: record.isActive
              ? colors.success.withValues(alpha: 0.12)
              : colors.muted,
          borderRadius: BorderRadius.circular(12),
        ),
        child: AppText.label(record.formattedDuration, color: statusColor),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'AM' : 'PM';
    final day = '${dt.month}/${dt.day}/${dt.year.toString().substring(2)}';
    return '$day $h:$m $period';
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(AgoraIcons.clock, size: 64, color: AppPalette.neutral300),
          const SizedBox(height: 16),
          AppText.titleMd(
            'No clock records yet',
            color: context.colors.mutedForeground,
          ),
        ],
      ),
    );
  }
}
