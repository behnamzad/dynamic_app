import 'package:dynamic_app/core/presentation/widget/app/cart_product_widget.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/core/util/extension/string_ext.dart';
import 'package:dynamic_app/feature/cart/presentation/bloc/cart_bloc.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_payload.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_type.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_product_snapshot.dart';
import 'package:dynamic_app/shared/behavior/domain/factory/behavior_event_draft_factory.dart';
import 'package:dynamic_app/shared/behavior/domain/manager/behavior_logger.dart';
import 'package:dynamic_app/shared/orders/domain/entities/order_entity.dart';

@RoutePage()
class CartPage extends StatefulWidget implements AutoRouteWrapper {
  const CartPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocProvider(create: (_) => inject<CartBloc>()..add(const CartEvent.initialize()), child: this);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _showOrders = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      listener: (context, state) {
        if (state.feedback == CartFeedback.error && state.errorMessage != null) {
          showToastError(state.errorMessage!);
        }
      },
      builder: (context, state) => BasePageWidget(
        appBar: BzAppBar(title: ss.cart),
        bottomNav: !_showOrders && state.cart.products.isNotEmpty ? _checkoutButton(context, state) : null,
        child: Column(
          children: [
            _sectionSelector(context),
            Expanded(child: _showOrders ? _orders(context, state) : _cart(context, state)),
          ],
        ),
      ),
    );
  }

  Widget _sectionSelector(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(child: _sectionButton(context, ss.cart, !_showOrders, () => setState(() => _showOrders = false))),
          const HGap(8),
          Expanded(child: _sectionButton(context, ss.orders, _showOrders, () => _openOrders(context))),
        ],
      ),
    );
  }

  Widget _sectionButton(BuildContext context, String title, bool selected, VoidCallback onTap) {
    return BzButton.outline(
      text: title,
      backgroundColor: selected ? context.scheme().primary2 : Colors.transparent,
      borderColor: selected ? context.scheme().primary : context.scheme().divider,
      onPressed: onTap,
    );
  }

  void _openOrders(BuildContext context) {
    if (_showOrders) {
      return;
    }
    setState(() => _showOrders = true);
    context.read<CartBloc>().add(const CartEvent.loadOrders());
  }

  Widget _cart(BuildContext context, CartState state) {
    if (state.status.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.cart.products.isEmpty) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BzText(ss.cartProductsCount(state.cartTotals.productCount)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: state.cart.products.length,
            itemBuilder: (context, index) => CartProductWidget(product: state.cart.products[index]),
          ),
        ),
      ],
    );
  }

  Widget _orders(BuildContext context, CartState state) {
    if (state.ordersLoading || state.status.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.orders.isEmpty) {
      return Center(child: BzText(ss.noOrders, style: context.body1Bold));
    }
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CartBloc>().add(const CartEvent.loadOrders());
      },
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        itemCount: state.orders.length,
        separatorBuilder: (_, __) => const VGap(12),
        itemBuilder: (context, index) => _orderCard(context, state.orders[index]),
      ),
    );
  }

  Widget _orderCard(BuildContext context, OrderEntity order) {
    final date = order.createdAt == null ? '' : Jalali.fromDateTime(order.createdAt!.toLocal()).yearMonthDay();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.scheme().mainBackground2,
        borderRadius: Dimen.defaultBorderRadius,
        border: Border.all(color: context.scheme().divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_shipping_outlined, color: context.scheme().primary),
              const HGap(8),
              Expanded(child: BzText(order.status.title, style: context.body1Bold)),
              if (date.isNotEmpty) BzText(date, style: context.body2Regular),
            ],
          ),
          const VGap(10),
          BzText(ss.cartProductsCount(order.totalQuantity), style: context.body2Regular),
          const VGap(4),
          BzText(ss.fullAddress(order.province, order.city, order.addressLine), style: context.body2Regular),
          const VGap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BzText(order.isPaid ? ss.paid : ss.unpaid, style: context.body2Bold),
              BzTextCurrency.amountWithTitle(
                amount: order.totalAmount,
                style: context.body1Bold.copyWith(color: context.scheme().primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _checkoutButton(BuildContext context, CartState state) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BzButton.submit(
          text: ss.continueToByProcess,
          onPressed: () async {
            final products = state.cart.products;
            inject<BehaviorLogger>().recordNonBlocking(
              BehaviorEventDraftFactory.checkout(
                type: BehaviorEventType.checkoutStarted,
                sourceScreen: 'cart',
                payload: CheckoutBehaviorPayload(
                  stepName: 'address_and_delivery',
                  stepIndex: 0,
                  productIds: products.map((product) => product.productId.toString()).toList(growable: false),
                  productSnapshots: products
                      .map(
                        (product) => BehaviorProductSnapshot(
                          productId: product.productId.toString(),
                          productName: product.productName,
                          productTitle: product.productName,
                          categoryId: product.categoryId.toString(),
                        ),
                      )
                      .toList(growable: false),
                  quantities: <String, int>{
                    for (final product in products) product.productId.toString(): product.quantity,
                  },
                ),
              ),
            );
            await context.pushRoute(const CheckOutPageRoute());
            if (context.mounted) {
              context.read<CartBloc>().add(const CartEvent.initialize());
            }
          },
        ),
      ),
    );
  }
}
