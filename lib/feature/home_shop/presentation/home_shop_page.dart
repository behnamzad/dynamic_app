import 'package:dynamic_app/core/mock_data/mock_data.dart';
import 'package:dynamic_app/core/presentation/widget/app/profile_row_widget.dart';
import 'package:dynamic_app/core/presentation/widget/bz_gesture_detector.dart';
import 'package:dynamic_app/core/presentation/widget/bz_slider_widget.dart';
import 'package:dynamic_app/core/presentation/widget/app/product_widget.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';
import 'package:dynamic_app/data_provider/user/domain/entities/user_entity.dart';

@RoutePage()
class HomeShopPage extends StatelessWidget implements AutoRouteWrapper {
  const HomeShopPage({super.key});

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
    return BasePageWidget(appBar: const BzAppBar(), child: _body(context));
  }

//region Widgets
  Widget _body(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        _profileRow(context),
        const VGap(20),
        _sliderWidget(context),
        const VGap(20),
        _productList(context),
        const VGap(20),
        _productList(context),
      ],
    );
  }

  Widget _sliderWidget(BuildContext context) {
    return BzSlider(
      height: Dimen.miniCardHeight,
      itemList: List.generate(3, (index) => BzText('text $index')),
      // controller: sliderCtrl,
      enlargeFactor: 0.2,
      indicatorIntoSlider: true,
      showIndicator: false,
      onPageChanged: (int index) {
        // context.read<CardColorBloc>().add(CardColorEvent.colorChanged(color: state.colors[index]));
      },
    );
  }

  Widget _productList(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    BzText('product Category'),
                    const Spacer(),
                    BzGestureDetector(
                        onTap: () => context.pushRoute(ProductListPageRoute(products: MockData().products())),
                        child: BzText(
                          ss.seeMore,
                          style: context.title2Bold,
                        )),
                  ],
                ),
              ),
              Container(
                height: Dimen.productCardHeight,
                color: context.scheme().primaryBold,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: MockData().products().length,
                    itemBuilder: (context, index) {
                      ProductEntity entity = MockData().products()[index];
                      return ProductWidget.card(entity: entity);
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _profileRow(BuildContext context) {
    return ProfileRowWidget(entity: MockData().user());
  }

//endregion
// region Function

//endregion
}
