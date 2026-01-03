import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agora/auth/cubits/session/session_cubit.dart';
import 'package:agora/core/routes/app_router.gr.dart';

/// A widget that listens to [SessionCubit] state changes and
/// triggers navigation accordingly.
///
/// This provides reactive navigation when:
/// - User logs in → navigates to OnboardingRoute or ProtectedShellRoute
/// - User logs out → navigates to AuthShellRoute
/// - User completes onboarding → navigates to ProtectedShellRoute
class SessionListener extends StatelessWidget {
  final Widget child;

  const SessionListener({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionCubit, SessionState>(
      listener: (context, state) {
        state.when(
          initial: () {
            // Still initializing, do nothing
          },
          authenticated: () {
            //   if (user.hasCompletedOnboarding) {
            //     context.router.replaceAll([const ProtectedShellRoute()]);
            //   } else {
            //     context.router.replaceAll([const OnboardingRoute()]);
            //   }
          },
          unauthenticated: () {
            context.router.replaceAll([const AuthShellRoute()]);
          },
        );
      },
      child: child,
    );
  }
}
