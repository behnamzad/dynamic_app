import 'package:dynamic_app/core/presentation/widget/bz_gesture_detector.dart';
import 'package:dynamic_app/core/presentation/widget/bz_text_currency.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';

@RoutePage()
class ProductInfoPage extends StatefulWidget implements AutoRouteWrapper {
  final ProductEntity product;

  const ProductInfoPage({super.key, required this.product});

  @override
  Widget wrappedRoute(BuildContext context) => this;

  @override
  State<ProductInfoPage> createState() => _ProductInfoPageState();
}

class _ProductInfoPageState extends State<ProductInfoPage> {
  //

  @override
  Widget build(BuildContext context) {
    return BasePageWidget(child: _body(context));
  }

//region Widgets
  Widget _body(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            _productImage(context),
            _productHeaders(context),
            _productDes(context),
          ],
        ),
        //add to cart btn
        Align(alignment: Alignment.bottomCenter, child: _addToCart(context)),

        //fav Icon
        Positioned(
            top: 18,
            left: 12,
            child: BzGestureDetector(
                materialColor: context.scheme().mainBackground7.withOpacity(0.8),
                child: Icon(
                  Icons.favorite_border_outlined,
                  color: context.scheme().profileIcon,
                  size: 32,
                ))),
        Positioned(
            top: 18,
            right: 12,
            child: BzGestureDetector(
                onTap: () => context.maybePop(),
                materialColor: context.scheme().mainBackground7.withOpacity(0.8),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: context.scheme().profileIcon,
                  size: 32,
                ))),
      ],
    );
  }

  Widget _productImage(BuildContext context) {
    return SizedBox(
      height: Dimen.productInfoImageHeight,
      child: Image.network(widget.product.imageUrl),
    );
  }

  Widget _productHeaders(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //name
                BzText(
                  widget.product.name,
                  style: context.headline3Bold,
                  overflow: TextOverflow.clip,
                ),
                //rate
                _rateProduct(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _productDes(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const VGap(8),
            BzText(
              ss.description,
              style: context.headline3Bold,
            ),
            const VGap(8),
            BzText(
              widget.product.description,
              style: context.body2Regular,
              textAlign: TextAlign.justify,
            ),
          ],
        ));
  }

  Widget _rateProduct(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star, size: 24, color: Colors.amber),
        const HGap(4),
        BzText(widget.product.rate, style: context.body1Medium.copyWith(color: context.scheme().titleText)),
        const HGap(4),
        BzText('(${widget.product.reviewCount.toString()} ${ss.reviewCount})',
            style: context.body2Medium.copyWith(color: context.scheme().subText))
      ],
    );
  }

  Widget _addToCart(BuildContext context) {
    return Container(
        color: context.scheme().mainBackground1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(flex: 3, child: BzButton.submit(text: ss.addToCart, onPressed: () {})),
              // Spacer(),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BzTextCurrency.amountWithTitle(
                      amount: int.parse(widget.product.amount),
                      currencyUnitStyle: context.body3Medium.copyWith(color: context.scheme().primary),
                      style: context.headline5Bold.copyWith(color: context.scheme().primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
