import 'package:dynamic_app/app/route/app_router.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_in_cart_entity.dart';

class ProductInCartWidget extends StatefulWidget {
  final ProductInCartEntity productInCartEntity;
  final VoidCallback increaseCount;
  final VoidCallback decreaseCount;

  const ProductInCartWidget(
      {super.key, required this.productInCartEntity, required this.increaseCount, required this.decreaseCount});

  @override
  State<ProductInCartWidget> createState() => _ProductInCartWidgetState();
}

class _ProductInCartWidgetState extends State<ProductInCartWidget> {
  late ProductInCartEntity _entity;

  @override
  void initState() {
    _entity = widget.productInCartEntity;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ProductInCartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.productInCartEntity != oldWidget.productInCartEntity) {
      _entity = widget.productInCartEntity;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: BzGestureDetector(
            inkwellPadding: EdgeInsets.zero,
            borderRadius: BorderRadius.zero,
            onTap: () => context.pushRoute(ProductInfoPageRoute(product: _entity.productEntity)),
            child: Container(
              height: Dimen.productInCartRowHeight,
              decoration:
                  BoxDecoration(color: context.scheme().mainBackground1, borderRadius: Dimen.defaultBorderRadius),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  //img
                  Column(
                    children: [
                      SizedBox(
                        height: Dimen.productInCartRowImgHeight,
                        child: Image.network(_entity.productEntity.imageUrl),
                      ),
                      VGap(24),
                      _incDecWidget(context),
                    ],
                  ),

                  //info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        BzText(
                          _entity.productEntity.name,
                          style: context.body4Medium.copyWith(color: context.scheme().titleText),
                          overflow: TextOverflow.clip,
                        ),
                        const VGap(8),
                        BzText(
                          ss.sendFromOneDay,
                          style: context.body4Medium.copyWith(color: context.scheme().subText),
                          overflow: TextOverflow.clip,
                        ),
                        const VGap(34),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            BzTextCurrency.amountWithTitle(
                              amount: int.parse(_entity.productEntity.amount),
                              style: context.body1Bold.copyWith(color: context.scheme().primary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        const BzDivider(thickness: 2),
      ],
    );
  }

  Widget _incDecWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: context.scheme().primary2,
            width: 2,
          ),
          borderRadius: Dimen.defaultBorderRadius),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            BzGestureDetector(
              onTap: () => widget.decreaseCount.call(),
              child: const Icon(Icons.remove, size: 24),
            ),
            const HGap(8),
            BzText(_entity.selectedCount.toString(), style: context.body1Bold),
            const HGap(8),
            BzGestureDetector(onTap: () => widget.increaseCount.call(), child: const Icon(Icons.add, size: 24))
          ],
        ),
      ),
    );
  }
}
