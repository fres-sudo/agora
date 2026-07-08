import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

/// Shown while [SessionCubit.init] resolves the persisted session on startup.
/// Kept as its own route (rather than defaulting straight to the protected
/// shell) so an unauthenticated user never sees a frame of app content before
/// being routed to the PIN login screen.
@RoutePage()
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppPalette.neutral900,
      body: Center(
        child: CircularProgressIndicator(color: AppPalette.primary500),
      ),
    );
  }
}
