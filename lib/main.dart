import 'package:dynamic_app/core/presentation/app.dart';
import 'package:dynamic_app/di/injection_container.dart';
import 'package:dynamic_app/flavors.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(App(
    appTheme: inject(),
    appRouter: inject(),
    themeService: inject(),
    navigatorObserverLogger: inject(),
  ));
}
