import 'package:auto_route/auto_route.dart';
import 'package:dynamic_app/feature/cart/presentation/cart_page.dart';
import 'package:dynamic_app/feature/checkout_cart/presentation/bloc/checkout_cart_bloc.dart';
import 'package:dynamic_app/feature/checkout_cart/presentation/check_out_page.dart';
import 'package:dynamic_app/feature/checkout_cart/presentation/order_review_page.dart';
import 'package:dynamic_app/feature/home_shop/presentation/home_shop_page.dart';
import 'package:dynamic_app/feature/home_tabs/home_page.dart';
import 'package:dynamic_app/feature/home_tabs/presentation/bottom_navigation_screens/tab1_screen.dart';
import 'package:dynamic_app/feature/home_tabs/presentation/bottom_navigation_screens/tab2_screen.dart';
import 'package:dynamic_app/feature/home_tabs/presentation/bottom_navigation_screens/tab3_screen.dart';
import 'package:dynamic_app/feature/home_tabs/presentation/bottom_navigation_screens/tab4_screen.dart';
import 'package:dynamic_app/feature/login/presentation/login_page.dart';
import 'package:dynamic_app/feature/product_info/presentation/product_info_page.dart';
import 'package:dynamic_app/feature/search/presentation/bloc/search_bloc.dart';
import 'package:dynamic_app/feature/search/presentation/product_list_page.dart';
import 'package:dynamic_app/feature/splash/presentation/splash_page.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/recommendation_attribution.dart';
import 'package:dynamic_app/shared/category/domain/entities/category_entity.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route,Screen')
@lazySingleton
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();
  @override
  final List<AutoRoute> routes = [
    AutoRoute(path: '/', page: SplashPageRoute.page),
    AutoRoute(path: '/LoginPageRoute', page: LoginPageRoute.page),

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
    ),

    AutoRoute(path: '/HomeShopPage', page: HomeShopPageRoute.page),
    AutoRoute(path: '/LoginPage', page: LoginPageRoute.page),
    AutoRoute(path: '/ProductListPage', page: ProductListPageRoute.page),
    AutoRoute(path: '/ProductInfoPage', page: ProductInfoPageRoute.page),
    AutoRoute(path: '/CartPage', page: CartPageRoute.page),
    AutoRoute(path: '/CheckOutPage', page: CheckOutPageRoute.page),
    AutoRoute(path: '/OrderReviewPage', page: OrderReviewPageRoute.page),
  ];
}
