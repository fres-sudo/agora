import 'dart:async';

import 'package:app_settings/blocs/settings_cubit.dart';
import 'package:bloc_exports/bloc_exports.dart';
import 'package:database/database.dart';
import 'package:feature_settings/presentation/widgets/settings_section_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:lan_hub/lan_hub.dart';
import 'package:sync_engine/sync_engine.dart';
import 'package:ui_kit/ui_kit.dart';

enum _SyncRole { standalone, host, client }

_SyncRole _roleFromString(String? value) => switch (value) {
  'host' => _SyncRole.host,
  'client' => _SyncRole.client,
  _ => _SyncRole.standalone,
};

String _roleToString(_SyncRole role) => switch (role) {
  _SyncRole.standalone => 'standalone',
  _SyncRole.host => 'host',
  _SyncRole.client => 'client',
};

/// LAN sync pairing/hosting: a station is standalone by default (works
/// identically to today, zero setup), or opts into hosting this event
/// (embedded hub, see `HostSessionController`) or joining one already
/// running on the LAN. See docs/features/01-lan-sync.md.
///
/// A wrong PIN, an unreachable hub, or the hub disappearing mid-event must
/// never read as a hard failure to the volunteer at the register — every
/// action here degrades to "stay standalone" with a snackbar, never a
/// crash or a blocked checkout.
class SyncSection extends StatefulWidget {
  const SyncSection({super.key});

  @override
  State<SyncSection> createState() => _SyncSectionState();
}

class _SyncSectionState extends State<SyncSection> {
  _SyncRole _role = _SyncRole.standalone;
  final _stationNameCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  final _manualHostCtrl = TextEditingController();
  final _joinPinCtrl = TextEditingController();

  bool _isBusy = false;
  List<HubCandidate> _discovered = [];
  StreamSubscription<List<HubCandidate>>? _discoverySub;
  StreamSubscription<SyncStatus>? _statusSub;
  StreamSubscription<int>? _connectedCountSub;
  SyncStatus _status = const SyncPaused();
  int _connectedStationCount = 0;

  @override
  void initState() {
    super.initState();
    _loadFromSettings();

    _statusSub = context.read<SyncManager>().status.listen((status) {
      if (mounted) setState(() => _status = status);
    });
    _connectedCountSub = context.read<HubServer>().connectedStationCount.listen(
      (count) {
        if (mounted) setState(() => _connectedStationCount = count);
      },
    );

    if (_role == _SyncRole.client) _startDiscovery();
  }

  void _loadFromSettings() {
    final cubit = context.read<SettingsCubit>();
    _role = _roleFromString(cubit.getString(SettingsKeys.syncRole));
    _stationNameCtrl.text = cubit.getString(SettingsKeys.syncStationName) ?? '';
    _pinCtrl.text = cubit.getString(SettingsKeys.syncPairingPin) ?? '';
    _manualHostCtrl.text = cubit.getString(SettingsKeys.syncHubAddress) ?? '';
  }

  void _startDiscovery() {
    _discoverySub?.cancel();
    _discoverySub = context.read<HubDiscovery>().discover().listen((
      candidates,
    ) {
      if (mounted) setState(() => _discovered = candidates);
    });
  }

  void _stopDiscovery() {
    _discoverySub?.cancel();
    _discoverySub = null;
    unawaited(context.read<HubDiscovery>().stopDiscovery());
  }

