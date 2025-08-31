import 'package:agora/routes/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter/material.dart';

void main() {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(AgoraApp());
}

class AgoraApp extends StatelessWidget {
  AgoraApp({super.key});

  final appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return ShadApp.custom(
      themeMode: ThemeMode.system,
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: const ShadBlueColorScheme.dark(),
      ),
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: const ShadBlueColorScheme.light(),
      ),

      appBuilder: (context) {
        return MaterialApp.router(
          theme: Theme.of(context),
          title: "agora",
          debugShowCheckedModeBanner: false,
          routerDelegate: AutoRouterDelegate(
            appRouter,
            navigatorObservers: () => [AutoRouteObserver()],
          ),
          routeInformationParser: appRouter.defaultRouteParser(),
          builder: (context, child) {
            return ShadAppBuilder(child: child!);
          },
        );
      },
    );
  }
}
