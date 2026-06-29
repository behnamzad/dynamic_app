import 'package:dynamic_app/core/presentation/widget/app/profile_row_widget.dart';
import 'package:dynamic_app/core/presentation/widget/bz_gesture_detector.dart';
import 'package:dynamic_app/core/presentation/widget/bz_slider_widget.dart';
import 'package:dynamic_app/core/presentation/widget/app/product_widget.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';
import 'package:dynamic_app/data_provider/user/domain/entities/user_entity.dart';
import 'package:flutter/cupertino.dart';

@RoutePage()
class ProductListPage extends StatelessWidget implements AutoRouteWrapper {
  final List<ProductEntity> products;

  const ProductListPage({super.key, required this.products});

  //
  // @override
  // Widget wrappedRoute(BuildContext context) => BlocProvider(
  //       create: (_) => inject<HomeShopBloc>(),
  //       child: this,
  //     );
  @override
  Widget wrappedRoute(BuildContext context) => this;

  @override
  Widget build(BuildContext context) {
    return BasePageWidget(
        appBar: const BzAppBar(
          title: 'category name',
        ),
        child: _body(context));
  }

//region Widgets
  Widget _body(BuildContext context) {
    return Column(
      children: [
        _productList(context),
      ],
    );
  }

  Widget _productList(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2, mainAxisExtent: Dimen.productCardHeight, crossAxisSpacing: 24),
          shrinkWrap: true,
          itemCount: products.length,
          itemBuilder: (context, index) {
            ProductEntity entity = products[index];
            return ProductWidget.row(entity: entity);
          }),
    );
  }

//endregion
// region Function

//endregion
}
