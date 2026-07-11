import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';

enum ProductCardType { card, row }

class ProductWidget extends StatefulWidget {
  final ProductEntity entity;
  final ProductCardType productCardType;

  const ProductWidget.card({super.key, required this.entity}) : productCardType = ProductCardType.card;

  const ProductWidget.row({super.key, required this.entity}) : productCardType = ProductCardType.row;

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.productCardType == ProductCardType.card ? _card(context) : _row(context);
  }

  _card(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(
        8.0,
      ),
      child: SizedBox(
        height: Dimen.productCardHeight,
        width: Dimen.productCardWidth,
        child: BzGestureDetector(
          borderRadius: Dimen.defaultBorderRadius,
          inkwellPadding: EdgeInsets.zero,
          onTap: () => context.pushRoute(ProductInfoPageRoute(product: widget.entity)),
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
                          topLeft: Radius.circular(Dimen.defaultRadius),),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 2.0, bottom: 2),
                      // child: Image.network(widget.entity.imageUrl),
                    ),
                  ),
                  //info
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(Dimen.defaultRadius),
                          bottomLeft: Radius.circular(Dimen.defaultRadius),),
                      color: context.scheme().mainBackground2,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6.0, bottom: 4, top: 4),
                      child: Column(
                        children: [
                          BzText(
                            widget.entity.titleFa,
                            style: context.body1Bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                          BzTextCurrency.amountWithTitle(
                            amount:widget.entity.price,
                            style: context.body2Medium.copyWith(color: context.scheme().primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              //fav Icon
              BzGestureDetector(
                child: Icon(
                  widget.entity.id.isEven ? Icons.favorite_outline_rounded : Icons.favorite,
                  size: 24,
                  color: context.scheme().dialogIcon.withValues(alpha: 0.8),
                ),
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
      onTap: () => context.pushRoute(ProductInfoPageRoute(product: widget.entity)),
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
                  const SizedBox(
                    height: Dimen.productRowImgHeight,
                    // child: Image.network(widget.entity.imageUrl),
                  ),
                  //info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: BzText(
                              widget.entity.titleFa,
                              style: context.body4Medium.copyWith(color: context.scheme().titleText),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  //rate
                                  Row(
                                    children: [
                                      const Icon(Icons.star, size: 14, color: Colors.amberAccent),
                                      BzText(widget.entity.titleFa,
                                          style: context.body4Regular.copyWith(color: context.scheme().mainText),),
                                    ],
                                  ),
                                  //amount
                                  BzTextCurrency.amountWithTitle(
                                    amount: widget.entity.price,
                                    style: context.body2Medium.copyWith(color: context.scheme().primary),
                                  ),
                                ],
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
          const Padding(
            padding: EdgeInsets.only(right: 100.0, top: 4, bottom: 4),
            child: BzDivider(),
          ),
        ],
      ),
    );
  }
}
