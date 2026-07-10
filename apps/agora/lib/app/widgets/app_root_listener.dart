import 'dart:async';

import 'package:agora/app/app_router.dart';
import 'package:app_reset/app_reset.dart';
// SessionCubit/SessionState live in package:auth_session; feature_auth's
// barrel re-exports them alongside `AuthShellRoute` (an AutoRoute page class
// that stays feature-local), so importing the barrel covers both.
import 'package:feature_auth/feature_auth.dart';
import 'package:feature_onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Owns the top-level routing gate. Onboarding takes precedence over auth: if
/// first-run setup has not been completed the wizard is shown; otherwise the
/// existing session logic decides between the PIN login and the main app. A
/// full data reset (triggered from Settings' danger zone, via
/// [AppResetService]) also routes back to onboarding, from anywhere in the
/// app.
///
/// Installed via `MaterialApp.router`'s `builder`, which places this widget
/// *above* the `Router`. `context.router` therefore cannot resolve an
/// `AutoRouter` ancestor, so navigation goes through the [router] instance
/// directly rather than through the build context.
class AppRootListener extends StatefulWidget {
  const AppRootListener({required this.router, required this.child, super.key});

  final AppRouter router;
  final Widget child;

  @override
  State<AppRootListener> createState() => _AppRootListenerState();
}

class _AppRootListenerState extends State<AppRootListener> {
  StreamSubscription<void>? _resetSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final onboarded = context.read<OnboardingRepository>().isCompleted();
      if (!onboarded) {
        widget.router.replaceAll([const OnboardingShellRoute()]);
      } else {
        // Restore any persisted session (single-user businesses auto-restore).
        context.read<SessionCubit>().init();
      }

      _resetSubscription = context.read<AppResetService>().onReset.listen((_) {
        widget.router.replaceAll([const OnboardingShellRoute()]);
      });
    });
  }

  @override
  void dispose() {
    _resetSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OnboardingCubit, OnboardingState>(
          listenWhen: (prev, next) => prev.phase != next.phase,
          listener: (context, state) {
            switch (state.phase) {
              case OnboardingPhase.completed:
                // Wizard done — hand off to the session gate. Single-user
                // profiles pre-wrote a session, so this lands on the app;
                // staff-login profiles land on the PIN screen.
                context.read<SessionCubit>().init();
              case OnboardingPhase.editing:
              case OnboardingPhase.submitting:
                break;
            }
          },
        ),
        BlocListener<SessionCubit, SessionState>(
          listener: (context, state) {
            state.when(
              initial: () {},
              loading: () {},
              authenticated: (_) =>
                  widget.router.replaceAll([const ProtectedShellRoute()]),
              unauthenticated: () =>
                  widget.router.replaceAll([const AuthShellRoute()]),
              error: (_) {},
            );
          },
        ),
      ],
      child: widget.child,
    );
  }
}
