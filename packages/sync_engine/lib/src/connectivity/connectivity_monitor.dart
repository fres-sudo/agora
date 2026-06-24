import 'package:connectivity_plus/connectivity_plus.dart';

abstract interface class ConnectivityMonitor {
  /// Emits `true` when the device gains a network route, `false` when it loses one.
  Stream<bool> get isOnline;

  /// One-shot check for the current connectivity state.
  Future<bool> get currentStatus;
}

class ConnectivityMonitorImpl implements ConnectivityMonitor {
  ConnectivityMonitorImpl() : _connectivity = Connectivity();

  final Connectivity _connectivity;

  @override
  Stream<bool> get isOnline => _connectivity.onConnectivityChanged.map(
        (results) => results.any((r) => r != ConnectivityResult.none),
      );

  @override
  Future<bool> get currentStatus async {
    final results = await _connectivity.checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }
}
