// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:device_info_plus/device_info_plus.dart' as _i833;
import 'package:dio/dio.dart' as _i361;
import 'package:dynamic_app/core/config/assets/assets.dart' as _i1011;
import 'package:dynamic_app/core/config/configs.dart' as _i954;
import 'package:dynamic_app/core/config/strings.dart' as _i376;
import 'package:dynamic_app/core/local/setting_manager.dart' as _i906;
import 'package:dynamic_app/core/local/user/user_manager.dart' as _i537;
import 'package:dynamic_app/core/presentation/bloc/base_app/app_base_bloc.dart'
    as _i179;
import 'package:dynamic_app/core/presentation/bloc/bloc_observer_logger.dart'
    as _i168;
import 'package:dynamic_app/core/presentation/route/app_router.dart' as _i658;
import 'package:dynamic_app/core/presentation/route/initial_navigation_manager.dart'
    as _i659;
import 'package:dynamic_app/core/presentation/route/navigator_observer_logger.dart'
    as _i593;
import 'package:dynamic_app/core/style/app_color.dart' as _i355;
import 'package:dynamic_app/core/style/app_theme.dart' as _i792;
import 'package:dynamic_app/core/style/theme_service.dart' as _i87;
import 'package:dynamic_app/core/util/app_device_info_util.dart' as _i21;
import 'package:dynamic_app/core/util/crypto/encrypt_helper.dart' as _i719;
import 'package:dynamic_app/core/util/crypto/keystore_gcm_crypto_helper.dart'
    as _i937;
import 'package:dynamic_app/core/util/currency_manager.dart' as _i432;
import 'package:dynamic_app/core/util/shared_preferences_helper.dart' as _i508;
import 'package:dynamic_app/di/injection_container.dart' as _i244;
import 'package:dynamic_app/feature/home_tabs/presentation/bloc/home_bloc.dart'
    as _i634;
import 'package:dynamic_app/infrastructure/broadcast/broadcast_manager.dart'
    as _i806;
import 'package:dynamic_app/infrastructure/network/dio_caller.dart' as _i1054;
import 'package:dynamic_app/infrastructure/network/util/headers_interceptor.dart'
    as _i673;
import 'package:dynamic_app/infrastructure/network/util/network_util.dart'
    as _i905;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;
import 'package:package_info_plus/package_info_plus.dart' as _i655;
import 'package:pretty_dio_logger/pretty_dio_logger.dart' as _i528;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> $initGetIt({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final networkModule = _$NetworkModule();
    final injectableModule = _$InjectableModule();
    gh.factory<_i528.PrettyDioLogger>(() => networkModule.prettyDioLogger);
    await gh.factoryAsync<_i833.BaseDeviceInfo>(
      () => injectableModule.deviceInfo,
      preResolve: true,
    );
    await gh.factoryAsync<_i655.PackageInfo>(
      () => injectableModule.packageInfo,
      preResolve: true,
    );
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => injectableModule.sharedPreferences,
      preResolve: true,
    );
    gh.factory<_i634.HomeBloc>(() => _i634.HomeBloc());
    gh.singleton<_i432.CurrencyManager>(() => _i432.CurrencyManager());
    gh.lazySingleton<_i1011.Assets>(() => _i1011.Assets());
    gh.lazySingleton<_i954.Configs>(() => _i954.Configs());
    gh.lazySingleton<_i376.Strings>(() => _i376.Strings());
    gh.lazySingleton<_i658.AppRouter>(() => _i658.AppRouter());
    gh.lazySingleton<_i355.AppColors>(() => _i355.AppColors());
    gh.lazySingleton<_i719.EncryptHelper>(() => _i719.EncryptHelper());
    gh.lazySingleton<_i937.KeystoreGcmCryptoHelper>(
        () => _i937.KeystoreGcmCryptoHelper());
    gh.lazySingleton<_i974.Logger>(() => networkModule.logger);
    gh.lazySingleton<_i806.BroadcastManager>(() => _i806.BroadcastManager());
    gh.lazySingleton<_i673.HeadersInterceptor>(
        () => _i673.HeadersInterceptor(isAddTestData: gh<bool>()));
    gh.factory<_i508.SharedPreferencesHelper>(
        () => _i508.SharedPreferencesHelper(
              encryptHelper: gh<_i719.EncryptHelper>(),
              sharePrefs: gh<_i460.SharedPreferences>(),
            ));
    gh.factory<_i906.SettingsManager>(
        () => _i906.SettingsManager(gh<_i508.SharedPreferencesHelper>()));
    gh.factory<_i87.ThemeService>(
        () => _i87.ThemeService(gh<_i906.SettingsManager>()));
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.provideIranCellDio(gh<_i528.PrettyDioLogger>()),
      instanceName: 'digikala',
    );
    gh.lazySingleton<_i168.BlocObserverLogger>(
        () => _i168.BlocObserverLogger(logger: gh<_i974.Logger>()));
    gh.lazySingleton<_i593.NavigatorObserverLogger>(
        () => _i593.NavigatorObserverLogger(logger: gh<_i974.Logger>()));
    gh.lazySingleton<_i1054.DioCaller>(
      () => networkModule
          .provideCryptoDioCaller(gh<_i361.Dio>(instanceName: 'digikala')),
      instanceName: 'digikala',
    );
    gh.lazySingleton<_i537.UserManager>(
        () => _i537.UserManager(gh<_i906.SettingsManager>()));
    gh.lazySingleton<_i179.AppBaseBloc>(
        () => _i179.AppBaseBloc(gh<_i906.SettingsManager>()));
    gh.factory<_i792.AppTheme>(
        () => _i792.AppTheme(appColors: gh<_i355.AppColors>()));
    gh.factory<_i21.AppDeviceInfoUtil>(() => _i21.AppDeviceInfoUtil(
          gh<_i833.BaseDeviceInfo>(),
          gh<_i655.PackageInfo>(),
          gh<_i906.SettingsManager>(),
        ));
    gh.factory<_i659.InitialNavigationManager>(
        () => _i659.InitialNavigationManager(
              gh<_i658.AppRouter>(),
              gh<_i537.UserManager>(),
            ));
    gh.lazySingleton<_i905.NetworkUtils>(
      () => _i905.NetworkUtils(
        gh<_i21.AppDeviceInfoUtil>(),
        gh<_i906.SettingsManager>(),
      ),
      dispose: _i905.disposeNetworkUtils,
    );
    return this;
  }
}

class _$NetworkModule extends _i244.NetworkModule {}

class _$InjectableModule extends _i244.InjectableModule {}
