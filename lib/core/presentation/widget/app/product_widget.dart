import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/shared/behavior/data/mapper/product_behavior_snapshot_mapper.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_payload.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_type.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/recommendation_attribution.dart';
import 'package:dynamic_app/shared/behavior/domain/factory/behavior_event_draft_factory.dart';
import 'package:dynamic_app/shared/behavior/domain/manager/behavior_logger.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';

enum ProductCardType { card, row }

class ProductWidget extends StatefulWidget {
  final ProductEntity entity;
  final ProductCardType productCardType;
  final String sourceScreen;
  final int? position;
  final String? searchQuery;
  final RecommendationAttribution? recommendationAttribution;

  const ProductWidget.card({
    super.key,
    required this.entity,
    this.sourceScreen = 'product_list',
    this.position,
    this.searchQuery,
    this.recommendationAttribution,
  }) : productCardType = ProductCardType.card;

  const ProductWidget.row({
    super.key,
    required this.entity,
    this.sourceScreen = 'product_list',
    this.position,
    this.searchQuery,
    this.recommendationAttribution,
  }) : productCardType = ProductCardType.row;

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  late final BehaviorLogger _behaviorLogger;

  @override
  void initState() {
    super.initState();
    _behaviorLogger = inject<BehaviorLogger>();
    _recordImpression();
  }

  @override
  void didUpdateWidget(covariant ProductWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entity.id != widget.entity.id ||
        oldWidget.sourceScreen != widget.sourceScreen ||
        oldWidget.position != widget.position) {
      _recordImpression();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.productCardType == ProductCardType.card ? _card(context) : _row(context);
  }

  _card(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: Dimen.productCardHeight,
        width: Dimen.productCardWidth,
        child: BzGestureDetector(
          borderRadius: Dimen.defaultBorderRadius,
          inkwellPadding: EdgeInsets.zero,
          onTap: () => _openProduct(context),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // img
                  Container(
                    height: Dimen.productCardImgHeight,
                    width: Dimen.productCardWidth,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(Dimen.defaultRadius),
                        topLeft: Radius.circular(Dimen.defaultRadius),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2.0, bottom: 2),
                      child: Image.network(widget.entity.images.first),
                    ),
                  ),
                  //info
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(Dimen.defaultRadius),
                        bottomLeft: Radius.circular(Dimen.defaultRadius),
                      ),
                      color: context.scheme().mainBackground2,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6.0, bottom: 4, top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BzText(
                            widget.entity.titleFa,
                            style: context.body4Medium.copyWith(color: context.scheme().mainText),
                            overflow: TextOverflow.ellipsis,
                          ),
                          BzTextCurrency.amountWithTitle(
                            amount: widget.entity.price,
                            style: context.body3Regular.copyWith(color: context.scheme().primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _row(BuildContext context) {
    return BzGestureDetector(
      inkwellPadding: EdgeInsets.zero,
      borderRadius: BorderRadius.zero,
      onTap: () => _openProduct(context),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: SizedBox(
              height: Dimen.productRowHeight,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  //img
                  SizedBox(
                    width: Dimen.productRowImgHeight,
                    height: Dimen.productRowImgHeight,
                    child: Image.network(widget.entity.images.first, fit: BoxFit.contain),
                  ),
                  //info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: BzText(
                              widget.entity.titleFa,
                              style: context.body4Medium.copyWith(color: context.scheme().titleText),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                        const VGap(40),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              //rate
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  BzText(
                                    widget.entity.rate.toString(),
                                    style: context.body4Regular.copyWith(color: context.scheme().mainText),
                                  ),
                                  const HGap(4),
                                  const Icon(Icons.star, size: 14, color: Colors.amberAccent),
                                ],
                              ),
                              const HGap(8),
                              //amount
                              Expanded(
                                child: Align(
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: BzTextCurrency.amountWithTitle(
                                      amount: widget.entity.price,
                                      style: context.body2Medium.copyWith(color: context.scheme().primary),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(right: 100.0, top: 4, bottom: 4), child: BzDivider()),
        ],
      ),
    );
  }

  void _recordImpression() {
    _behaviorLogger.recordNonBlocking(
      BehaviorEventDraftFactory.product(
        type: BehaviorEventType.productImpression,
        product: widget.entity.toBehaviorSnapshot(),
        sourceScreen: widget.sourceScreen,
        position: widget.position,
        payload: ProductBehaviorPayload(displaySource: widget.sourceScreen, displayRank: widget.position),
      ),
    );
  }

  void _openProduct(BuildContext context) {
    final snapshot = widget.entity.toBehaviorSnapshot();
    _behaviorLogger.recordNonBlocking(
      BehaviorEventDraftFactory.product(
        type: BehaviorEventType.productClick,
        product: snapshot,
        sourceScreen: widget.sourceScreen,
        position: widget.position,
        payload: ProductBehaviorPayload(displaySource: widget.sourceScreen, displayRank: widget.position),
      ),
    );
    final RecommendationAttribution? attribution = widget.recommendationAttribution;
    if (attribution != null) {
      _behaviorLogger.recordNonBlocking(
        BehaviorEventDraftFactory.recommendation(
          type: BehaviorEventType.recommendationClick,
          product: snapshot,
          sourceScreen: widget.sourceScreen,
          position: widget.position,
          payload: RecommendationBehaviorPayload(
            requestId: attribution.requestId,
            selectedProductId: widget.entity.id.toString(),
            displayRank: attribution.displayRank,
            displaySlot: attribution.displaySlot,
            strategy: attribution.strategy,
            modelVersion: attribution.modelVersion,
            nextAction: 'open_product',
            confidence: attribution.confidence,
          ),
        ),
      );
    }
    final query = widget.searchQuery?.trim();
    if (query != null && query.isNotEmpty) {
      _behaviorLogger.recordNonBlocking(
        BehaviorEventDraftFactory.search(
          type: BehaviorEventType.searchResultClick,
          sourceScreen: widget.sourceScreen,
          product: snapshot,
          payload: SearchBehaviorPayload(
            query: query,
            normalizedQuery: query.toLowerCase(),
            selectedProductId: widget.entity.id.toString(),
            selectedResultRank: widget.position,
          ),
        ),
      );
    }
    context.pushRoute(ProductInfoPageRoute(product: widget.entity, recommendationAttribution: attribution));
  }
}
