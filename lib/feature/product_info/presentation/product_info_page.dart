import 'package:carousel_slider/carousel_controller.dart';
import 'package:dynamic_app/core/presentation/widget/bz_info_chip.dart';
import 'package:dynamic_app/core/presentation/widget/bz_slider_widget.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/product_info/presentation/bloc/product_info_bloc.dart';
import 'package:dynamic_app/feature/product_info/presentation/widget/comment_card_widget.dart';
import 'package:dynamic_app/shared/behavior/data/mapper/product_behavior_snapshot_mapper.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_payload.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_type.dart';
import 'package:dynamic_app/shared/behavior/domain/factory/behavior_event_draft_factory.dart';
import 'package:dynamic_app/shared/behavior/domain/manager/behavior_logger.dart';
import 'package:dynamic_app/shared/cart/domain/manager/cart_manager.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';

@RoutePage()
class ProductInfoPage extends StatefulWidget implements AutoRouteWrapper {
  final ProductEntity product;

  const ProductInfoPage({super.key, required this.product});

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
    create: (_) => inject<ProductInfoBloc>()..add(ProductInfoEvent.init(/*entity: product*/ productId: product.id)),
    child: this,
  );

  @override
  State<ProductInfoPage> createState() => _ProductInfoPageState();
}

class _ProductInfoPageState extends State<ProductInfoPage> {
  late ProductEntity _product;
  late CarouselSliderController _carouselSliderController;
  late final BehaviorLogger _behaviorLogger;
  DateTime? _detailViewedAt;
  bool _detailViewRecorded = false;
  int _lastImageIndex = 0;
  final Set<int> _recordedScrollDepths = <int>{};
  int? _quantityBeforeCartAction;
  bool? _pendingCartActionIsAdd;

  @override
  void initState() {
    _product = widget.product;
    _carouselSliderController = CarouselSliderController();
    _behaviorLogger = inject<BehaviorLogger>();
    super.initState();
  }

