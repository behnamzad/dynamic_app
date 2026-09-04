import 'package:carousel_slider/carousel_controller.dart';
import 'package:dynamic_app/core/presentation/widget/bz_slider_widget.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/product_info/presentation/bloc/product_info_bloc.dart';
import 'package:dynamic_app/feature/product_info/presentation/widget/product_details_card.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';

typedef ProductImageChanged = void Function(int index, int imageCount);

/// بدنه کامل صفحه محصول؛ Page فقط داده و callbackها را به آن می‌دهد.
class ProductInfoContent extends StatelessWidget {
  const ProductInfoContent({
    super.key,
    required this.product,
    required this.state,
    required this.carouselController,
    required this.onClose,
    required this.onImageChanged,
    required this.onScroll,
  });

  final ProductEntity product;
  final ProductInfoState state;
  final CarouselSliderController carouselController;
  final VoidCallback onClose;
  final ProductImageChanged onImageChanged;
  final NotificationListenerCallback<ScrollNotification> onScroll;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: onScroll,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: <Widget>[
          _closeButton(context),
          _breadcrumbs(context),
          _imageGallery(context),
          ProductDetailsCard(product: product, state: state),
        ],
      ),
    );
  }

  // region Navigation

  Widget _closeButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4, left: 16, top: 12, bottom: 4),
      child: Row(
        children: <Widget>[
          BzGestureDetector(
            onTap: onClose,
            child: Icon(Icons.close_rounded, color: context.scheme().profileIcon, size: 28),
          ),
          const Spacer(),
          Icon(Icons.favorite_outline_rounded, color: context.scheme().profileIcon, size: 28),
        ],
      ),
    );
  }

  Widget _breadcrumbs(BuildContext context) {
    if (product.breadcrumbs.isEmpty) return const SizedBox();
    final List<BreadcrumbEntity> breadcrumbs = product.breadcrumbs.reversed.toList(growable: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List<Widget>.generate((breadcrumbs.length * 2) - 1, (int index) {
            if (index.isEven) {
              return BzText(
                breadcrumbs[index ~/ 2].title,
                style: context.body2Medium.copyWith(color: context.scheme().subText),
              );
            }
            return Icon(Icons.chevron_right_rounded, size: 18, color: context.scheme().subText);
          }),
        ),
      ),
    );
  }

  // endregion

  // region Product image

  Widget _imageGallery(BuildContext context) {
    final List<String> images = product.images.where((String image) => image.isNotEmpty).toList(growable: false);
    if (images.isEmpty) {
      return SizedBox(
        height: 320,
        child: Center(child: Icon(Icons.image_not_supported_outlined, size: 80, color: context.scheme().selectIcon)),
      );
    }

    return BzSlider(
      height: Dimen.productInfoImageHeight,
      itemList: images
          .map(
            (String imageUrl) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Image.network(imageUrl, fit: BoxFit.contain),
            ),
          )
          .toList(growable: false),
      enlargeFactor: 0.2,
      viewportFraction: 1,
      indicatorIntoSlider: false,
      controller: carouselController,
      autoPlay: false,
      showIndicator: true,
      onPageChanged: (int index) => onImageChanged(index, images.length),
    );
  }

  // endregion
}
