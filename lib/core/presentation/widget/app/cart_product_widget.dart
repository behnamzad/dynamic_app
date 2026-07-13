import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/shared/cart/domain/entities/cart_product_entity.dart';

class CartProductWidget extends StatelessWidget {
  final CartProductEntity product;

  const CartProductWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.scheme().mainBackground1,
              borderRadius: Dimen.defaultBorderRadius,
            ),
            child: Row(
              children: [
                Icon(Icons.shopping_bag_outlined, color: context.scheme().primary, size: 34),
                const HGap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BzText(ss.productIdValue(product.productId), style: context.title2Bold),
                      const VGap(6),
                      BzText(
                        ss.categoryIdValue(product.categoryId),
                        style: context.body3Medium.copyWith(color: context.scheme().subText),
                      ),
                    ],
                  ),
                ),
                BzText(ss.quantityValue(product.quantity), style: context.title2Bold),
              ],
            ),
          ),
        ),
        const BzDivider(thickness: 2),
      ],
    );
  }
}
