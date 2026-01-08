import 'package:auto_route/auto_route.dart';
import 'package:dynamic_app/feature/home_tabs/home_page.dart';
import 'package:dynamic_app/feature/home_tabs/presentation/bottom_navigation_screens/tab1_screen.dart';
import 'package:dynamic_app/feature/home_tabs/presentation/bottom_navigation_screens/tab2_screen.dart';
import 'package:dynamic_app/feature/home_tabs/presentation/bottom_navigation_screens/tab3_screen.dart';
import 'package:dynamic_app/feature/home_tabs/presentation/bottom_navigation_screens/tab4_screen.dart';
import 'package:dynamic_app/feature/splash/presentation/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Page,Route,Screen',
)
@lazySingleton
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();
  @override
  final List<AutoRoute> routes = [
    AutoRoute(path: '/', page: SplashPageRoute.page),

    // home bottom navigation
    AutoRoute(
      path: '/HomePage',
      page: HomePageRoute.page,
      children: [
        AutoRoute(path: 'tab1', page: Tab1ScreenRoute.page),
        AutoRoute(path: 'tab2', page: Tab2ScreenRoute.page),
        AutoRoute(path: 'tab3', page: Tab3ScreenRoute.page),
        AutoRoute(path: 'tab4', page: Tab4ScreenRoute.page, initial: true),
      ],
    )
  ];
}
import 'package:tflite_flutter/tflite_flutter.dart';

class PurchasePredictor {
  Interpreter? _interpreter;

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/models/purchase_model.tflite');
  }

  Future<double> predict(Map<String, dynamic> features) async {
    // فرمت ورودی: [pageViews, timeSpent, clicks, ageGroup, ...]
    var input = [
      features['pageViews']?.toDouble() ?? 0.0,
      features['timeSpent']?.toDouble() ?? 0.0,
      features['clicks']?.toDouble() ?? 0.0,
      features['ageGroup']?.toDouble() ?? 0.0,
    ];
    var output = List<double>.filled(1, 0.0).reshape([1, 1]);
    _interpreter?.run(input, output);
    return output[0][0]; // احتمال خرید
  }
}