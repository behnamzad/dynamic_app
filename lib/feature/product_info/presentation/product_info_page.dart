import 'package:carousel_slider/carousel_controller.dart';
import 'package:dynamic_app/core/presentation/widget/bz_info_chip.dart';
import 'package:dynamic_app/core/presentation/widget/bz_slider_widget.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/product_info/presentation/bloc/product_info_bloc.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';

@RoutePage()
class ProductInfoPage extends StatefulWidget implements AutoRouteWrapper {
  final ProductEntity product;

  const ProductInfoPage({super.key, required this.product});

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
    create: (_) => inject<ProductInfoBloc>()..add(const ProductInfoEvent.init(productId: 17986495)),
    child: this,
  );

  @override
  State<ProductInfoPage> createState() => _ProductInfoPageState();
}

class _ProductInfoPageState extends State<ProductInfoPage> {
  late ProductEntity _product;
  late CarouselSliderController _carouselSliderController;

  @override
  void initState() {
    _product = widget.product;
    _carouselSliderController = CarouselSliderController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductInfoBloc, ProductInfoState>(
      listener: (context, state) {
        if (state.status.isFailed || state.specificationStatus.isFailed) {
          showToastError(state.errorMessage!, bottomPadding: Dimen.bottomToastPadding);
        }
        if (state.status.isLoaded) {
          _product = state.productEntity!;
        }
      },
      builder: (context, state) {
        return BasePageWidget.withOnScreenAndOverLayLoading(
          onScreenLoadingModeShowFailureByState: state.status.isFailed,
          onScreenLoadingModeShowCircularLoadingByState: state.status.isLoading,
          onScreenLoadingOnTryAgainCLick: () =>
              context.read<ProductInfoBloc>().add(ProductInfoEvent.init(entity: widget.product)),

          child: state.status.isLoaded ? _body(context, state) : const SizedBox(),
        );
      },
    );
  }

