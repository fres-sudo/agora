import 'dart:async';
import 'dart:developer';

import 'package:agora/app/app.dart';
import 'package:i18n/i18n.dart';
import 'package:bloc/bloc.dart';
import 'package:database/database.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:observer/observer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';
import 'package:utils/utils.dart';

void main() async {
  await runZonedGuarded(
    () async {
      final binding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: binding);

      LocaleSettings.useDeviceLocale();

      PersistenceServiceImpl.instance = await SharedPreferences.getInstance();

      final talker = Talker();
      Bloc.observer = AppBlocObserver(talker: talker);

      final db = AgoraDatabase(driftDatabase(name: K.dbName));
      await DataSeeder(db).seed();
      await db.close();

      FlutterNativeSplash.remove();
      runApp(TranslationProvider(child: const AgoraApp()));
    },
    (error, stackTrace) async {
      log('[ZonedGuarded] $error$stackTrace');
    },
  );
}
