import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// هویت ناشناس و نشست مبتنی بر چرخه اجرای برنامه را نگه می‌دارد؛ ثبت‌کننده برای هر رویداد از آن استفاده می‌کند.
@lazySingleton
class BehaviorSessionManager {
  BehaviorSessionManager(this._preferences);

  static const _anonymousIdKey = 'behavior_anonymous_id';
  static const _sessionIdKey = 'behavior_session_id';
  static const _lastActivityAtKey = 'behavior_last_activity_at';
  static const _sessionStartedAtKey = 'behavior_session_started_at';

  final SharedPreferences _preferences;
  final Uuid _uuid = const Uuid();

  String? _anonymousId;
  String? _sessionId;
  DateTime? _sessionStartedAt;
  DateTime? _lastActivityAt;

  String get anonymousId => _anonymousId ?? (throw StateError('BehaviorSessionManager is not initialized'));

  String get currentSessionId => _sessionId ?? (throw StateError('BehaviorSessionManager is not initialized'));

  DateTime get sessionStartedAt => _sessionStartedAt ?? (throw StateError('BehaviorSessionManager is not initialized'));

  /// زمان آخرین تعامل نشست را برای محاسبه مدت و ثبت session_end در اختیار lifecycle می‌گذارد.
  DateTime? get lastActivityAt => _lastActivityAt;

  bool get hasActiveSession => _sessionId != null && _sessionStartedAt != null;

  /// هنگام هر اجرای تازه برنامه، هویت ناشناس را بازیابی و بدون استفاده از timeout یک نشست جدید می‌سازد.
  Future<void> initializeForAppLaunch({DateTime? now}) async {
    final DateTime currentTime = (now ?? DateTime.now()).toUtc();
    await _ensureAnonymousIdentity();
    await startNewSession(now: currentTime);
  }

  Future<void> _ensureAnonymousIdentity() async {
    if (_anonymousId != null && _anonymousId!.isNotEmpty) return;
    _anonymousId = _preferences.getString(_anonymousIdKey);
    if (_anonymousId == null || _anonymousId!.isEmpty) {
      _anonymousId = _uuid.v4();
      await _preferences.setString(_anonymousIdKey, _anonymousId!);
    }
  }

  /// پیش از ثبت رویداد، وجود نشست جاری را تضمین می‌کند و با گذشت زمان شناسه نشست را تغییر نمی‌دهد.
  Future<String> ensureActiveSession({DateTime? now}) async {
    final DateTime currentTime = (now ?? DateTime.now()).toUtc();
    await _ensureAnonymousIdentity();
    if (!hasActiveSession) {
      await startNewSession(now: currentTime);
    }
    await touch(now: currentTime);
    return currentSessionId;
  }

  Future<String> startNewSession({DateTime? now}) async {
    final DateTime currentTime = (now ?? DateTime.now()).toUtc();
    await _ensureAnonymousIdentity();
    _sessionId = _uuid.v4();
    _sessionStartedAt = currentTime;
    _lastActivityAt = currentTime;
    await Future.wait([
      _preferences.setString(_sessionIdKey, _sessionId!),
      _preferences.setString(_sessionStartedAtKey, currentTime.toIso8601String()),
      _preferences.setString(_lastActivityAtKey, currentTime.toIso8601String()),
    ]);
    return _sessionId!;
  }

  Future<void> touch({DateTime? now}) async {
    if (!hasActiveSession) return;
    final DateTime currentTime = (now ?? DateTime.now()).toUtc();
    _lastActivityAt = currentTime;
    await _preferences.setString(_lastActivityAtKey, currentTime.toIso8601String());
  }

  Future<void> endSession({DateTime? now}) async {
    if (hasActiveSession) {
      await touch(now: now);
    }
    _sessionId = null;
    _sessionStartedAt = null;
    await Future.wait([_preferences.remove(_sessionIdKey), _preferences.remove(_sessionStartedAtKey)]);
  }
}
