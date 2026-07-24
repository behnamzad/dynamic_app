import 'package:dynamic_app/core/presentation/widget/app/product_widget.dart';
import 'package:dynamic_app/core/presentation/widget/bz_retry_widget.dart';
import 'package:dynamic_app/core/presentation/widget/bz_shimmer_loading_widget.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/product_list/presentation/bloc/product_list_bloc.dart';
import 'package:dynamic_app/shared/category/domain/entities/category_entity.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';

class HorizontalProductList extends StatefulWidget implements AutoRouteWrapper {
  final CategoryEntity categoryEntity;

  const HorizontalProductList({super.key, required this.categoryEntity});

  @override
  State<HorizontalProductList> createState() => _HorizontalProductListState();

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
    key: ValueKey('horizontal-product-list-${categoryEntity.id}'),
    create: (context) =>
        inject<ProductListBloc>()..add(ProductListEvent.getProductAndBrandsByCategory(entity: categoryEntity)),
    child: this,
  );
}

class _HorizontalProductListState extends State<HorizontalProductList>
    with AutomaticKeepAliveClientMixin<HorizontalProductList> {
  static const double _headerHeight = 52;
  static const double _sectionHeight = _headerHeight + Dimen.productCardHeight;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocConsumer<ProductListBloc, ProductListState>(
      listener: (context, state) {},
      builder: (context, state) {
        return SizedBox(
          height: _sectionHeight,
          width: double.infinity,
          child: switch (state.productByCategoryStatus) {
            ProductListStatus.initial || ProductListStatus.loading => _loadingBody(context),
            ProductListStatus.loaded => _loadedBody(context, state),
            ProductListStatus.failed => _failedLoad(context),
          },
        );
      },
    );
  }

  Widget _loadedBody(BuildContext context, ProductListState state) {
    return Column(
      children: [
        SizedBox(
          height: _headerHeight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                BzText(
                  state.categoryEntity!.name,
                  style: context.body2Bold.copyWith(color: context.scheme().titleText),
                ),
                const Spacer(),
                BzGestureDetector(
                  onTap: () => context.pushRoute(
                    ProductListPageRoute(products: state.loadedProduct, categoryEntity: state.categoryEntity!),
                  ),
                  child: Row(
                    children: [
                      BzText(ss.seeMore, style: context.body3Medium.copyWith(color: context.scheme().mainText)),
                      const HGap(4),
                      Icon(Icons.arrow_forward_ios, size: 14, color: context.scheme().titleText),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: Dimen.productCardHeight,
          child: ColoredBox(
            color: context.scheme().primaryBold,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.horizontalProduct.length,
              itemBuilder: (context, index) {
                final ProductEntity entity = state.horizontalProduct[index];
                return ProductWidget.card(entity: entity);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _loadingBody(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: _headerHeight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                BzShimmerLoadingWidget(height: 18, width: 90, isLoading: true, child: SizedBox.shrink()),
                Spacer(),
                BzShimmerLoadingWidget(height: 18, width: 70, isLoading: true, child: SizedBox.shrink()),
              ],
            ),
          ),
        ),
        SizedBox(
          height: Dimen.productCardHeight,
          child: ColoredBox(
            color: context.scheme().primaryBold,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              itemBuilder: (context, index) {
                return const BzShimmerLoadingWidget(
                  width: Dimen.productCardWidth,
                  height: Dimen.productCardHeight - 16,
                  padding: EdgeInsets.all(8),
                  borderRadius: Dimen.defaultRadius,
                  isLoading: true,
                  child: SizedBox.shrink(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _failedLoad(BuildContext context) {
    return BzRetryWidget(
      onRetryClick: () {
        context.read<ProductListBloc>().add(
          ProductListEvent.getProductAndBrandsByCategory(entity: widget.categoryEntity),
        );
      },
    );
  }
}
