import 'package:dynamic_app/core/mock_data/mock_data.dart';
import 'package:dynamic_app/core/presentation/widget/app/product_in_cart_widget.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_in_cart_entity.dart';

@RoutePage()
class CartPage extends StatefulWidget implements AutoRouteWrapper {
  const CartPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => this;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  //

  @override
  Widget build(BuildContext context) {
    return BasePageWidget(appBar: BzAppBar(title: ss.cart), child: _body(context));
  }

//region Widgets
  Widget _body(BuildContext context) {
    return Stack(
      children: [_totalProduct(context), _productList(context), _checkOutBtn(context)],
    );
  }

  Widget _productList(BuildContext context) {
    return Positioned.fill(
      top: 30,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: MockData().productInCartList().length,
          itemBuilder: (context, index) {
            ProductInCartEntity entity = MockData().productInCartList()[index];
            return ProductInCartWidget(productInCartEntity: entity, increaseCount: () {}, decreaseCount: () {});
          },),
    );
  }

  Widget _checkOutBtn(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: context.scheme().mainBackground1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                  flex: 3,
                  child: BzButton.submit(
                      text: ss.continueToByProcess, onPressed: () => context.pushRoute(const CheckOutPageRoute()),),),
              // Spacer(),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BzText(ss.totalCartAmount,
                            style: context.body3Medium.copyWith(color: context.scheme().subText),),
                        BzTextCurrency.amountWithTitle(
                          amount: int.parse('45800000'),
                          currencyUnitStyle: context.body3Medium.copyWith(color: context.scheme().primary),
                          style: context.headline5Bold.copyWith(color: context.scheme().primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _totalProduct(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          color: context.scheme().mainBackground1,
          child: BzText('${MockData().productInCartList().length} ${ss.product}'),
        ),
      ),
    );
  }
}
