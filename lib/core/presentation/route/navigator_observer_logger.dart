import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@lazySingleton
class NavigatorObserverLogger extends AutoRouterObserver {
  NavigatorObserverLogger({required this.logger});

  final Logger logger;

  @override
  void didPop(Route route, Route? previousRoute) {
    if (kDebugMode) {
      _log('didPop ${_str(route)} '
          'previous=${_str(previousRoute)},');
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    if (kDebugMode) {
      _log('didPush ${_str(route)} '
          'previous=${_str(previousRoute)},');
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    if (kDebugMode) {
      _log('didRemove ${_str(route)} '
          'previous=${_str(previousRoute)},');
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
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
}
