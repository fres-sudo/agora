@TestOn('vm')
library;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sync_engine/sync_engine.dart';

import 'connectivity_monitor_impl_test.mocks.dart';

@GenerateMocks([Connectivity])
void main() {
  late MockConnectivity connectivity;
  late ConnectivityMonitorImpl monitor;

  setUp(() {
    connectivity = MockConnectivity();
    monitor = ConnectivityMonitorImpl(connectivity: connectivity);
  });

  test('currentStatus is true when any result is not none', () async {
    when(
      connectivity.checkConnectivity(),
    ).thenAnswer((_) async => [ConnectivityResult.wifi]);

    expect(await monitor.currentStatus, isTrue);
  });

  test('currentStatus is false when the only result is none', () async {
    when(
      connectivity.checkConnectivity(),
    ).thenAnswer((_) async => [ConnectivityResult.none]);

    expect(await monitor.currentStatus, isFalse);
  });

  test('isOnline maps the change stream the same way', () async {
    when(connectivity.onConnectivityChanged).thenAnswer(
      (_) => Stream.fromIterable([
        [ConnectivityResult.wifi],
        [ConnectivityResult.none],
      ]),
    );

    final results = await monitor.isOnline.toList();
    expect(results, [true, false]);
  });
}
