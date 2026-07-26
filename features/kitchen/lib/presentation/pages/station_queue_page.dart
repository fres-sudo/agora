import 'package:app_settings/blocs/settings_cubit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:flutter/material.dart';
import 'package:kitchen/kitchen.dart';
import 'package:ui_kit/ui_kit.dart';

/// This device's configured prep station, a plain app setting (not a login
/// or role) — see docs/features/02-kitchen-ticket-routing.md, "a station is
/// just a device-local setting". Set from Settings > Printer
/// (`feature_settings`'s `PrinterSection`, which mirrors this key as a
/// literal rather than importing it — `features ↛ features`).
const String kitchenStationDeviceSettingKey = 'kitchen_station_device';

/// The live ticket queue for this device's configured station: tap a ticket
/// to advance it pending → in progress → ready → bumped, matching
/// `ClockInCubit`'s simple state machine (docs/features/02-kitchen-ticket-routing.md).
@RoutePage()
class StationQueuePage extends StatelessWidget {
  const StationQueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    final station = context.watch<SettingsCubit>().getString(
      kitchenStationDeviceSettingKey,
    );

    if (station == null || station.isEmpty) {
      return const Scaffold(
        body: AppEmptyState(
          title: 'No station configured',
          message:
              'Set this device\'s prep station in Settings to see its ticket queue.',
          icon: Icons.storefront_outlined,
        ),
      );
    }

    return BlocProvider(
      create: (ctx) =>
          TicketsBloc(ticketsRepository: ctx.read())
            ..add(TicketsEvent.started(station: station)),
      child: _StationQueueView(station: station),
    );
  }
}

class _StationQueueView extends StatelessWidget {
  const _StationQueueView({required this.station});

  final String station;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: AppText.titleMd(station)),
      body: EffectBlocConsumer<TicketsBloc, TicketsState, TicketsEffect>(
        listener: (context, state) {},
        onEffect: (context, effect) {
          if (effect is TicketsShowError) {
            AppToast.error(context, message: effect.message);
          }
        },
        builder: (context, state) {
          final tickets = state.tickets;
          if (tickets.isEmpty) {
            return const AppEmptyState(
              title: 'No open tickets',
              message: 'New tickets will appear here as orders come in.',
              icon: Icons.receipt_long_outlined,
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(context.tokens.spacing.lg),
            itemCount: tickets.length,
            separatorBuilder: (_, _) =>
                SizedBox(height: context.tokens.spacing.md),
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return _TicketCard(
                ticket: ticket,
                onAdvance: ticket.status.next == null
                    ? null
                    : () => context.read<TicketsBloc>().add(
                        TicketsEvent.advanced(
                          orderId: ticket.orderId,
                          station: ticket.station,
                          newStatus: ticket.status.next!,
                        ),
                      ),
              );
            },
          );
        },
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.ticket, required this.onAdvance});

  final Ticket ticket;
  final VoidCallback? onAdvance;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: 'Order #${ticket.orderNumber}',
      trailing: AppBadge(
        _statusLabel(ticket.status),
        variant: _statusVariant(ticket.status),
      ),
      footer: AppButton.primary(
        label: onAdvance == null
            ? 'Bumped'
            : 'Mark ${_statusLabel(ticket.status.next!)}',
        onPressed: onAdvance,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final item in ticket.items)
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: context.tokens.spacing.xxs,
              ),
              child: AppText.body('${item.quantity}x ${item.productName}'),
            ),
        ],
      ),
    );
  }

  String _statusLabel(TicketStatus status) => switch (status) {
    TicketStatus.pending => 'Pending',
    TicketStatus.inProgress => 'In progress',
    TicketStatus.ready => 'Ready',
    TicketStatus.bumped => 'Bumped',
  };

  AppBadgeVariant _statusVariant(TicketStatus status) => switch (status) {
    TicketStatus.pending => AppBadgeVariant.neutral,
    TicketStatus.inProgress => AppBadgeVariant.warning,
    TicketStatus.ready => AppBadgeVariant.success,
    TicketStatus.bumped => AppBadgeVariant.outline,
  };
}