  @override
  void dispose() {
    if (_detailViewRecorded) {
      _behaviorLogger.recordNonBlocking(
        BehaviorEventDraftFactory.product(
          type: BehaviorEventType.productViewEnd,
          product: _product.toBehaviorSnapshot(),
          sourceScreen: 'product_detail',
          durationMs: DateTime.now().difference(_detailViewedAt!).inMilliseconds,
        ),
      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductInfoBloc, ProductInfoState>(
      listener: (context, state) {
        if (state.status.isFailed) {
          showToastError(state.errorMessage!, bottomPadding: Dimen.bottomToastPadding);
        }
        if (state.status.isLoaded) {
          _product = state.productEntity!;
          _recordDetailViewOnce();
        }
        switch (state.cartActionStatus) {
          case CartActionStatus.added:
            _recordCartResult(succeeded: true);
            showToastSuccess(ss.productAddedToCart);
          case CartActionStatus.removed:
            _recordCartResult(succeeded: true);
            if (!state.isInCart) {
              showToastSuccess(ss.productRemovedFromCart);
            }
          case CartActionStatus.failed:
            _recordCartResult(succeeded: false);
            showToastError(state.errorMessage ?? ss.cartOperationError);
          case CartActionStatus.initial:
          case CartActionStatus.loading:
            break;
        }
      },
      builder: (context, state) {
        return BasePageWidget.withOnScreenAndOverLayLoading(
          onScreenLoadingModeShowFailureByState: state.status.isFailed,
          onScreenLoadingModeShowCircularLoadingByState: state.status.isLoading,
          onScreenLoadingOnTryAgainCLick: () =>
              context.read<ProductInfoBloc>().add(ProductInfoEvent.init(entity: widget.product)),

          child: state.status.isLoaded ? _body(context, state) : const SizedBox(),
        );
      },
    );
  }

  //region Widgets
  Widget _body(BuildContext context, ProductInfoState state) {
    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: _onProductScroll,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 100),
            children: [
              _topBar(context),
              _breadcrumb(context),
              _productImage(context),
              _productInfoCard(context, state),
            ],
          ),
        ),
        Align(alignment: Alignment.bottomCenter, child: _addToCart(context, state)),
      ],
    );
  }

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4, left: 16, top: 12, bottom: 4),
      child: Row(
        children: [
          BzGestureDetector(
            onTap: () => context.maybePop(),
            child: Icon(Icons.close_rounded, color: context.scheme().profileIcon, size: 28),
          ),
          const Spacer(),
          Icon(Icons.favorite_outline_rounded, color: context.scheme().profileIcon, size: 28),
        ],
      ),
    );
  }

  Widget _breadcrumb(BuildContext context) {
    if (_product.breadcrumbs.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate((_product.breadcrumbs.length * 2) - 1, (index) {
            if (index.isEven) {
              BreadcrumbEntity breadcrumb = _product.breadcrumbs.reversed.toList()[index ~/ 2];
              return BzText(breadcrumb.title, style: context.body2Medium.copyWith(color: context.scheme().subText));
            }

            return Icon(Icons.chevron_right_rounded, size: 18, color: context.scheme().subText);
          }),
        ),
      ),
    );
  }

  Widget _productImage(BuildContext context) {
    final List<String> images = _product.images.where((String image) => image.isNotEmpty).toList();

    if (images.isEmpty) {
      return SizedBox(
        height: 320,
        child: Center(child: Icon(Icons.image_not_supported_outlined, size: 80, color: context.scheme().selectIcon)),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: BzSlider(
            height: Dimen.productInfoImageHeight,
            itemList: List.generate(images.length, (int index) {
              final String imageUrl = images[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Image.network(imageUrl, fit: BoxFit.contain),
              );
            }),
            enlargeFactor: 0.2,
            viewportFraction: 1,
            indicatorIntoSlider: false,
            controller: _carouselSliderController,
            autoPlay: false,
            showIndicator: true,
            onPageChanged: (int index) => _recordImageChange(index, images.length),
          ),
        ),
      ],
    );
  }

  Widget _productInfoCard(BuildContext context, ProductInfoState state) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Container(
        decoration: BoxDecoration(
          color: context.scheme().mainBackground1,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          border: Border(top: BorderSide(color: context.scheme().divider)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  width: 52,
                  height: 5,
                  margin: const EdgeInsets.only(top: 10, bottom: 16),
                  decoration: BoxDecoration(color: context.scheme().divider, borderRadius: BorderRadius.circular(8)),
                ),
              ),
              _productCategoryTree(context),
              const VGap(16),
              _productHeaders(context),
              const VGap(16),
              _productMeta(context),
              const VGap(20),

              _productOptions(context),
              const VGap(20),
              const BzDivider(),
              const VGap(20),
              _specificationsTable(context, state),
              const VGap(20),
              _commentsSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _productCategoryTree(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: BzText(
            _product.brand.titleFa,
            style: context.body2Medium.copyWith(color: context.scheme().subText),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const HGap(4),
        Icon(Icons.chevron_right_rounded, size: 18, color: context.scheme().subText),
        const HGap(4),
        BzText(
          '${_product.categoryTitle} ${_product.brand.titleFa}',
          style: context.body2Medium.copyWith(color: context.scheme().subText),
        ),
      ],
    );
  }

  Widget _productHeaders(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        BzText(
          _product.titleFa,
          style: context.title1Bold.copyWith(color: context.scheme().titleText),
          textAlign: TextAlign.right,
          overflow: TextOverflow.clip,
        ),
      ],
    );
  }

  Widget _productMeta(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(
        children: [
          BzInfoChip(
            text: '${_product.rate.toStringAsFixed(1)} (${_product.rateCount})',
            icon: Icons.star_rounded,
            iconColor: Colors.amber,
          ),
          const HGap(8),
          BzInfoChip(text: ss.commentCount(_product.commentCount), icon: Icons.rate_review_outlined),
          const HGap(8),
          BzInfoChip(text: ss.questionCount(_product.questionCount), icon: Icons.help_outline_rounded),
        ],
      ),
    );
  }

  Widget _productOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_product.selectedColor != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BzText(
                '${ss.color}: ${_product.selectedColor!.title}',
                style: context.body1Medium.copyWith(color: context.scheme().titleText),
              ),

              const HGap(8),
              Container(
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  color: _colorFromHex(_product.selectedColor!.hexColor),
                  shape: BoxShape.circle,
                  border: Border.all(color: context.scheme().boxBorder),
                ),
              ),
            ],
          ),
          const VGap(16),
        ],
        if (_product.seller != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BzText('${ss.seller}:', style: context.body1Medium.copyWith(color: context.scheme().titleText)),
              const VGap(16),
              _sellerBox(context),
            ],
          ),
      ],
    );
  }

  Widget _sellerBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.scheme().mainBackground4,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.scheme().boxBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.storefront_outlined, color: context.scheme().primary, size: 22),
          const HGap(8),
          Expanded(
            child: BzText(_product.seller!.name, style: context.body1Bold, overflow: TextOverflow.ellipsis),
          ),

          const Spacer(),
          Expanded(
            child: BzText(
              ss.satisfaction(_product.seller!.satisfactionPercent.round(), _product.seller!.performance ?? ''),
              style: context.body4Medium.copyWith(color: context.scheme().subText),
            ),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _productDes(BuildContext context, ProductInfoState state) {
    final List<ProductSpecificationEntity> specifications = _product.specifications;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (specifications.isNotEmpty) ...[
            BzText(ss.specifications, style: context.title1Bold),
            const VGap(10),
            ...specifications.expand((ProductSpecificationEntity specification) => specification.items).take(4).map((
              ProductSpecificationItemEntity item,
            ) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: BzInfoChip(text: '${item.title}: ${item.values.join('، ')}'),
              );
            }),
            const VGap(8),
          ],
          if ((_product.review?.description ?? '').isNotEmpty) ...[
            BzText(ss.description, style: context.title1Bold),
            const VGap(8),
            BzText(_product.review!.description, style: context.body2Regular, textAlign: TextAlign.justify),
          ],
        ],
      ),
    );
  }

  Widget _specificationsTable(BuildContext context, ProductInfoState state) {
    final List<ProductSpecificationItemEntity> items = _product.specifications
        .expand((ProductSpecificationEntity specification) => specification.items)
        .where((ProductSpecificationItemEntity item) => item.values.isNotEmpty)
        .take(5)
        .toList();

    if (items.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BzText(
          _product.specifications.first.groupTitle,
          style: context.title1Bold.copyWith(color: context.scheme().titleText),
        ),
        const VGap(14),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            children: items.map((ProductSpecificationItemEntity item) {
              return IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: context.scheme().divider)),
                        ),
                        child: BzText(
                          item.title,

                          style: context.body2Medium.copyWith(color: context.scheme().mainText),
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: context.scheme().mainBackground4,
                          border: Border(bottom: BorderSide(color: context.scheme().divider)),
                        ),
                        child: BzText(
                          item.values.join(', '),
                          style: context.body2Bold.copyWith(color: context.scheme().mainText),
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _commentsSection(BuildContext context) {
    final List<ProductCommentEntity> comments = _product.comments.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            BzText(ss.userReviews, style: context.title1Bold.copyWith(color: context.scheme().titleText)),
            const Spacer(),
          ],
        ),
        const VGap(20),
        Row(
          children: [
            const Icon(Icons.star_rounded, color: Colors.amber, size: 30),
            const HGap(4),
            BzText(
              _product.rate.toStringAsFixed(1),
              style: context.headline4Bold.copyWith(color: context.scheme().titleText),
            ),
            const HGap(8),
            BzText(
              ss.buyersOpinionCount(_product.rateCount),
              style: context.body4Medium.copyWith(color: context.scheme().subText),
            ),
          ],
        ),
        const VGap(18),
        SizedBox(
          height: 224,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...comments.map((ProductCommentEntity comment) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CommentCardWidget(comment: comment, product: _product),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  // ignore: unused_element
  Widget _rateProduct(BuildContext context) {
    return Wrap(
      children: [
        const Icon(Icons.star, size: 24, color: Colors.amber),
        const HGap(4),
        BzText(_product.rate.toString(), style: context.body1Medium.copyWith(color: context.scheme().titleText)),
        const HGap(4),
        BzText(
          '(${ss.rateCount(_product.rateCount)})',
          style: context.body2Medium.copyWith(color: context.scheme().subText),
        ),
        BzText(
          '(${ss.review} ${_product.commentCount})',
          style: context.body2Medium.copyWith(color: context.scheme().subText),
        ),

        BzText(
          '(${ss.question} ${_product.questionCount})',
          style: context.body2Medium.copyWith(color: context.scheme().subText),
        ),
      ],
    );
  }

  Widget _addToCart(BuildContext context, ProductInfoState state) {
    final cartProduct = inject<CartManager>().findProduct(_product.id);
    final quantity = cartProduct?.quantity ?? 0;

    return Container(
      color: context.scheme().mainBackground1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: state.isInCart && quantity > 0
                  ? _cartQuantityControl(context, state, quantity)
                  : BzButton.submit(
                      text: !_product.available ? ss.unavailable : ss.addToCart,
                      showLoading: state.cartActionStatus.isLoading,
                      enabled: _product.available && !state.cartActionStatus.isLoading,
                      onPressed: () {
                        _quantityBeforeCartAction = quantity;
                        _pendingCartActionIsAdd = true;
                        context.read<ProductInfoBloc>().add(ProductInfoEvent.addToCart(_product));
                      },
                    ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BzTextCurrency.amountWithTitle(
                    amount: _product.price,
                    currencyUnitStyle: context.body3Medium.copyWith(color: context.scheme().primary),
                    style: context.headline5Bold.copyWith(color: context.scheme().primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cartQuantityControl(BuildContext context, ProductInfoState state, int quantity) {
    final isLoading = state.cartActionStatus.isLoading;
    final color = context.scheme().error.withValues(alpha: 0.8);

    return Container(
      height: 56,
      width: 50,
      decoration: BoxDecoration(
        color: context.scheme().mainBackground1,
        border: Border.all(color: context.scheme().boxBorder),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          children: [
            Expanded(
              child: IconButton(
                onPressed: isLoading
                    ? null
                    : () {
                        _quantityBeforeCartAction = quantity;
                        _pendingCartActionIsAdd = false;
                        context.read<ProductInfoBloc>().add(ProductInfoEvent.removeFromCart(_product.id));
                      },
                icon: Icon(
                  quantity == 1 ? Icons.delete_outline_rounded : Icons.remove_rounded,
                  color: isLoading ? color.withValues(alpha: 0.45) : color,
                  size: 26,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: isLoading
                    ? SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: color))
                    : BzText(quantity.toString(), style: context.headline5Bold.copyWith(color: color)),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: isLoading
                    ? null
                    : () {
                        _quantityBeforeCartAction = quantity;
                        _pendingCartActionIsAdd = true;
                        context.read<ProductInfoBloc>().add(ProductInfoEvent.addToCart(_product));
                      },
                icon: Icon(Icons.add_rounded, color: isLoading ? color.withValues(alpha: 0.45) : color, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _colorFromHex(String hexColor) {
    final String colorText = hexColor.replaceAll('#', '');
    final String normalizedColor = colorText.length == 6 ? 'FF$colorText' : colorText;
    final int? colorValue = int.tryParse(normalizedColor, radix: 16);

    return Color(colorValue ?? 0xFF000000);
  }

  void _recordDetailViewOnce() {
    if (_detailViewRecorded) return;
    _detailViewRecorded = true;
    _detailViewedAt = DateTime.now();
    _behaviorLogger.recordNonBlocking(
      BehaviorEventDraftFactory.product(
        type: BehaviorEventType.productDetailView,
        product: _product.toBehaviorSnapshot(),
        sourceScreen: 'product_detail',
        payload: const ProductBehaviorPayload(displaySource: 'product_list'),
      ),
    );
    if (_product.images.isNotEmpty) {
      _behaviorLogger.recordNonBlocking(
        BehaviorEventDraftFactory.product(
          type: BehaviorEventType.productImageView,
          product: _product.toBehaviorSnapshot(),
          sourceScreen: 'product_detail',
          payload: ProductBehaviorPayload(imageIndex: 0, imageCount: _product.images.length, distinctImagesViewed: 1),
        ),
      );
    }
  }

  void _recordImageChange(int index, int imageCount) {
    if (index == _lastImageIndex) return;
    final direction = index > _lastImageIndex ? 'next' : 'previous';
    _lastImageIndex = index;
    final payload = ProductBehaviorPayload(imageIndex: index, imageCount: imageCount, swipeDirection: direction);
    _behaviorLogger.recordNonBlocking(
      BehaviorEventDraftFactory.product(
        type: BehaviorEventType.productImageSwipe,
        product: _product.toBehaviorSnapshot(),
        sourceScreen: 'product_detail',
        payload: payload,
      ),
    );
    _behaviorLogger.recordNonBlocking(
      BehaviorEventDraftFactory.product(
        type: BehaviorEventType.productImageView,
        product: _product.toBehaviorSnapshot(),
        sourceScreen: 'product_detail',
        payload: payload,
      ),
    );
  }

  bool _onProductScroll(ScrollNotification notification) {
    if (!_detailViewRecorded || notification.metrics.axis != Axis.vertical) {
      return false;
    }
    final double maxExtent = notification.metrics.maxScrollExtent;
    if (maxExtent <= 0) return false;

    final double contentExtent = maxExtent + notification.metrics.viewportDimension;
    final double visibleBottom =
        notification.metrics.pixels.clamp(0.0, maxExtent) + notification.metrics.viewportDimension;
    final double depthPercent = (visibleBottom / contentExtent) * 100;
    for (final int threshold in const <int>[25, 50, 75, 100]) {
      if (depthPercent < threshold || !_recordedScrollDepths.add(threshold)) {
        continue;
      }
      _behaviorLogger.recordNonBlocking(
        BehaviorEventDraftFactory.product(
          type: BehaviorEventType.productScrollDepth,
          product: _product.toBehaviorSnapshot(),
          sourceScreen: 'product_detail',
          payload: ProductBehaviorPayload(scrollDepthPercent: threshold.toDouble()),
        ),
      );
    }
    return false;
  }

  void _recordCartResult({required bool succeeded}) {
    final quantityBefore = _quantityBeforeCartAction;
    final isAdd = _pendingCartActionIsAdd;
    if (quantityBefore == null || isAdd == null) return;
    final quantityAfter = succeeded ? inject<CartManager>().findProduct(_product.id)?.quantity ?? 0 : quantityBefore;
    final eventType = isAdd
        ? (quantityBefore == 0 ? BehaviorEventType.cartAdd : BehaviorEventType.cartQuantityChanged)
        : (quantityBefore == 1 ? BehaviorEventType.cartRemove : BehaviorEventType.cartQuantityChanged);
    final cart = inject<CartManager>().cart;
    _behaviorLogger.recordNonBlocking(
      BehaviorEventDraftFactory.cart(
        type: eventType,
        product: _product.toBehaviorSnapshot(),
        sourceScreen: 'product_detail',
        status: succeeded ? 'succeeded' : 'failed',
        payload: CartBehaviorPayload(
          quantityBefore: quantityBefore,
          quantityAfter: quantityAfter,
          cartProductIds: cart.products.map((item) => item.productId.toString()).toList(growable: false),
          cartProductCount: cart.products.length,
        ),
      ),
    );
    _quantityBeforeCartAction = null;
    _pendingCartActionIsAdd = null;
  }
}
