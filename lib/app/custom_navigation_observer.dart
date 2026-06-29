import 'package:flutter/material.dart';

class CustomNavigatorObserver extends NavigatorObserver {
  Function(String) onScreenChange;

  CustomNavigatorObserver({required this.onScreenChange});

  @override
  void didPop(Route route, Route? previousRoute) {
    try {
      if (previousRoute != null && previousRoute.settings.name != '') {
        var isModal = route is ModalBottomSheetRoute || route is DialogRoute;
        if (!isModal) onScreenChange(previousRoute.settings.name ?? '');
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    try {
      if (route.settings.name != null) {
        // if (route != null) {
        var isModal = route is ModalBottomSheetRoute || route is DialogRoute;
        if (!isModal) onScreenChange(route.settings.name ?? '');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    super.didPush(route, previousRoute);
  }
}