  Future<void> _startHosting() async {
    final stationName = _stationNameCtrl.text.trim();
    final pin = _pinCtrl.text.trim();
    if (stationName.isEmpty || pin.isEmpty) {
      showAppSnackBar(
        context,
        'Enter a station name and a PIN first',
        isError: true,
      );
      return;
    }

    setState(() => _isBusy = true);
    final cubit = context.read<SettingsCubit>();
    final hostSessionController = context.read<HostSessionController>();
    await Future.wait([
      cubit.update(SettingsKeys.syncStationName, stationName),
      cubit.update(SettingsKeys.syncPairingPin, pin),
    ]);

    try {
      await hostSessionController.startHosting(stationName: stationName);
      await cubit.update(SettingsKeys.syncRole, _roleToString(_SyncRole.host));
      if (!mounted) return;
      setState(() => _role = _SyncRole.host);
      showAppSnackBar(context, 'Hosting this event as "$stationName"');
    } catch (e) {
      if (!mounted) return;
      showAppSnackBar(
        context,
        'Could not start hosting — this device keeps working standalone',
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _stopHosting() async {
    setState(() => _isBusy = true);
    final cubit = context.read<SettingsCubit>();
    await context.read<HostSessionController>().stopHosting();
    await cubit.update(
      SettingsKeys.syncRole,
      _roleToString(_SyncRole.standalone),
    );
    if (!mounted) return;
    setState(() {
      _role = _SyncRole.standalone;
      _isBusy = false;
    });
    showAppSnackBar(context, 'Stopped hosting');
  }

  Future<void> _connect({required String host, required int port}) async {
    final pin = _joinPinCtrl.text.trim();
    final stationName = _stationNameCtrl.text.trim().isEmpty
        ? 'Station'
        : _stationNameCtrl.text.trim();
    if (pin.isEmpty) {
      showAppSnackBar(context, 'Enter the event PIN first', isError: true);
      return;
    }

    setState(() => _isBusy = true);
    final cubit = context.read<SettingsCubit>();
    final syncManager = context.read<SyncManager>();
    try {
      final deviceId = context.read<DeviceId>();
      final token = await context.read<HubPairingClient>().pair(
        host: host,
        port: port,
        pin: pin,
        deviceId: deviceId.value,
        deviceName: stationName,
      );

      await Future.wait([
        cubit.update(SettingsKeys.syncStationName, stationName),
        cubit.update(SettingsKeys.syncHubAddress, '$host:$port'),
        cubit.update(SettingsKeys.syncHubToken, token),
        cubit.update(SettingsKeys.syncRole, _roleToString(_SyncRole.client)),
      ]);

      await syncManager.start(
        webSocketUrl: 'ws://$host:$port/sync',
        authToken: token,
      );

      if (!mounted) return;
      setState(() => _role = _SyncRole.client);
      _stopDiscovery();
      showAppSnackBar(context, 'Connected to the event');
    } on HubPairingException catch (e) {
      if (!mounted) return;
      showAppSnackBar(context, e.message, isError: true);
    } catch (e) {
      if (!mounted) return;
      showAppSnackBar(
        context,
        'Could not reach the hub — this device keeps working standalone',
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _connectManual() async {
    final parts = _manualHostCtrl.text.trim().split(':');
    if (parts.length != 2) {
      showAppSnackBar(
        context,
        'Enter the address as host:port, e.g. 192.168.1.20:8080',
        isError: true,
      );
      return;
    }
    final port = int.tryParse(parts[1]);
    if (port == null) {
      showAppSnackBar(context, 'Invalid port', isError: true);
      return;
    }
    await context.read<SettingsCubit>().update(
      SettingsKeys.syncHubAddress,
      _manualHostCtrl.text.trim(),
    );
    await _connect(host: parts[0], port: port);
  }

  Future<void> _forgetPairing() async {
    setState(() => _isBusy = true);
    final cubit = context.read<SettingsCubit>();
    await context.read<SyncManager>().stop();
    await Future.wait([
      cubit.update(SettingsKeys.syncRole, _roleToString(_SyncRole.standalone)),
      cubit.update(SettingsKeys.syncHubAddress, ''),
      cubit.update(SettingsKeys.syncHubToken, ''),
    ]);
    if (!mounted) return;
    setState(() {
      _role = _SyncRole.standalone;
      _isBusy = false;
    });
    showAppSnackBar(context, 'Disconnected — this station is now standalone');
  }

  void _onRoleChanged(_SyncRole role) {
    if (role == _role) return;
    setState(() => _role = role);
    if (role == _SyncRole.client) {
      _startDiscovery();
    } else {
      _stopDiscovery();
    }
  }

  @override
  void dispose() {
    _discoverySub?.cancel();
    _statusSub?.cancel();
    _connectedCountSub?.cancel();
    _stationNameCtrl.dispose();
    _pinCtrl.dispose();
    _manualHostCtrl.dispose();
    _joinPinCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSectionScaffold(
      title: 'Sync',
      actionButton: const SizedBox.shrink(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.body(
            'Share a live order queue and stock count with other stations '
            'on the same WiFi. No internet, no account — works entirely on '
            'this event\'s local network.',
          ),
          SizedBox(height: context.tokens.spaceLg),
          AppSegmentedControl<_SyncRole>(
            segments: const [
              AppSegment(value: _SyncRole.standalone, label: 'Solo'),
              AppSegment(value: _SyncRole.host, label: 'Host this event'),
              AppSegment(value: _SyncRole.client, label: 'Join an event'),
            ],
            selected: _role,
            onChanged: _isBusy ? (_) {} : _onRoleChanged,
          ),
          SizedBox(height: context.tokens.spaceLg),
          if (_role != _SyncRole.standalone) ...[
            _StatusBar(status: _status),
            SizedBox(height: context.tokens.spaceLg),
          ],
          switch (_role) {
            _SyncRole.standalone => AppText.bodySm(
              'This station works entirely on its own. Switch to "Host" or '
              '"Join" to share orders and stock with other stations.',
            ),
            _SyncRole.host => _HostControls(
              stationNameCtrl: _stationNameCtrl,
              pinCtrl: _pinCtrl,
              isBusy: _isBusy,
              isHosting: context.watch<HostSessionController>().isHosting,
              connectedStationCount: _connectedStationCount,
              onStart: _startHosting,
              onStop: _stopHosting,
            ),
            _SyncRole.client => _ClientControls(
              joinPinCtrl: _joinPinCtrl,
              manualHostCtrl: _manualHostCtrl,
              discovered: _discovered,
              isBusy: _isBusy,
              isConnected: _status is! SyncPaused,
              onConnectDiscovered: (candidate) =>
                  _connect(host: candidate.host, port: candidate.port),
              onConnectManual: _connectManual,
              onForget: _forgetPairing,
            ),
          },
        ],
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.status});

  final SyncStatus status;

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      SyncIdle() => 'Up to date',
      SyncInProgress(:final pendingCount) => 'Syncing $pendingCount item(s)…',
      SyncPaused() => 'Not connected',
      SyncFailed(:final reason) => reason,
    };
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.tokens.spaceMd,
        vertical: context.tokens.spaceSm,
      ),
      decoration: BoxDecoration(
        color: context.colors.muted,
        borderRadius: context.tokens.borderRadiusMd,
      ),
      child: Row(
        children: [
          Icon(AgoraIcons.wifi, size: context.tokens.iconSm),
          SizedBox(width: context.tokens.spaceXs),
          AppText.bodySm(label),
        ],
      ),
    );
  }
}

class _HostControls extends StatelessWidget {
  const _HostControls({
    required this.stationNameCtrl,
    required this.pinCtrl,
    required this.isBusy,
    required this.isHosting,
    required this.connectedStationCount,
    required this.onStart,
    required this.onStop,
  });

  final TextEditingController stationNameCtrl;
  final TextEditingController pinCtrl;
  final bool isBusy;
  final bool isHosting;
  final int connectedStationCount;
  final Future<void> Function() onStart;
  final Future<void> Function() onStop;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: 'Station name',
          hintText: 'e.g. Drinks Stand',
          controller: stationNameCtrl,
          enabled: !isHosting,
        ),
        SizedBox(height: context.tokens.spaceMd),
        AppTextField(
          label: 'Event PIN',
          hintText: 'Shared with every station joining this event',
          controller: pinCtrl,
          enabled: !isHosting,
        ),
        SizedBox(height: context.tokens.spaceLg),
        if (isHosting) ...[
          AppText.bodySm('$connectedStationCount station(s) connected'),
          SizedBox(height: context.tokens.spaceSm),
        ],
        AppButton.primary(
          onPressed: isBusy ? null : (isHosting ? onStop : onStart),
          isLoading: isBusy,
          label: isHosting ? 'Stop Hosting' : 'Start Hosting',
        ),
        if (isHosting) ...[
          SizedBox(height: context.tokens.spaceMd),
          AppText.bodySm(
            'Keep this device awake and on WiFi while hosting — other '
            'stations lose sync if it sleeps or leaves the network.',
          ),
        ],
      ],
    );
  }
}

