import 'package:dynamic_app/core/config/strings.dart';
import 'package:dynamic_app/core/local/setting_manager.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class ThemeService {
  final SettingsManager settingManager;

  ThemeService(this.settingManager);

  bool get isDark => _loadTheme();

  ThemeMode get theme => _loadTheme() ? ThemeMode.dark : ThemeMode.light;

  ThemeMode get themeMode => _loadThemeMode();

  ThemeMode _loadThemeMode() {
    String currentTheme = settingManager.getTheme();
    return ThemeMode.values.byName(currentTheme);
  }

  bool _loadTheme() {
    bool isDark = false;
    String currentTheme = settingManager.getTheme();
    ThemeMode themeMode = ThemeMode.values.byName(currentTheme);
    if (themeMode == ThemeMode.system) {
      Brightness currentBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      // var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
      isDark = currentBrightness == Brightness.dark;
    } else {
      isDark = themeMode == ThemeMode.dark;
    }
    return isDark;
  }

  String? getFarsiName({ThemeMode? themeName}) {
    ThemeMode t = themeName ?? lastSavedTheme;
    switch (t) {
      case ThemeMode.system:
        return ss.themeModeSystem;
      case ThemeMode.dark:
        return ss.themeModeDark;
      case ThemeMode.light:
        return ss.themeModeLight;
    }
  }

  String? get farsiNameFromString {
    switch (lastSavedTheme) {
      case ThemeMode.system:
        return ss.themeModeSystem;
      case ThemeMode.dark:
        return ss.themeModeDark;
      case ThemeMode.light:
        return ss.themeModeLight;
    }
  }

  ThemeMode get lastSavedTheme {
    String currentTheme = settingManager.getTheme();
    return ThemeMode.values.byName(currentTheme);
  }

  List<ThemeMode> get allThemes => [ThemeMode.system, ThemeMode.light, ThemeMode.dark];
}
