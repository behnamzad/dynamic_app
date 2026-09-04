import 'package:dynamic_app/core/presentation/widget/bz_info_chip.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/product_info/presentation/bloc/product_info_bloc.dart';
import 'package:dynamic_app/feature/product_info/presentation/widget/ai_personalization_card.dart';
import 'package:dynamic_app/feature/product_info/presentation/widget/product_recommendations_section.dart';
import 'package:dynamic_app/feature/product_info/presentation/widget/product_reviews_section.dart';
import 'package:dynamic_app/feature/product_info/presentation/widget/product_specifications_section.dart';
import 'package:dynamic_app/shared/personalization/domain/entities/personalization_action.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';

/// اطلاعات اصلی، پیشنهادها، فروشنده، مشخصات و نظرهای محصول را کنار هم می‌چیند.
class ProductDetailsCard extends StatelessWidget {
  const ProductDetailsCard({super.key, required this.product, required this.state});

  final ProductEntity product;
  final ProductInfoState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Container(
        decoration: BoxDecoration(
          color: context.scheme().mainBackground1,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          border: Border(top: BorderSide(color: context.scheme().divider)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _dragHandle(context),
              _categoryAndBrand(context),
              const VGap(16),
              _title(context),
              const VGap(16),
              _quickFacts(context),
              AnimatedSwitcher(
                duration: MediaQuery.maybeOf(context)?.disableAnimations ?? false
                    ? Duration.zero
                    : const Duration(milliseconds: 450),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: Tween<double>(begin: 0.98, end: 1).animate(animation), child: child),
                  );
                },
                child: _personalizationSection(),
              ),
              const VGap(20),
              _buyingOptions(context),
              const VGap(20),
              const BzDivider(),
              const VGap(20),
              _highlightedInformation(
                context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ProductSpecificationsSection(product: product),
                    const VGap(20),
                    ProductReviewsSection(product: product),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // region Header

  Widget _dragHandle(BuildContext context) {
    return Center(
      child: Container(
        width: 52,
        height: 5,
        margin: const EdgeInsets.only(top: 10, bottom: 16),
        decoration: BoxDecoration(color: context.scheme().divider, borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _categoryAndBrand(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          child: BzText(
            product.brand.titleFa,
            style: context.body2Medium.copyWith(color: context.scheme().subText),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const HGap(4),
        Icon(Icons.chevron_right_rounded, size: 18, color: context.scheme().subText),
        const HGap(4),
        Flexible(
          child: BzText(
            '${product.categoryTitle} ${product.brand.titleFa}',
            style: context.body2Medium.copyWith(color: context.scheme().subText),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _title(BuildContext context) {
    return BzText(
      product.titleFa,
      style: context.title1Bold.copyWith(color: context.scheme().titleText),
      textAlign: TextAlign.right,
      overflow: TextOverflow.clip,
    );
  }

  Widget _quickFacts(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(
        children: <Widget>[
          BzInfoChip(
            text: '${product.rate.toStringAsFixed(1)} (${product.rateCount})',
            icon: Icons.star_rounded,
            iconColor: Colors.amber,
          ),
          const HGap(8),
          BzInfoChip(text: ss.commentCount(product.commentCount), icon: Icons.rate_review_outlined),
          const HGap(8),
          BzInfoChip(text: ss.questionCount(product.questionCount), icon: Icons.help_outline_rounded),
        ],
      ),
    );
  }

  // endregion

  // region Recommendations

  bool get _shouldShowRecommendations =>
      state.personalizationDecision?.action == PersonalizationAction.showAlternativeProducts &&
      state.alternativeProductSuggestions.isNotEmpty &&
      state.recommendationStrategy != null;

  Widget _personalizationSection() {
    if (state.personalizationStatus == PersonalizationStatus.loading) {
      return const Padding(
        key: ValueKey<String>('ai_loading'),
        padding: EdgeInsets.only(top: 20),
        child: AiPersonalizationLoading(),
      );
    }
    if (_shouldShowRecommendations) {
      return Padding(
        key: const ValueKey<String>('ai_recommendations'),
        padding: const EdgeInsets.only(top: 20),
        child: ProductRecommendationsSection(
          suggestions: state.alternativeProductSuggestions,
          requestId: state.personalizationDecision!.decisionId,
          strategy: state.recommendationStrategy!,
        ),
      );
    }
    return const SizedBox(key: ValueKey<String>('ai_empty'));
  }

  // endregion

  // region Buying information

  Widget _buyingOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (product.selectedColor != null) ...<Widget>[
          Row(
            children: <Widget>[
              BzText(
                '${ss.color}: ${product.selectedColor!.title}',
                style: context.body1Medium.copyWith(color: context.scheme().titleText),
              ),
              const HGap(8),
              Container(
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  color: _parseColor(product.selectedColor!.hexColor),
                  shape: BoxShape.circle,
                  border: Border.all(color: context.scheme().boxBorder),
                ),
              ),
            ],
          ),
          const VGap(16),
        ],
        if (product.seller != null) ...<Widget>[
          BzText('${ss.seller}:', style: context.body1Medium.copyWith(color: context.scheme().titleText)),
          const VGap(16),
          _seller(context, product.seller!),
        ],
      ],
    );
  }

  Widget _seller(BuildContext context, SellerEntity seller) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.scheme().mainBackground4,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.scheme().boxBorder),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.storefront_outlined, color: context.scheme().primary, size: 22),
          const HGap(8),
          Expanded(
            child: BzText(seller.name, style: context.body1Bold, overflow: TextOverflow.ellipsis),
          ),
          const HGap(12),
          Expanded(
            child: BzText(
              ss.satisfaction(seller.satisfactionPercent.round(), seller.performance ?? ''),
              style: context.body4Medium.copyWith(color: context.scheme().subText),
            ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String hexColor) {
    final String value = hexColor.replaceAll('#', '');
    final String withAlpha = value.length == 6 ? 'FF$value' : value;
    return Color(int.tryParse(withAlpha, radix: 16) ?? 0xFF000000);
  }

  // endregion

  // region Personalized information

  Widget _highlightedInformation(BuildContext context, {required Widget child}) {
    final bool shouldHighlight =
        state.personalizationDecision?.action == PersonalizationAction.highlightReviewsAndSpecifications;
    if (!shouldHighlight) return child;

    return AiPersonalizationCard(title: ss.aiProductDetails, child: child);
  }

  // endregion
}
