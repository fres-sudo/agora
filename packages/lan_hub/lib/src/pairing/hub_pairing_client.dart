import 'dart:convert';
import 'dart:io';

import 'package:talker/talker.dart';

/// Thrown when pairing with a hub fails — wrong PIN, hub unreachable, or an
/// unexpected response.
class HubPairingException implements Exception {
  HubPairingException(this.message);

  final String message;

  @override
  String toString() => 'HubPairingException: $message';
}

/// Client-side counterpart to `HubServer`'s `POST /pair` endpoint.
///
/// Deliberately uses `dart:io`'s `HttpClient` rather than pulling in a
/// full HTTP package dependency — this is the only HTTP call this feature
/// ever makes; everything else is over the already-open WebSocket.
class HubPairingClient {
  HubPairingClient({required Talker logger}) : _logger = logger;

  final Talker _logger;

  /// Pairs with the hub at `http://$host:$port/pair`, returning a session
  /// token on success. Throws [HubPairingException] on a wrong PIN, an
  /// unreachable hub, or a malformed response — callers should treat this
  /// as "stay standalone," never as a crash (see docs/features/01-lan-sync.md).
  Future<String> pair({
    required String host,
    required int port,
    required String pin,
    required String deviceId,
    required String deviceName,
  }) async {
    final client = HttpClient();
    try {
      final request = await client
          .postUrl(Uri.parse('http://$host:$port/pair'))
          .timeout(const Duration(seconds: 5));
      request.headers.contentType = ContentType.json;
      request.write(
        jsonEncode({
          'pin': pin,
          'deviceId': deviceId,
          'deviceName': deviceName,
        }),
      );

      final response = await request.close().timeout(
        const Duration(seconds: 5),
      );
      final body = await response.transform(utf8.decoder).join();

      if (response.statusCode != HttpStatus.ok) {
        final message =
            _extractErrorMessage(body) ?? 'HTTP ${response.statusCode}';
        throw HubPairingException(message);
      }

      final decoded = jsonDecode(body) as Map<String, dynamic>;
      final token = decoded['token'] as String?;
      if (token == null) {
        throw HubPairingException('Hub response missing a token');
      }
      return token;
    } on HubPairingException {
      rethrow;
    } catch (e) {
      _logger.error('[HubPairingClient] pair failed: $e');
      throw HubPairingException('Could not reach hub at $host:$port: $e');
    } finally {
      client.close(force: true);
    }
  }

  String? _extractErrorMessage(String body) {
    try {
      final decoded = jsonDecode(body) as Map<String, dynamic>;
      return decoded['message'] as String?;
    } catch (_) {
      return null;
    }
  }
}
