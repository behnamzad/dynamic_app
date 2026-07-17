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
      padding: const EdgeInsets.all(8.0),
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
}
