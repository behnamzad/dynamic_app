import 'package:auto_route/auto_route.dart';
import 'package:dynamic_app/di/injection_container.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_payload.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_type.dart';
import 'package:dynamic_app/shared/behavior/domain/factory/behavior_event_draft_factory.dart';
import 'package:dynamic_app/shared/behavior/domain/manager/behavior_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@lazySingleton
class NavigatorObserverLogger extends AutoRouterObserver {
  NavigatorObserverLogger({required this.logger});

  final Logger logger;
  final Map<Route<dynamic>, DateTime> _enteredAt = <Route<dynamic>, DateTime>{};

  BehaviorLogger get _behaviorLogger => inject<BehaviorLogger>();

  @override
  void didPop(Route route, Route? previousRoute) {
    final now = DateTime.now();
    final source = _routeName(route);
    if (source != null) {
      _recordScreenExit(route, now);
      final destination = _routeName(previousRoute);
      _behaviorLogger.recordNonBlocking(
        BehaviorEventDraftFactory.navigation(
          type: BehaviorEventType.backNavigation,
          sourceScreen: source,
          destinationScreen: destination,
          payload: NavigationBehaviorPayload(routeName: source, previousRouteName: destination),
        ),
      );
      if (previousRoute != null) {
        _recordScreenEnter(previousRoute, route, now);
      }
    }
    if (kDebugMode) {
      _log(
        'didPop ${_str(route)} '
        'previous=${_str(previousRoute)},',
      );
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    final now = DateTime.now();
    if (_routeName(route) != null) {
      if (previousRoute != null) {
        _recordScreenExit(previousRoute, now);
      }
      _recordRouteChanged(route, previousRoute);
      _recordScreenEnter(route, previousRoute, now);
    }
    if (kDebugMode) {
      _log(
        'didPush ${_str(route)} '
        'previous=${_str(previousRoute)},',
      );
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _recordScreenExit(route, DateTime.now());
    if (kDebugMode) {
      _log(
        'didRemove ${_str(route)} '
        'previous=${_str(previousRoute)},',
      );
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    final now = DateTime.now();
    if (newRoute != null && _routeName(newRoute) != null) {
      if (oldRoute != null) {
        _recordScreenExit(oldRoute, now);
      }
      _recordRouteChanged(newRoute, oldRoute);
      _recordScreenEnter(newRoute, oldRoute, now);
    }
    if (kDebugMode) {
      _log(
        'didReplace new=${_str(newRoute)} '
        'old=${_str(oldRoute)}',
      );
    }
  }

  @override
  void didStartUserGesture(Route route, Route? previousRoute) {
    if (kDebugMode) {
      _log(
        'didStartUserGesture ${_str(route)} '
        'previous=${_str(previousRoute)}',
      );
    }
  }

  @override
  void didStopUserGesture() {
    if (kDebugMode) {
      _log('didStopUserGesture');
    }
  }

  void _log(String message) {
    if (kDebugMode) {
      logger.i('ROUTE $message');
    }
  }

  String _str(Route? route) {
    final settings = route?.settings;
    if (settings != null) {
      final s = StringBuffer();
      s.write('{');
      s.write(settings.name);
      final args = settings.arguments;
      if (args != null) {
        s.write(', args=');
        s.write(args);
      }
      s.write('}');
      return s.toString();
    } else {
      return '{}';
    }
  }

  void _recordRouteChanged(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final routeName = _routeName(route);
    if (routeName == null) return;
    final previousName = _routeName(previousRoute);
    _behaviorLogger.recordNonBlocking(
      BehaviorEventDraftFactory.navigation(
        type: BehaviorEventType.routeChanged,
        sourceScreen: previousName ?? 'app',
        destinationScreen: routeName,
        referrerScreen: previousName,
        payload: NavigationBehaviorPayload(routeName: routeName, previousRouteName: previousName),
      ),
    );
  }

  void _recordScreenEnter(Route<dynamic> route, Route<dynamic>? previousRoute, DateTime now) {
    final routeName = _routeName(route);
    if (routeName == null) return;
    _enteredAt[route] = now;
    final previousName = _routeName(previousRoute);
    _behaviorLogger.recordNonBlocking(
      BehaviorEventDraftFactory.navigation(
        type: BehaviorEventType.screenEnter,
        sourceScreen: routeName,
        referrerScreen: previousName,
        payload: NavigationBehaviorPayload(routeName: routeName, previousRouteName: previousName),
      ),
    );
  }

  void _recordScreenExit(Route<dynamic> route, DateTime now) {
    final routeName = _routeName(route);
    if (routeName == null) return;
    final enteredAt = _enteredAt.remove(route);
    _behaviorLogger.recordNonBlocking(
      BehaviorEventDraftFactory.navigation(
        type: BehaviorEventType.screenExit,
        sourceScreen: routeName,
        durationMs: enteredAt == null ? null : now.difference(enteredAt).inMilliseconds,
        payload: NavigationBehaviorPayload(routeName: routeName),
      ),
    );
  }

  String? _routeName(Route<dynamic>? route) {
    final name = route?.settings.name?.trim();
    return name == null || name.isEmpty ? null : name;
  }
}
