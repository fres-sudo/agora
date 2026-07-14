/// Wire frame `"type"` values shared between [SyncWebSocket] (client) and
/// the LAN hub server (`packages/lan_hub`), so the two sides never drift on
/// a literal string.
abstract final class SyncFrameType {
  static const subscribe = 'subscribe';
  static const unsubscribe = 'unsubscribe';
  static const ping = 'ping';
  static const pong = 'pong';
  static const message = 'message';
  static const publish = 'publish';
  static const ack = 'ack';
  static const error = 'error';
}