  //region Widgets
  Widget _body(BuildContext context, ProductInfoState state) {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.only(bottom: 100),
          children: [_topBar(context), _breadcrumb(context), _productImage(context), _productInfoCard(context, state)],
        ),
        Align(alignment: Alignment.bottomCenter, child: _addToCart(context)),
      ],
    );
  }

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 4),
      child: Row(
        children: [
          BzGestureDetector(
            onTap: () => context.maybePop(),
            child: Icon(Icons.close_rounded, color: context.scheme().profileIcon, size: 28),
          ),
          const Spacer(),
          Icon(Icons.search_rounded, color: context.scheme().profileIcon, size: 28),
          const HGap(18),
          Icon(Icons.shopping_cart_outlined, color: context.scheme().profileIcon, size: 28),
          const HGap(18),
          Icon(Icons.more_vert_rounded, color: context.scheme().profileIcon, size: 28),
        ],
      ),
    );
  }

  Widget _breadcrumb(BuildContext context) {
    if (_product.breadcrumbs.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate((_product.breadcrumbs.length * 2) - 1, (index) {
          if (index.isEven) {
            BreadcrumbEntity breadcrumb = _product.breadcrumbs.reversed.toList()[index ~/ 2];
            return BzText(breadcrumb.title, style: context.body2Medium.copyWith(color: context.scheme().subText));
          }

          return Icon(Icons.chevron_right_rounded, size: 18, color: context.scheme().subText);
        }),
      ),
    );
  }

  Widget _productImage(BuildContext context) {
    final List<String> images = _product.images.where((String image) => image.isNotEmpty).toList();

    if (images.isEmpty) {
      return SizedBox(
        height: 320,
        child: Center(child: Icon(Icons.image_not_supported_outlined, size: 80, color: context.scheme().selectIcon)),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: BzSlider(
            height: Dimen.productInfoImageHeight,
            itemList: List.generate(images.length, (int index) {
              final String imageUrl = images[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Image.network(imageUrl, fit: BoxFit.contain),
              );
            }),
            enlargeFactor: 0.2,
            viewportFraction: 1,
            indicatorIntoSlider: false,
            controller: _carouselSliderController,
            showIndicator: false,
            onPageChanged: (int index) {},
          ),
        ),
      ],
    );
  }

  Widget _productInfoCard(BuildContext context, ProductInfoState state) {
    return Container(
      decoration: BoxDecoration(
        color: context.scheme().mainBackground1,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        border: Border(top: BorderSide(color: context.scheme().divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                width: 52,
                height: 5,
                margin: const EdgeInsets.only(top: 10, bottom: 16),
                decoration: BoxDecoration(color: context.scheme().divider, borderRadius: BorderRadius.circular(8)),
              ),
            ),
            _productActions(context),
            _productHeaders(context),
            _productMeta(context),
            const VGap(20),
            const BzDivider(),
            _productOptions(context),
            const VGap(20),
            _specificationsTable(context, state),
            const VGap(20),
            _commentsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _productActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(Icons.favorite_border_rounded, color: context.scheme().profileIcon, size: 26),
          const HGap(24),
          Icon(Icons.share_outlined, color: context.scheme().profileIcon, size: 24),
        ],
      ),
    );
  }

  Widget _productHeaders(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: BzText(
                  _product.brandName,
                  style: context.body2Medium.copyWith(color: context.scheme().subText),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const HGap(6),
              Icon(Icons.chevron_right_rounded, size: 18, color: context.scheme().subText),
              const HGap(6),
              BzText(
                '${_product.categoryTitle} ${_product.brandName}',
                style: context.body2Medium.copyWith(color: context.scheme().subText),
              ),
            ],
          ),
          const VGap(12),
          BzText(
            _product.titleFa,
            style: context.title1Bold.copyWith(color: context.scheme().titleText),
            textAlign: TextAlign.right,
            overflow: TextOverflow.clip,
          ),
        ],
      ),
    );
  }

  Widget _productMeta(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(
        children: [
          BzInfoChip(
            text: '${_product.rate.toStringAsFixed(1)} (${_product.rateCount})',
            icon: Icons.star_rounded,
            iconColor: Colors.amber,
          ),
          const HGap(8),
          BzInfoChip(text: '${_product.commentCount} دیدگاه', icon: Icons.rate_review_outlined),
          const HGap(8),
          BzInfoChip(text: '${_product.questionCount} پرسش', icon: Icons.help_outline_rounded),
        ],
      ),
    );
  }

  Widget _productOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_product.selectedColor != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BzText(
                _product.selectedColor!.title,
                style: context.title1Bold.copyWith(color: context.scheme().titleText),
              ),
              BzText('رنگ: ', style: context.title1Bold.copyWith(color: context.scheme().titleText)),
              const HGap(8),
              Container(
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  color: _colorFromHex(_product.selectedColor!.hexColor),
                  shape: BoxShape.circle,
                  border: Border.all(color: context.scheme().boxBorder),
                ),
              ),
            ],
          ),
          const VGap(16),
        ],
        if (_product.seller != null) _sellerBox(context),
      ],
    );
  }

  Widget _sellerBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.scheme().mainBackground4,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.scheme().boxBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: BzText(_product.seller!.name, style: context.body1Bold, overflow: TextOverflow.ellipsis),
              ),
              const HGap(8),
              Icon(Icons.storefront_outlined, color: context.scheme().primary, size: 22),
            ],
          ),
          const VGap(8),
          BzText(
            '${_product.seller!.satisfactionPercent.toStringAsFixed(0)}٪ رضایت | ${_product.seller!.performance ?? ''}',
            style: context.body4Medium.copyWith(color: context.scheme().subText),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _productDes(BuildContext context, ProductInfoState state) {
    final List<ProductSpecificationEntity> specifications =
        state.productSpecificationEntityList ?? _product.specifications;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (specifications.isNotEmpty) ...[
            BzText('مشخصات', style: context.title1Bold),
            const VGap(10),
            ...specifications.expand((ProductSpecificationEntity specification) => specification.items).take(4).map((
              ProductSpecificationItemEntity item,
            ) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: BzInfoChip(text: '${item.title}: ${item.values.join('، ')}'),
              );
            }),
            const VGap(8),
          ],
          if ((_product.review?.description ?? '').isNotEmpty) ...[
            BzText(ss.description, style: context.title1Bold),
            const VGap(8),
            BzText(_product.review!.description, style: context.body2Regular, textAlign: TextAlign.justify),
          ],
        ],
      ),
    );
  }

  Widget _specificationsTable(BuildContext context, ProductInfoState state) {
    final List<ProductSpecificationItemEntity> items = (state.productSpecificationEntityList ?? _product.specifications)
        .expand((ProductSpecificationEntity specification) => specification.items)
        .where((ProductSpecificationItemEntity item) => item.values.isNotEmpty)
        .take(5)
        .toList();

    if (items.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BzText(_product.specifications.first.groupTitle, style: context.title1Bold.copyWith(color: context.scheme().titleText)),
        const VGap(14),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            children: items.map((ProductSpecificationItemEntity item) {
              return IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: context.scheme().divider)),
                        ),
                        child: BzText(
                            item.title,

                          style: context.body2Medium.copyWith(color: context.scheme().mainText),
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: context.scheme().mainBackground4,
                          border: Border(bottom: BorderSide(color: context.scheme().divider)),
                        ),
                        child: BzText(
                          item.values.join(', '),
                          style: context.body2Bold.copyWith(color: context.scheme().mainText),
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _commentsSection(BuildContext context) {
    final List<ProductCommentEntity> comments = _product.comments.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            BzText('دیدگاه کاربران', style: context.title1Bold.copyWith(color: context.scheme().titleText)),
            const Spacer(),
          ],
        ),
        const VGap(20),
        Row(
          children: [
            const Icon(Icons.star_rounded, color: Colors.amber, size: 30),
            const HGap(4),
            BzText(
              _product.rate.toStringAsFixed(1),
              style: context.headline4Bold.copyWith(color: context.scheme().titleText),
            ),
            const HGap(8),
            BzText(
              '(بر اساس نظر ${_product.rateCount} خریدار)',
              style: context.body4Medium.copyWith(color: context.scheme().subText),
            ),
          ],
        ),
        const VGap(18),
        SizedBox(
          height: 210,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _commentsSummaryCard(context),
              const HGap(10),
              ...comments.map((ProductCommentEntity comment) {
                return Padding(padding: const EdgeInsets.only(right: 10), child: _commentCard(context, comment));
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _commentsSummaryCard(BuildContext context) {
    final String summary = _product.review?.shortReview ?? _product.review?.description ?? _product.titleFa;

    return Container(
      width: 250,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: context.scheme().purpleBackground, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome_rounded, color: context.scheme().primary, size: 24),
              const HGap(8),
              Expanded(
                child: BzText(
                  'خلاصه دیدگاه‌های خریداران',
                  style: context.body1Bold.copyWith(color: context.scheme().primary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const VGap(14),
          BzText(
            summary,
            style: context.body3Medium.copyWith(color: context.scheme().mainText, height: 1.7),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          BzText('مشاهده بیشتر', style: context.body3Bold.copyWith(color: context.scheme().mainText)),
        ],
      ),
    );
  }

  Widget _commentCard(BuildContext context, ProductCommentEntity comment) {
    return Container(
      width: 156,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.scheme().mainBackground1,
        border: Border.all(color: context.scheme().divider),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BzText(comment.userName, style: context.body3Medium.copyWith(color: context.scheme().mainText), maxLines: 1),
          const VGap(12),
          Row(children: List.generate(5, (int index) => const Icon(Icons.star_rounded, color: Colors.amber, size: 18))),
          const VGap(10),
          BzText(
            comment.body,
            style: context.body4Regular.copyWith(color: context.scheme().mainText, height: 1.6),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          BzText('مشاهده بیشتر', style: context.body4Bold.copyWith(color: context.scheme().mainText)),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _rateProduct(BuildContext context) {
    return Wrap(
      children: [
        const Icon(Icons.star, size: 24, color: Colors.amber),
        const HGap(4),
        BzText(_product.rate.toString(), style: context.body1Medium.copyWith(color: context.scheme().titleText)),
        const HGap(4),
        BzText(
          '(${ss.rateCount(_product.rateCount)})',
          style: context.body2Medium.copyWith(color: context.scheme().subText),
        ),
        BzText(
          '(${ss.review} ${_product.commentCount})',
          style: context.body2Medium.copyWith(color: context.scheme().subText),
        ),

        BzText(
          '(${ss.question} ${_product.questionCount})',
          style: context.body2Medium.copyWith(color: context.scheme().subText),
        ),
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
            Expanded(
              flex: 3,
              child: BzButton.submit(text: _product.available ? ss.addToCart : 'ناموجود', onPressed: () {}),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BzTextCurrency.amountWithTitle(
                    amount: _product.price,
                    currencyUnitStyle: context.body3Medium.copyWith(color: context.scheme().primary),
                    style: context.headline5Bold.copyWith(color: context.scheme().primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _colorFromHex(String hexColor) {
    final String colorText = hexColor.replaceAll('#', '');
    final String normalizedColor = colorText.length == 6 ? 'FF$colorText' : colorText;
    final int? colorValue = int.tryParse(normalizedColor, radix: 16);

    return Color(colorValue ?? 0xFF000000);
  }
}
