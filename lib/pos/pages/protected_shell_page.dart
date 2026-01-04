import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:agora/auth/widgets/session_listener.dart';
import 'package:agora/core/routes/app_router.gr.dart';

@RoutePage()
class ProtectedShellPage extends StatelessWidget {
  const ProtectedShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SessionListener(
      child: AutoTabsRouter(
        homeIndex: 0,
        routes: const [PosRoute()],
        builder: (context, child) => Scaffold(body: child),
      ),
    );
  }
}
