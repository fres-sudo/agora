import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:agora/auth/widgets/session_listener.dart';

@RoutePage()
class AuthShellPage extends StatelessWidget {
  const AuthShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SessionListener(child: const AutoRouter());
  }
}
