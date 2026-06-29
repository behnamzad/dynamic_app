import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/home_shop/presentation/home_shop_page.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class Tab4Screen extends StatelessWidget {
  const Tab4Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomeShopPage().wrappedRoute(context);
  }
}
