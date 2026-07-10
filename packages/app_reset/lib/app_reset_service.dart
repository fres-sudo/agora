import 'dart:async';

import 'package:auth_session/auth_session.dart';
import 'package:database/database.dart';
import 'package:feature_flags/feature_flags.dart';
import 'package:talker/talker.dart';
import 'package:utils/utils.dart';

/// Wipes all local data and returns the app to first-run onboarding.
///
/// This is a cross-cutting concern shared by `feature_settings` (the "Reset
/// everything" danger-zone action) and `feature_onboarding` (which composes
/// the same wipe internally when the wizard needs a clean slate). It lives in
/// `packages/` — rather than on `feature_onboarding`'s own repository — so
/// `feature_settings` can trigger a reset without importing
/// `feature_onboarding` (see GitHub issue #4).
///
/// [onReset] lets app-shell code (e.g. the root routing gate) react to a
/// reset fired from *any* caller and navigate back to the onboarding wizard,
/// without either caller needing to own that navigation decision itself.
abstract interface class AppResetService {
  /// Wipes the database, clears the business profile + session, and flags
  /// onboarding as incomplete again. Emits on [onReset] on success.
  Future<void> resetEverything();

  /// Fires (with no payload) every time [resetEverything] completes.
  Stream<void> get onReset;
}

class AppResetServiceImpl implements AppResetService {
  AppResetServiceImpl({
    required AgoraDatabase database,
    required BusinessProfileRepository businessProfileRepository,
    required AuthRepository authRepository,
    required PersistenceService persistenceService,
    Talker? logger,
  }) : _db = database,
       _businessProfile = businessProfileRepository,
       _auth = authRepository,
       _persistence = persistenceService,
       _logger = logger;

  final AgoraDatabase _db;
  final BusinessProfileRepository _businessProfile;
  final AuthRepository _auth;
  final PersistenceService _persistence;
  final Talker? _logger;

  final _resetController = StreamController<void>.broadcast();

  @override
  Stream<void> get onReset => _resetController.stream;

  @override
  Future<void> resetEverything() async {
    try {
      await _db.resetAllData();
      await _businessProfile.clear();
      await _auth.signOut();
      await _persistence.saveBool(SPKeys.onboarding, false);
      _resetController.add(null);
    } catch (e) {
      _logger?.error('resetEverything failed: $e');
      rethrow;
    }
  }
}
