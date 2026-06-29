import 'package:dynamic_app/app/app.dart';
import 'package:dynamic_app/di/injection_container.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(
    App(
      appTheme: inject(),
      appRouter: inject(),
      themeService: inject(),
      navigatorObserverLogger: inject(),
    ),
  );
}
