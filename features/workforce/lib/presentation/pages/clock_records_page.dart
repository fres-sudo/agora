import 'package:auth_session/auth_session.dart';
import 'package:app_settings/app_settings.dart';
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
    // Variance gating reflects the *viewer's* role (whoever is looking at
    // this screen right now), not the role of the employee on each row —
    // see docs/features/04-volunteer-shift-accountability.md.
    final canViewVariance =
        context.watch<SessionCubit>().currentEmployee?.isManager ?? false;

    return Scaffold(
      appBar: AdaptiveAppBar.of(context, title: 'Clock Records'),
      body: BlocBuilder<ClockRecordsCubit, ClockRecordsState>(
        builder: (context, state) {
          return state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Center(child: AppText.body('Error: $message')),
            loaded: (records) => records.isEmpty
                ? const _EmptyState()
                : _RecordsList(
                    records: records,
                    canViewVariance: canViewVariance,
                  ),
          );
        },
      ),
    );
  }
}

class _RecordsList extends StatelessWidget {
  const _RecordsList({required this.records, required this.canViewVariance});
  final List<ClockRecord> records;
  final bool canViewVariance;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: records.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) =>
          _RecordTile(record: records[index], canViewVariance: canViewVariance),
    );
  }
}

class _RecordTile extends StatelessWidget {
  const _RecordTile({required this.record, required this.canViewVariance});
  final ClockRecord record;
  final bool canViewVariance;

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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!record.isActive) ...[
            _VarianceBadge(record: record, canViewVariance: canViewVariance),
            SizedBox(width: context.tokens.spacing.xs),
          ],
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.tokens.spacing.xs,
              vertical: context.tokens.spacing.xxs,
            ),
            decoration: BoxDecoration(
              color: record.isActive
                  ? colors.success.withValues(alpha: 0.12)
                  : colors.muted,
              borderRadius: context.tokens.radius.borderLg,
            ),
            child: AppText.label(record.formattedDuration, color: statusColor),
          ),
        ],
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

/// Three states, per docs/features/04-volunteer-shift-accountability.md:
/// no reconciliation row means the count was skipped (visible to everyone —
/// this is a shift-integrity signal, not the number); a reconciliation row
/// with the viewer not a manager shows only that it happened; a manager/
/// owner viewer sees the actual variance amount and its balanced/flagged
/// color.
class _VarianceBadge extends StatelessWidget {
  const _VarianceBadge({required this.record, required this.canViewVariance});
  final ClockRecord record;
  final bool canViewVariance;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final reconciliation = record.reconciliation;

    final (label, color, icon) = switch (reconciliation) {
      null => ('Unreconciled', colors.mutedForeground, null),
      _ when !canViewVariance => ('Reconciled', colors.mutedForeground, null),
      _ when reconciliation.isBalanced => (
        context.formatCurrency(reconciliation.varianceCents),
        colors.success,
        null,
      ),
      _ => (
        context.formatCurrency(reconciliation.varianceCents),
        colors.destructive,
        AgoraIcons.alert_circle,
      ),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.tokens.spacing.xs,
        vertical: context.tokens.spacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: context.tokens.radius.borderLg,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            SizedBox(width: context.tokens.spacing.xxs),
          ],
          AppText.label(label, color: color),
        ],
      ),
    );
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
          Icon(AgoraIcons.clock, size: 64, color: context.colors.border),
          SizedBox(height: context.tokens.spacing.md),
          AppText.titleMd(
            'No clock records yet',
            color: context.colors.mutedForeground,
          ),
        ],
      ),
    );
  }
}
