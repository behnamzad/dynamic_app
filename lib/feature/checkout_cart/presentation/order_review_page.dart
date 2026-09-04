import 'package:dynamic_app/core/presentation/widget/app/cart_product_widget.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/checkout_cart/presentation/bloc/checkout_cart_bloc.dart';
import 'package:dynamic_app/feature/checkout_cart/presentation/widget/checkout_row.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_payload.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_type.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_product_snapshot.dart';
import 'package:dynamic_app/shared/behavior/domain/factory/behavior_event_draft_factory.dart';
import 'package:dynamic_app/shared/behavior/domain/manager/behavior_logger.dart';
import 'package:dynamic_app/shared/cart/domain/entities/cart_product_entity.dart';
import 'package:dynamic_app/shared/orders/domain/entities/order_entity.dart';

@RoutePage()
class OrderReviewPage extends StatefulWidget implements AutoRouteWrapper {
  final CheckoutCartBloc checkoutCartBloc;

  const OrderReviewPage({super.key, required this.checkoutCartBloc});

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider.value(value: checkoutCartBloc, child: this);

  @override
  State<OrderReviewPage> createState() => _OrderReviewPageState();
}

class _OrderReviewPageState extends State<OrderReviewPage> {
  late final BehaviorLogger _behaviorLogger;
  List<CartProductEntity> _pendingPurchaseProducts = const <CartProductEntity>[];

  @override
  void initState() {
    super.initState();
    _behaviorLogger = inject<BehaviorLogger>();
    _behaviorLogger.recordNonBlocking(
      BehaviorEventDraftFactory.checkout(
        type: BehaviorEventType.checkoutStepViewed,
        sourceScreen: 'order_review',
        payload: const CheckoutBehaviorPayload(stepName: 'order_review', stepIndex: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutCartBloc, CheckoutCartState>(
      listener: (context, state) {
        if (state.feedback == CheckoutCartFeedback.orderPlaced) {
          final order = state.placedOrder;
          if (order != null) {
            _recordPurchaseSuccess(order, _pendingPurchaseProducts);
          }
          _pendingPurchaseProducts = const <CartProductEntity>[];
          showToastSuccess(ss.orderPaymentSuccess);
          context.router.popUntilRoot();
        } else if (state.feedback == CheckoutCartFeedback.error && state.errorMessage != null) {
          _recordPurchaseFailure(state);
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
                onPressed: () {
                  _pendingPurchaseProducts = List<CartProductEntity>.unmodifiable(state.cart.products);
                  _recordPaymentAttempt(state.cart.products);
                  context.read<CheckoutCartBloc>().add(
                    CheckoutCartEvent.placeOrder(deliveryWindow: ss.checkoutDeliveryWindow),
                  );
                },
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
              CheckoutRow(title: ss.checkoutDeliveryWindow, icon: Icons.access_time_outlined),
              const VGap(22),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BzText(ss.orderProductsCount(state.cartTotals.productCount), style: context.title1Bold),
                    BzTextCurrency.amountWithTitle(
                      amount: state.cartTotals.totalAmount,
                      style: context.title1Bold.copyWith(color: context.scheme().primary),
                    ),
                  ],
                ),
              ),
              const VGap(8),
              ...state.cart.products.map((product) => CartProductWidget(product: product)),
            ],
          ),
        );
      },
    );
  }

  void _recordPaymentAttempt(List<CartProductEntity> products) {
    _behaviorLogger.recordNonBlocking(
      BehaviorEventDraftFactory.checkout(
        type: BehaviorEventType.paymentAttempted,
        sourceScreen: 'order_review',
        payload: CheckoutBehaviorPayload(
          stepName: 'payment',
          stepIndex: 2,
          productIds: products.map((product) => product.productId.toString()).toList(growable: false),
          productSnapshots: products.map(_cartSnapshot).toList(growable: false),
          quantities: <String, int>{for (final product in products) product.productId.toString(): product.quantity},
        ),
      ),
    );
  }

  void _recordPurchaseSuccess(OrderEntity order, List<CartProductEntity> purchasedCartProducts) {
    _behaviorLogger.recordNonBlocking(
      BehaviorEventDraftFactory.checkout(
        type: BehaviorEventType.purchaseSucceeded,
        sourceScreen: 'order_review',
        status: 'succeeded',
        payload: CheckoutBehaviorPayload(
          stepName: 'purchase',
          stepIndex: 2,
          outcome: 'succeeded',
          productIds: order.items.map((item) => item.productId.toString()).toList(growable: false),
          productSnapshots: order.items
              .map(
                (item) => BehaviorProductSnapshot(
                  productId: item.productId.toString(),
                  productName: item.productName,
                  productTitle: item.productName,
                  categoryId: item.categoryId.toString(),
                ),
              )
              .toList(growable: false),
          quantities: <String, int>{for (final item in order.items) item.productId.toString(): item.quantity},
        ),
      ),
    );
    final Set<int> purchasedProductIds = order.items.map((item) => item.productId).toSet();
    for (final CartProductEntity product in purchasedCartProducts) {
      final attribution = product.recommendationAttribution;
      if (attribution == null || (purchasedProductIds.isNotEmpty && !purchasedProductIds.contains(product.productId))) {
        continue;
      }
      _behaviorLogger.recordNonBlocking(
        BehaviorEventDraftFactory.recommendation(
          type: BehaviorEventType.recommendationPurchase,
          product: attribution.productSnapshot,
          sourceScreen: 'order_review',
          position: attribution.displayRank,
          payload: RecommendationBehaviorPayload(
            requestId: attribution.requestId,
            selectedProductId: product.productId.toString(),
            displayRank: attribution.displayRank,
            displaySlot: attribution.displaySlot,
            strategy: attribution.strategy,
            modelVersion: attribution.modelVersion,
            nextAction: 'purchase',
            confidence: attribution.confidence,
          ),
        ),
      );
    }
  }

  void _recordPurchaseFailure(CheckoutCartState state) {
    final products = state.cart.products;
    _behaviorLogger.recordNonBlocking(
      BehaviorEventDraftFactory.checkout(
        type: BehaviorEventType.purchaseFailed,
        sourceScreen: 'order_review',
        status: 'failed',
        payload: CheckoutBehaviorPayload(
          stepName: 'purchase',
          stepIndex: 2,
          outcome: 'failed',
          failureCode: 'order_request_failed',
          productIds: products.map((product) => product.productId.toString()).toList(growable: false),
          productSnapshots: products.map(_cartSnapshot).toList(growable: false),
          quantities: <String, int>{for (final product in products) product.productId.toString(): product.quantity},
        ),
      ),
    );
  }

  BehaviorProductSnapshot _cartSnapshot(CartProductEntity product) {
    return BehaviorProductSnapshot(
      productId: product.productId.toString(),
      productName: product.productName,
      productTitle: product.productName,
      categoryId: product.categoryId.toString(),
    );
  }
}
