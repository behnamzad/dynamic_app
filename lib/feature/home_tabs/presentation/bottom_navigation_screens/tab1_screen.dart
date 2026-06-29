import 'package:auto_route/auto_route.dart';
import 'package:dynamic_app/core/presentation/widget/bz_appbar.dart';
import 'package:dynamic_app/core/presentation/widget/base/base_page_widget.dart';
import 'package:dynamic_app/feature/home_shop/presentation/home_shop_page.dart';
import 'package:flutter/material.dart';

@RoutePage()
class Tab1Screen extends StatelessWidget {
  const Tab1Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasePageWidget(
        appBar: BzAppBar(
          title: 'profile',
        ),
        child: SizedBox());
  }
}
