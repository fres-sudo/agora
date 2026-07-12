import 'package:auto_route/auto_route.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:feature_workforce/domain/models/clock_record.dart';
import 'package:feature_workforce/presentation/blocs/clock_records/clock_records_cubit.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

@RoutePage()
class ClockRecordsPage extends StatefulWidget {
  const ClockRecordsPage({super.key, this.employeeId});

  final int? employeeId;

  @override
  State<ClockRecordsPage> createState() => _ClockRecordsPageState();
}

class _ClockRecordsPageState extends State<ClockRecordsPage> {
  @override
  void initState() {
    super.initState();
    // Subscribed once here (rather than in `build`) so unrelated rebuilds of
    // this page don't tear down and recreate the underlying stream -- which
    // previously reset the screen back to a loading state on every rebuild.
    context.read<ClockRecordsCubit>().watch(employeeId: widget.employeeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const AppShellMenuButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: BlocBuilder<ClockRecordsCubit, ClockRecordsState>(
        builder: (context, state) {
          return state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Center(child: AppText.body('Error: $message')),
            loaded: (records) => records.isEmpty
                ? const _EmptyState()
                : _RecordsList(records: records),
          );
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
          record.isActive ? AgoraIcons.login : AgoraIcons.logout,
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
        padding: EdgeInsets.symmetric(
          horizontal: context.tokens.spaceXs,
          vertical: context.tokens.spaceXxs,
        ),
        decoration: BoxDecoration(
          color: record.isActive
              ? colors.success.withValues(alpha: 0.12)
              : colors.muted,
          borderRadius: context.tokens.borderRadiusLg,
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
          SizedBox(height: context.tokens.spaceMd),
          AppText.titleMd(
            'No clock records yet',
            color: context.colors.mutedForeground,
          ),
        ],
      ),
    );
  }
}
