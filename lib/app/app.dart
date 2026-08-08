import 'package:dynamic_app/app/custom_navigation_observer.dart';
import 'package:dynamic_app/app/route/navigator_observer_logger.dart';
import 'package:dynamic_app/core/presentation/bloc/base_app/app_base_bloc.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_payload.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_type.dart';
import 'package:dynamic_app/shared/behavior/domain/manager/behavior_logger.dart';
import 'package:dynamic_app/shared/behavior/domain/manager/behavior_session_manager.dart';
import 'package:dynamic_app/shared/behavior/domain/manager/behavior_sync_coordinator.dart';
import 'package:overlay_support/overlay_support.dart';

class App extends StatefulWidget {
  final AppTheme appTheme;
  static final GlobalKey publicKey = GlobalKey();
  final ThemeService themeService;
  final AppRouter appRouter;
  final NavigatorObserverLogger navigatorObserverLogger;

  const App({
    super.key,
    required this.appTheme,
    required this.themeService,
    required this.appRouter,
    required this.navigatorObserverLogger,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  ThemeMode? themeMode;
  final ValueNotifier<bool> isThemeChangeNotify = ValueNotifier(false);
  late final BehaviorLogger _behaviorLogger;
  late final BehaviorSessionManager _sessionManager;
  late final BehaviorSyncCoordinator _syncCoordinator;
  bool _isBackgrounded = false;
  Future<void> _lifecycleTransition = Future<void>.value();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _behaviorLogger = inject<BehaviorLogger>();
    _sessionManager = inject<BehaviorSessionManager>();
    _syncCoordinator = inject<BehaviorSyncCoordinator>()..start();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        if (!_isBackgrounded) {
          _isBackgrounded = true;
          _queueLifecycleTransition(() => _moveToBackground(state.name));
        }
      case AppLifecycleState.resumed:
        if (_isBackgrounded) {
          _isBackgrounded = false;
          _queueLifecycleTransition(_moveToForeground);
        }
      case AppLifecycleState.inactive:
        break;
    }
  }

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
                    widget.navigatorObserverLogger,
                  ],
                ),
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
    WidgetsBinding.instance.removeObserver(this);
    _syncCoordinator.stop();
    isThemeChangeNotify.dispose();
    super.dispose();
  }

  Future<void> _moveToBackground(String reason) async {
    _syncCoordinator.stop();
    final now = DateTime.now().toUtc();
    final duration = now.difference(_sessionManager.sessionStartedAt).inMilliseconds;
    try {
      await _behaviorLogger.record(
        BehaviorEventDraft(
          type: BehaviorEventType.appBackground,
          sourceScreen: 'app',
          payload: LifecycleBehaviorPayload(reason: reason, sessionDurationMs: duration),
        ),
      );
      await _behaviorLogger.record(
        BehaviorEventDraft(
          type: BehaviorEventType.sessionEnd,
          sourceScreen: 'app',
          payload: LifecycleBehaviorPayload(reason: reason, sessionDurationMs: duration),
        ),
      );
    } finally {
      await _sessionManager.endSession(now: now);
    }
  }

  Future<void> _moveToForeground() async {
    await _sessionManager.startNewSession();
    try {
      await _behaviorLogger.record(
        const BehaviorEventDraft(
          type: BehaviorEventType.appForeground,
          sourceScreen: 'app',
          payload: LifecycleBehaviorPayload(reason: 'app_resumed'),
        ),
      );
      await _behaviorLogger.record(
        const BehaviorEventDraft(
          type: BehaviorEventType.sessionStart,
          sourceScreen: 'app',
          payload: LifecycleBehaviorPayload(reason: 'app_foreground'),
        ),
      );
    } finally {
      _syncCoordinator.start();
    }
  }

  void _queueLifecycleTransition(Future<void> Function() transition) {
    _lifecycleTransition = _lifecycleTransition.then((_) => transition()).catchError((Object error, StackTrace stack) {
      debugPrint('Behavior lifecycle transition failed: $error');
      debugPrintStack(stackTrace: stack);
    });
  }
}
