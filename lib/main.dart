import 'package:dynamic_app/app/app.dart';
import 'package:dynamic_app/core/util/crypto/keystore_gcm_crypto_helper.dart';
import 'package:dynamic_app/di/injection_container.dart';
import 'package:dynamic_app/infrastructure/supabase/supabase_config.dart';
import 'package:dynamic_app/shared/behavior/data/database/behavior_database.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_payload.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_type.dart';
import 'package:dynamic_app/shared/behavior/domain/manager/behavior_logger.dart';
import 'package:dynamic_app/shared/behavior/domain/manager/behavior_session_manager.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // شروع اتصال Supabase قبل از DI انجام می‌شود تا SupabaseClient در NetworkModule قابل inject باشد.
  await Supabase.initialize(url: SupabaseConfig.url, publishableKey: SupabaseConfig.publishableKey);
  await configureDependencies();
  // دیتابیس لاگ قبل از اجرای UI باز می‌شود تا ثبت اولین ایونت منتظر ساخت SQLite نماند.
  final BehaviorDatabase behaviorDatabase = inject<BehaviorDatabase>();
  await behaviorDatabase.initialize();
  // هر اجرای تازه برنامه یک نشست مستقل می‌سازد؛ جابه‌جایی صفحات همین شناسه را حفظ خواهد کرد.
  final BehaviorSessionManager behaviorSessionManager = inject<BehaviorSessionManager>();
  await behaviorSessionManager.initializeForAppLaunch();
  // شروع نشست همان لحظه در صف محلی ثبت می‌شود تا پایتون مرز ابتدای مسیر کاربر را داشته باشد.
  final BehaviorLogger behaviorLogger = inject<BehaviorLogger>();
  await behaviorLogger.record(
    const BehaviorEventDraft(
      type: BehaviorEventType.sessionStart,
      sourceScreen: 'app',
      payload: LifecycleBehaviorPayload(reason: 'app_launch'),
    ),
  );
  final KeystoreGcmCryptoHelper aesGcm = inject();
  await aesGcm.initializeSecureKey();

  runApp(App(appTheme: inject(), appRouter: inject(), themeService: inject(), navigatorObserverLogger: inject()));
}
