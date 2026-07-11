import 'package:dynamic_app/app/custom_navigation_observer.dart';
import 'package:dynamic_app/app/route/navigator_observer_logger.dart';
import 'package:dynamic_app/core/presentation/bloc/base_app/app_base_bloc.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:logger/logger.dart';
import 'package:overlay_support/overlay_support.dart';

class App extends StatefulWidget {
  final AppTheme appTheme;
  static final GlobalKey publicKey = GlobalKey();
  final ThemeService themeService;
  final AppRouter appRouter;
  final NavigatorObserverLogger navigatorObserverLogger;

  const App(
      {super.key,
      required this.appTheme,
      required this.themeService,
      required this.appRouter,
      required this.navigatorObserverLogger,});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  ThemeMode? themeMode;
  final ValueNotifier<bool> isThemeChangeNotify = ValueNotifier(false);

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
                title: ss.storeName,
                debugShowCheckedModeBanner: false,
                theme: widget.appTheme.appThemeLight(context),
                darkTheme: widget.appTheme.appThemeDark(context),
                themeMode: themeMode ?? widget.themeService.themeMode,
                routerDelegate: widget.appRouter.delegate(
                    navigatorObservers: () => [
                          CustomNavigatorObserver(onScreenChange: (routeName) {}),
                          NavigatorObserverLogger(logger: inject<Logger>()),
                        ],),
                routeInformationProvider: widget.appRouter.routeInfoProvider(),
                routeInformationParser: widget.appRouter.defaultRouteParser(),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    isThemeChangeNotify.dispose();
    super.dispose();
  }
}