class _ClientControls extends StatelessWidget {
  const _ClientControls({
    required this.joinPinCtrl,
    required this.manualHostCtrl,
    required this.discovered,
    required this.isBusy,
    required this.isConnected,
    required this.onConnectDiscovered,
    required this.onConnectManual,
    required this.onForget,
  });

  final TextEditingController joinPinCtrl;
  final TextEditingController manualHostCtrl;
  final List<HubCandidate> discovered;
  final bool isBusy;
  final bool isConnected;
  final Future<void> Function(HubCandidate) onConnectDiscovered;
  final Future<void> Function() onConnectManual;
  final Future<void> Function() onForget;

  @override
  Widget build(BuildContext context) {
    if (isConnected) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.bodySm('Connected to the event hub.'),
          SizedBox(height: context.tokens.spaceMd),
          AppButton.outline(
            onPressed: isBusy ? null : onForget,
            isLoading: isBusy,
            label: 'Forget Pairing / Disconnect',
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: 'Event PIN',
          hintText: 'Ask the organiser for this event\'s PIN',
          controller: joinPinCtrl,
        ),
        SizedBox(height: context.tokens.spaceLg),
        AppText.label('Nearby events'),
        SizedBox(height: context.tokens.spaceSm),
        if (discovered.isEmpty)
          AppText.bodySm('Looking for events on this WiFi…')
        else
          for (final candidate in discovered)
            Padding(
              padding: EdgeInsets.only(bottom: context.tokens.spaceSm),
              child: AppButton.secondary(
                onPressed: isBusy ? null : () => onConnectDiscovered(candidate),
                label: candidate.name,
              ),
            ),
        SizedBox(height: context.tokens.spaceLg),
        const Divider(),
        SizedBox(height: context.tokens.spaceMd),
        AppText.label('Or enter the hub address manually'),
        SizedBox(height: context.tokens.spaceSm),
        AppTextField(
          hintText: 'e.g. 192.168.1.20:8080',
          controller: manualHostCtrl,
        ),
        SizedBox(height: context.tokens.spaceMd),
        AppButton.primary(
          onPressed: isBusy ? null : onConnectManual,
          isLoading: isBusy,
          label: 'Connect',
        ),
      ],
    );
  }
}
