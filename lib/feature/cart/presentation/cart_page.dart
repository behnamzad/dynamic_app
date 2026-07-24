import 'package:dynamic_app/core/presentation/widget/app/cart_product_widget.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/shared/cart/domain/manager/cart_manager.dart';

@RoutePage()
class CartPage extends StatefulWidget implements AutoRouteWrapper {
  const CartPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => this;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late final CartManager _cartManager;

  @override
  void initState() {
    super.initState();
    _cartManager = inject<CartManager>();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _cartManager,
      builder: (context, _) => BasePageWidget(
        appBar: BzAppBar(title: ss.cart),
        child: _body(context),
      ),
    );
  }

  //region Widgets
  Widget _body(BuildContext context) {
    return Stack(children: [_totalProduct(context), _productList(context), _checkOutBtn(context)]);
  }

  Widget _productList(BuildContext context) {
    return _cartManager.isEmptyCart
        ? _emptyList(context)
        : Positioned.fill(
            top: 30,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _cartManager.products.length,
              itemBuilder: (context, index) {
                return CartProductWidget(product: _cartManager.products[index]);
              },
            ),
          );
  }

  Widget _checkOutBtn(BuildContext context) {
    return _cartManager.isEmptyCart
        ? const SizedBox()
        : Align(
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
                        text: ss.continueToByProcess,
                        onPressed: () => context.pushRoute(const CheckOutPageRoute()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _totalProduct(BuildContext context) {
    return _cartManager.isEmptyCart
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                color: context.scheme().mainBackground1,
                child: BzText(ss.cartProductsCount(_cartManager.totalQuantity)),
              ),
            ),
          );
  }

  _emptyList(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, color: context.scheme().primary, size: 64),
          const VGap(18),
          BzText(ss.emptyCart, style: context.body1Bold.copyWith(color: context.scheme().mainText)),
        ],
      ),
    );
  }
}
