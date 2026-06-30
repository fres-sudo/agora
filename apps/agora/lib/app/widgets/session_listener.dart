import 'package:agora/app/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Listens to [SessionCubit] and drives all auth navigation globally.
/// Must be placed above the router so it stays active on every route.
class SessionListener extends StatefulWidget {
  const SessionListener({required this.child, super.key});

  final Widget child;

  @override
  State<SessionListener> createState() => _SessionListenerState();
}

class _SessionListenerState extends State<SessionListener> {
  @override
  void initState() {
    super.initState();
    // Restore persisted session once the widget tree is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<SessionCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionCubit, SessionState>(
      listener: (context, state) {
        state.when(
          initial: () {},
          loading: () {},
          authenticated: (_) =>
              context.router.replaceAll([const ProtectedShellRoute()]),
          unauthenticated: () =>
              context.router.replaceAll([const AuthShellRoute()]),
          error: (_) {},
        );
      },
      child: widget.child,
    );
  }
}
