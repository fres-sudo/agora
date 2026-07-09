import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:printing/printing.dart';
import 'package:result/result.dart';
import 'package:talker/talker.dart';

void main() {
  group('ThermalPrinterServiceImpl', () {
    test(
      'reports success when the transport completes within the timeout',
      () async {
        final service = ThermalPrinterServiceImpl(
          logger: Talker(),
          transport: (bytes) async {},
          transportTimeout: const Duration(milliseconds: 50),
        );

        final result = await service.printBytes([1, 2, 3]);

        expect(result.isSuccess, isTrue);
      },
    );

    test(
      'returns a PrinterTimeoutException instead of hanging when the '
      'transport never completes (e.g. a stalled Bluetooth/USB connection)',
      () async {
        final service = ThermalPrinterServiceImpl(
          logger: Talker(),
          // Simulates a hung connection: the completer is never resolved.
          transport: (bytes) => Completer<void>().future,
          transportTimeout: const Duration(milliseconds: 50),
        );

        final result = await service.printBytes([1, 2, 3]);

        expect(result.isError, isTrue);
        result.when(
          success: (_) => fail('expected a timeout error'),
          error: (error) => expect(error, isA<PrinterTimeoutException>()),
        );
      },
    );

    test('reports success with no transport configured', () async {
      final service = ThermalPrinterServiceImpl(logger: Talker());

      final result = await service.printBytes([1, 2, 3]);

      expect(result.isSuccess, isTrue);
    });
  });
}
