import 'package:dynamic_app/core/local/setting_manager.dart';
import 'package:dynamic_app/core/local/user/user.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

@lazySingleton
class UserManager {
  final SettingsManager _settingsManager;
  AppUser? _currentUser;

  UserManager(this._settingsManager);

  AppUser? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  String? get currentUserId => _currentUser?.id;

  String? get currentEmail => _currentUser?.email;

  String? get currentUsername => _currentUser?.username;

  AppUserGender get currentGender => _currentUser?.gender ?? AppUserGender.unknown;

  int? get currentAge => _currentUser?.age;

  String get savedLoginEmail => _settingsManager.getLastLoginEmail();

  void loadSavedUser() {
    // شروع بازیابی کاربر از main/app init یا LoginBloc است؛ آخرین user ذخیره‌شده را به حافظه برمی‌گرداند.
    _currentUser = _settingsManager.getLoggedInUser();
  }

  Future<void> setCurrentUserFromSupabase({
    required supabase.User user,
    supabase.Session? session,
  }) async {
    // بعد از login موفق در LoginBloc، پاسخ Supabase اینجا به AppUser تبدیل و برای کل اپ نگه‌داری می‌شود.
    final appUser = AppUser.fromSupabase(user: user, session: session);
    _currentUser = appUser;
    await _settingsManager.setLoggedInUser(appUser);
    await _settingsManager.setLastLoginEmail(appUser.email);
  }

  Future<void> clearCurrentUser() async {
    // خروج کاربر باید از این مسیر انجام شود تا هم حافظه و هم SharedPreferences پاک شوند.
    _currentUser = null;
    await _settingsManager.clearLoggedInUser();
  }
}
