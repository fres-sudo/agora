import 'package:agora/di/dependency_injector.dart';
import 'package:agora/routes/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  App({super.key});

  final appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return ShadApp.custom(
      themeMode: ThemeMode.system,
      darkTheme: ShadThemeData(
        textTheme: ShadTextTheme.fromGoogleFont(GoogleFonts.aDLaMDisplay),
        brightness: Brightness.dark,
        colorScheme: const ShadBlueColorScheme.dark(),
      ),
      theme: ShadThemeData(
        textTheme: ShadTextTheme.fromGoogleFont(GoogleFonts.interTight),
        brightness: Brightness.light,
        colorScheme: const ShadBlueColorScheme.light(),
      ),
      appBuilder: (context) {
        return DependencyInjector(
          child: MaterialApp.router(
            theme: Theme.of(context),
            title: "agora",
            debugShowCheckedModeBanner: false,
            routerDelegate: AutoRouterDelegate(
              appRouter,
              navigatorObservers: () => [AutoRouteObserver()],
            ),
            routeInformationParser: appRouter.defaultRouteParser(),
            builder: (context, child) => ShadAppBuilder(child: child!),
          ),
        );
      },
    );
  }
}
