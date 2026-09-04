import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/product_info/presentation/widget/comment_card_widget.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';

/// امتیاز کلی و کارت‌های نظر کاربران را کنار هم نمایش می‌دهد.
class ProductReviewsSection extends StatelessWidget {
  const ProductReviewsSection({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BzText(ss.userReviews, style: context.title1Bold.copyWith(color: context.scheme().titleText)),
        const VGap(20),
        Row(
          children: <Widget>[
            const Icon(Icons.star_rounded, color: Colors.amber, size: 30),
            const HGap(4),
            BzText(
              product.rate.toStringAsFixed(1),
              style: context.headline4Bold.copyWith(color: context.scheme().titleText),
            ),
            const HGap(8),
            BzText(
              ss.buyersOpinionCount(product.rateCount),
              style: context.body4Medium.copyWith(color: context.scheme().subText),
            ),
          ],
        ),
        const VGap(18),
        SizedBox(
          height: 224,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: product.comments
                .map(
                  (ProductCommentEntity comment) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: CommentCardWidget(comment: comment, product: product),
                  ),
                )
                .toList(growable: false),
          ),
        ),
      ],
    );
  }
}
