import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/shared/cart/domain/entities/cart_product_entity.dart';

class CartProductWidget extends StatelessWidget {
  final CartProductEntity product;

  const CartProductWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: Dimen.productInCartImgSize,
                height: Dimen.productInCartImgSize,
                child: Image.network(product.imageUrl),
              ),
              const HGap(12),
              Flexible(
                child: BzText(
                  product.productName,
                  style: context.body3Medium.copyWith(color: context.scheme().mainText),
                ),
              ),
            ],
          ),
          const VGap(18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BzText(
                ss.quantityValue(product.quantity),
                style: context.body2Medium.copyWith(color: context.scheme().subText),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerEnd,
                child: BzTextCurrency.amountWithTitle(
                  amount: product.price,
                  style: context.body2Medium.copyWith(color: context.scheme().primary),
                ),
              ),
            ],
          ),
          const VGap(14),
          const BzDivider(thickness: 2),
        ],
      ),
    );
  }
}
