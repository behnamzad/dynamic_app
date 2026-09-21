import 'package:carousel_slider/carousel_controller.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/product_info/presentation/bloc/product_info_bloc.dart';
import 'package:dynamic_app/feature/product_info/presentation/tracking/product_info_behavior_tracker.dart';
import 'package:dynamic_app/feature/product_info/presentation/widget/product_cart_bar.dart';
import 'package:dynamic_app/feature/product_info/presentation/widget/product_info_content.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/recommendation_attribution.dart';
import 'package:dynamic_app/shared/behavior/domain/manager/behavior_logger.dart';
import 'package:dynamic_app/shared/cart/domain/manager/cart_manager.dart';
import 'package:dynamic_app/shared/personalization/domain/entities/personalization_decision.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';

@RoutePage()
class ProductInfoPage extends StatefulWidget implements AutoRouteWrapper {
  const ProductInfoPage({
    super.key,
    required this.product,
    this.recommendationAttribution,
  });

  final ProductEntity product;
  final RecommendationAttribution? recommendationAttribution;

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => inject<ProductInfoBloc>()
        ..init(
          productId: product.id,
          personalizationEnabled: recommendationAttribution == null,
        ),
      child: this,
    );
  }

  @override
  State<ProductInfoPage> createState() => _ProductInfoPageState();
}

class _ProductInfoPageState extends State<ProductInfoPage> {
  late ProductEntity _product;
  late final CarouselSliderController _imageSliderController;
  late final ProductInfoBehaviorTracker _behaviorTracker;

  // region Setup and lifecycle

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    _imageSliderController = CarouselSliderController();
    _behaviorTracker = ProductInfoBehaviorTracker(
      behaviorLogger: inject<BehaviorLogger>(),
      cartManager: inject<CartManager>(),
      initialProduct: _product,
      incomingRecommendation: widget.recommendationAttribution,
    );
  }

  @override
  void dispose() {
    _behaviorTracker.recordPageClosed();
    super.dispose();
  }

  // endregion

  // region Bloc connection

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductInfoBloc, ProductInfoState>(
      listenWhen: _shouldHandleStateChange,
      listener: _handleStateChange,
      builder: (BuildContext context, ProductInfoState state) {
        final int cartQuantity =
            inject<CartManager>().findProduct(_product.id)?.quantity ?? 0;
        return BasePageWidget.withOnScreenAndOverLayLoading(
          resizeToAvoidBottomInset: false,
          onScreenLoadingModeShowFailureByState: state.status.isFailed,
          onScreenLoadingModeShowCircularLoadingByState: state.status.isLoading,
          onScreenLoadingOnTryAgainCLick: () => context
              .read<ProductInfoBloc>()
              .add(ProductInfoEvent.init(productId: widget.product.id)),
          bottomNav: state.status.isLoaded
              ? ProductCartBar(
                  product: _product,
                  state: state,
                  quantity: cartQuantity,
                  onAddOne: _addOneToCart,
                  onRemoveOne: _removeOneFromCart,
                )
              : null,
          child: state.status.isLoaded
              ? ProductInfoContent(
                  product: _product,
                  state: state,
                  carouselController: _imageSliderController,
                  onClose: () => context.maybePop(),
                  onImageChanged: _behaviorTracker.recordImageChanged,
                  onScroll: _behaviorTracker.recordScrollDepth,
                )
              : const SizedBox(),
        );
      },
    );
  }

  bool _shouldHandleStateChange(
    ProductInfoState previous,
    ProductInfoState current,
  ) {
    return previous.status != current.status ||
        previous.cartActionStatus != current.cartActionStatus ||
        previous.personalizationDecision?.decisionId !=
            current.personalizationDecision?.decisionId;
  }

  void _handleStateChange(BuildContext context, ProductInfoState state) {
    if (state.status.isFailed && state.errorMessage != null) {
      showToastError(
        state.errorMessage!,
        bottomPadding: Dimen.bottomToastPadding,
      );
    }

    final ProductEntity? loadedProduct = state.productEntity;
    if (state.status.isLoaded && loadedProduct != null) {
      _product = loadedProduct;
      _behaviorTracker
        ..updateProduct(loadedProduct)
        ..recordPageOpenedOnce();
    }

    _showCartFeedback(state);
    if (state.personalizationStatus.isReady) {
      _handlePersonalizationReady(state);
    }
  }

  void _showCartFeedback(ProductInfoState state) {
    switch (state.cartActionStatus) {
      case CartActionStatus.added:
        _behaviorTracker.recordCartChangeResult(succeeded: true);
        showToastSuccess(ss.productAddedToCart);
      case CartActionStatus.removed:
        _behaviorTracker.recordCartChangeResult(succeeded: true);
        if (!state.isInCart) {
          showToastSuccess(ss.productRemovedFromCart);
        }
      case CartActionStatus.failed:
        _behaviorTracker.recordCartChangeResult(succeeded: false);
        showToastError(state.errorMessage ?? ss.cartOperationError);
      case CartActionStatus.initial:
      case CartActionStatus.loading:
        break;
    }
  }

  // endregion

  // region User actions

  void _addOneToCart(int currentQuantity) {
    _behaviorTracker.startCartChange(
      currentQuantity: currentQuantity,
      isAdding: true,
    );
    context.read<ProductInfoBloc>().add(
      ProductInfoEvent.addToCart(
        _product,
        recommendationAttribution: currentQuantity == 0
            ? widget.recommendationAttribution
            : null,
      ),
    );
  }

  void _removeOneFromCart(int currentQuantity) {
    _behaviorTracker.startCartChange(
      currentQuantity: currentQuantity,
      isAdding: false,
    );
    context.read<ProductInfoBloc>().add(
      ProductInfoEvent.removeFromCart(_product.id),
    );
  }

  // endregion

  // region Personalization

  void _handlePersonalizationReady(ProductInfoState state) {
    final PersonalizationDecision? decision = state.personalizationDecision;
    if (decision == null) return;

    _behaviorTracker.recordPersonalization(
      decision: decision,
      suggestions: state.alternativeProductSuggestions,
      recommendationStrategy: state.recommendationStrategy,
    );
  }

  // endregion
}
