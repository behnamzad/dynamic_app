import 'package:dynamic_app/app/custom_navigation_observer.dart';
import 'package:dynamic_app/app/route/navigator_observer_logger.dart';
import 'package:dynamic_app/core/presentation/bloc/base_app/app_base_bloc.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:logger/logger.dart';
import 'package:overlay_support/overlay_support.dart';

class App extends StatelessWidget {
  final AppTheme appTheme;
  static final GlobalKey publicKey = GlobalKey();
  final ThemeService themeService;
  final AppRouter appRouter;
  final NavigatorObserverLogger navigatorObserverLogger;

  App(
      {super.key,
      required this.appTheme,
      required this.themeService,
      required this.appRouter,
      required this.navigatorObserverLogger,});

  ThemeMode? themeMode;
  ValueNotifier<bool> isThemeChangeNotify = ValueNotifier(false);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: BlocProvider(
        create: (_) => inject<AppBaseBloc>(),
        child: BlocListener<AppBaseBloc, AppBaseState>(
          listener: (context, state) async {
            if (state.themeStatus.isChangeThemeDone) {
              themeMode = state.themeMode;
              isThemeChangeNotify.value = !isThemeChangeNotify.value;
            }
          },
          child: ValueListenableBuilder(
            valueListenable: isThemeChangeNotify,
            builder: (BuildContext context, value, Widget? child) {
              return MaterialApp.router(
                title: ss.dynamicApp,
                debugShowCheckedModeBanner: false,
                theme: appTheme.appThemeLight(context),
                darkTheme: appTheme.appThemeDark(context),
                themeMode: themeMode ?? themeService.themeMode,
                routerDelegate: appRouter.delegate(
                    navigatorObservers: () => [
                          CustomNavigatorObserver(onScreenChange: (routeName) {}),
                          NavigatorObserverLogger(logger: inject<Logger>()),
                        ],),
                routeInformationProvider: appRouter.routeInfoProvider(),
                routeInformationParser: appRouter.defaultRouteParser(),
              );
            },
          ),
        ),
      ),
    );
  }
}
