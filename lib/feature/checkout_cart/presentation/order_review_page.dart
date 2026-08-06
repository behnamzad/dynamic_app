import 'package:dynamic_app/core/presentation/widget/app/cart_product_widget.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/checkout_cart/presentation/bloc/checkout_cart_bloc.dart';
import 'package:dynamic_app/feature/checkout_cart/presentation/widget/checkout_row.dart';

@RoutePage()
class OrderReviewPage extends StatelessWidget implements AutoRouteWrapper {
  final CheckoutCartBloc checkoutCartBloc;

  const OrderReviewPage({super.key, required this.checkoutCartBloc});

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocProvider.value(value: checkoutCartBloc, child: this);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutCartBloc, CheckoutCartState>(
      listener: (context, state) {
        if (state.feedback == CheckoutCartFeedback.orderPlaced) {
          showToastSuccess(ss.orderPaymentSuccess);
          context.router.popUntilRoot();
        } else if (state.feedback == CheckoutCartFeedback.error &&
            state.errorMessage != null) {
          showToastError(state.errorMessage!);
        }
      },
      builder: (context, state) {
        final address = state.selectedAddress;
        return BasePageWidget(
          appBar: BzAppBar(title: ss.finalOrderReview),
          bottomNav: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: BzButton.submit(
                text: ss.paymentAndSet,
                showLoading: state.actionStatus.isLoading,
                enabled: address != null && state.cart.products.isNotEmpty,
                onPressed: () => context.read<CheckoutCartBloc>().add(
                  CheckoutCartEvent.placeOrder(
                    deliveryWindow: ss.checkoutDeliveryWindow,
                  ),
                ),
              ),
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              if (address != null)
                CheckoutRow(
                  title: ss.provinceAndCity(address.province, address.city),
                  subTitle: address.addressLine,
                  icon: Icons.location_on_outlined,
                ),
              const VGap(18),
              CheckoutRow(
                title: ss.checkoutDeliveryWindow,
                icon: Icons.access_time_outlined,
              ),
              const VGap(22),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BzText(
                      ss.orderProductsCount(state.cartTotals.productCount),
                      style: context.title1Bold,
                    ),
                    BzTextCurrency.amountWithTitle(
                      amount: state.cartTotals.totalAmount,
                      style: context.title1Bold.copyWith(
                        color: context.scheme().primary,
                      ),
                    ),
                  ],
                ),
              ),
              const VGap(8),
              ...state.cart.products.map(
                (product) => CartProductWidget(product: product),
              ),
            ],
          ),
        );
      },
    );
  }
}
