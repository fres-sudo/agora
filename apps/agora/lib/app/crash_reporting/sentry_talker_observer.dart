import 'dart:async';

import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:talker/talker.dart';

/// Routes error-level Talker events to Sentry.
///
/// Register this observer on the [Talker] instance at startup (only when a
/// Sentry DSN is configured). Every [talker.handle] / [talker.error] call
/// throughout the codebase will then automatically forward to Sentry without
/// any call-site changes.
class SentryTalkerObserver extends TalkerObserver {
  @override
  void onError(TalkerError err) {
    try {
      unawaited(
        Sentry.captureException(err.error, stackTrace: err.stackTrace),
      );
    } catch (_) {
      // Never let an observer failure crash the app.
    }
  }

  @override
  void onException(TalkerException err) {
    try {
      unawaited(
        Sentry.captureException(err.exception, stackTrace: err.stackTrace),
      );
    } catch (_) {
      // Never let an observer failure crash the app.
    }
  }
}
