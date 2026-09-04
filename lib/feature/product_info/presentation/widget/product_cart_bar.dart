import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/product_info/presentation/bloc/product_info_bloc.dart';
import 'package:dynamic_app/feature/product_info/presentation/widget/ai_personalization_card.dart';
import 'package:dynamic_app/shared/personalization/domain/entities/personalization_action.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';

/// دکمه افزودن و کنترل تعداد محصول را پایین صفحه نمایش می‌دهد.
class ProductCartBar extends StatelessWidget {
  const ProductCartBar({
    super.key,
    required this.product,
    required this.state,
    required this.quantity,
    required this.buttonScale,
    required this.onAddOne,
    required this.onRemoveOne,
  });

  final ProductEntity product;
  final ProductInfoState state;
  final int quantity;
  final Animation<double> buttonScale;
  final ValueChanged<int> onAddOne;
  final ValueChanged<int> onRemoveOne;

  @override
  Widget build(BuildContext context) {
    final bool highlightAddToCart =
        state.personalizationDecision?.action == PersonalizationAction.highlightAddToCartButton && !state.isInCart;
    final Widget addToCartButton = BzButton.submit(
      text: !product.available ? ss.unavailable : ss.addToCart,
      showLoading: state.cartActionStatus.isLoading,
      enabled: product.available && !state.cartActionStatus.isLoading,
      minSize: highlightAddToCart ? 53 : Dimen.buttonMinHeight,
      icon: highlightAddToCart ? const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20) : null,
      onPressed: () => onAddOne(quantity),
    );

    return SizedBox(
      height: 88,
      child: ColoredBox(
        color: context.scheme().mainBackground1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: ScaleTransition(
                  scale: buttonScale,
                  child: state.isInCart && quantity > 0
                      ? _QuantityButtons(
                          quantity: quantity,
                          isLoading: state.cartActionStatus.isLoading,
                          onAddOne: onAddOne,
                          onRemoveOne: onRemoveOne,
                        )
                      : highlightAddToCart
                      ? AiPersonalizationButton(label: ss.aiSuggestedAction, child: addToCartButton)
                      : addToCartButton,
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: BzTextCurrency.amountWithTitle(
                    amount: product.price,
                    currencyUnitStyle: context.body3Medium.copyWith(color: context.scheme().primary),
                    style: context.headline5Bold.copyWith(color: context.scheme().primary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuantityButtons extends StatelessWidget {
  const _QuantityButtons({
    required this.quantity,
    required this.isLoading,
    required this.onAddOne,
    required this.onRemoveOne,
  });

  final int quantity;
  final bool isLoading;
  final ValueChanged<int> onAddOne;
  final ValueChanged<int> onRemoveOne;

  @override
  Widget build(BuildContext context) {
    final Color color = context.scheme().error.withValues(alpha: 0.8);
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
          children: <Widget>[
            Expanded(
              child: IconButton(
                onPressed: isLoading ? null : () => onRemoveOne(quantity),
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
                onPressed: isLoading ? null : () => onAddOne(quantity),
                icon: Icon(Icons.add_rounded, color: isLoading ? color.withValues(alpha: 0.45) : color, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
