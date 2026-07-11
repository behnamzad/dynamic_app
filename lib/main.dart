import 'package:dynamic_app/app/app.dart';
import 'package:dynamic_app/core/util/crypto/keystore_gcm_crypto_helper.dart';
import 'package:dynamic_app/di/injection_container.dart';
import 'package:dynamic_app/infrastructure/supabase/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // شروع اتصال Supabase قبل از DI انجام می‌شود تا SupabaseClient در NetworkModule قابل inject باشد.
  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );
  await configureDependencies();
  final KeystoreGcmCryptoHelper aesGcm = inject();
  await aesGcm.initializeSecureKey();

  runApp(
    App(
      appTheme: inject(),
      appRouter: inject(),
      themeService: inject(),
      navigatorObserverLogger: inject(),
    ),
  );
}
