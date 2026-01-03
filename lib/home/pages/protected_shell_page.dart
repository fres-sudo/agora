import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:agora/auth/widgets/session_listener.dart';
import 'package:agora/core/misc/extensions.dart';
import 'package:agora/core/routes/app_router.gr.dart';
import 'package:agora/core/ui/widgets/session_avatar.dart';

@RoutePage()
class ProtectedShellPage extends StatelessWidget {
  const ProtectedShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SessionListener(
      child: AutoTabsRouter(
        homeIndex: 0,
        routes: const [HomeRoute(), ProfileRoute()],
        builder: (context, child) => Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            type: .fixed,
            landscapeLayout: .linear,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: 'Home'.hardcoded(),
              ),
              BottomNavigationBarItem(
                icon: const SessionAvatar(size: .small),
                label: 'Profile'.hardcoded(),
              ),
            ],
            currentIndex: context.tabsRouter.activeIndex,
            onTap: (index) => context.tabsRouter.setActiveIndex(index),
          ),
        ),
      ),
    );
  }
}
