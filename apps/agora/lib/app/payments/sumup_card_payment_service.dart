import 'package:flutter/services.dart';
import 'package:payment_contracts/payment_contracts.dart';
import 'package:talker/talker.dart';

/// Thin Flutter boundary around the native SumUp Reader SDKs.
final class SumUpCardPaymentService implements CardPaymentService {
  SumUpCardPaymentService({
    required String affiliateKey,
    Talker? logger,
    MethodChannel? channel,
  }) : _affiliateKey = affiliateKey.trim(),
       _logger = logger,
       _channel = channel ?? const MethodChannel(_channelName);

  static const String _channelName = 'space.fres.agora/sumup';

  final String _affiliateKey;
  final Talker? _logger;
  final MethodChannel _channel;
  Future<void>? _initialization;

  Future<void> _ensureInitialized() => _initialization ??= _channel
      .invokeMethod<void>('initialize', {'affiliateKey': _affiliateKey})
      .catchError((Object error, StackTrace stack) {
        _initialization = null;
        Error.throwWithStackTrace(error, stack);
      });

  @override
  Future<CardPaymentStatus> getStatus() async {
    if (_affiliateKey.isEmpty) {
      return const CardPaymentStatus(
        readiness: CardPaymentReadiness.notConfigured,
        message: 'SumUp affiliate key is not configured.',
      );
    }
    try {
      await _ensureInitialized();
      return _statusFromMap(await _invokeMap('status'));
    } on MissingPluginException {
      return const CardPaymentStatus(
        readiness: CardPaymentReadiness.unsupported,
        message: 'Card payments are not supported on this platform.',
      );
    } catch (error, stack) {
      _logger?.handle(error, stack, '[SumUp] status failed');
      return CardPaymentStatus(
        readiness: CardPaymentReadiness.unsupported,
        message: _message(error),
      );
    }
  }

  @override
  Future<CardPaymentStatus> login() => _statusOperation('login');

  @override
  Future<CardPaymentStatus> openReaderSettings() =>
      _statusOperation('openReaderSettings');

  @override
  Future<CardPaymentStatus> logout() => _statusOperation('logout');

  Future<CardPaymentStatus> _statusOperation(String method) async {
    final initial = await getStatus();
    if (initial.readiness == CardPaymentReadiness.notConfigured ||
        initial.readiness == CardPaymentReadiness.unsupported) {
      return initial;
    }
    try {
      return _statusFromMap(await _invokeMap(method));
    } catch (error, stack) {
      _logger?.handle(error, stack, '[SumUp] $method failed');
      return CardPaymentStatus(
        readiness: CardPaymentReadiness.unsupported,
        message: _message(error),
      );
    }
  }

  @override
  Future<CardChargeResult> charge(CardChargeRequest request) async {
    if (request.amountCents <= 0) {
      return const CardChargeFailed(
        message: 'The card payment amount must be greater than zero.',
      );
    }

    final status = await getStatus();
    if (!status.canCharge) {
      return CardChargeFailed(
        message: status.message ?? 'The SumUp reader is not ready.',
      );
    }

    try {
      final response = await _invokeMap('charge', {
        'amountCents': request.amountCents,
        'currencyCode': request.currencyCode,
        'title': request.title,
        'foreignTransactionId': request.foreignTransactionId,
      });
      return switch (response['outcome']) {
        'approved' => CardChargeApproved(
          transactionCode: response['transactionCode'] as String? ?? '',
        ),
        'declined' => CardChargeDeclined(
          message: response['message'] as String?,
        ),
        'cancelled' => const CardChargeCancelled(),
        'unknown' => CardChargeUnknown(message: response['message'] as String?),
        _ => CardChargeFailed(
          message: response['message'] as String? ?? 'The card payment failed.',
        ),
      };
    } catch (error, stack) {
      _logger?.handle(error, stack, '[SumUp] checkout failed');
      return CardChargeFailed(message: _message(error));
    }
  }

  Future<Map<Object?, Object?>> _invokeMap(
    String method, [
    Map<String, Object?>? arguments,
  ]) async {
    final result = await _channel.invokeMethod<Map<Object?, Object?>>(
      method,
      arguments,
    );
    return result ?? const <Object?, Object?>{};
  }

  CardPaymentStatus _statusFromMap(Map<Object?, Object?> map) {
    final readiness = switch (map['readiness']) {
      'ready' => CardPaymentReadiness.ready,
      'loggedOut' => CardPaymentReadiness.loggedOut,
      'notConfigured' => CardPaymentReadiness.notConfigured,
      _ => CardPaymentReadiness.unsupported,
    };
    return CardPaymentStatus(
      readiness: readiness,
      merchantCode: map['merchantCode'] as String?,
      currencyCode: map['currencyCode'] as String?,
      readerModel: map['readerModel'] as String?,
      readerConnected: map['readerConnected'] as bool? ?? false,
      message: map['message'] as String?,
    );
  }

  String _message(Object error) => switch (error) {
    PlatformException(:final message?) => message,
    _ => 'Unable to communicate with the SumUp Reader SDK.',
  };
}
