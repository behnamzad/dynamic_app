import 'package:dynamic_app/core/presentation/widget/app/product_widget.dart';
import 'package:dynamic_app/core/presentation/widget/bz_retry_widget.dart';
import 'package:dynamic_app/core/presentation/widget/bz_shimmer_loading_widget.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/search/presentation/bloc/search_bloc.dart';
import 'package:dynamic_app/shared/behavior/data/mapper/product_behavior_snapshot_mapper.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_payload.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_type.dart';
import 'package:dynamic_app/shared/behavior/domain/factory/behavior_event_draft_factory.dart';
import 'package:dynamic_app/shared/behavior/domain/manager/behavior_logger.dart';
import 'package:dynamic_app/shared/category/domain/entities/category_entity.dart';

class HorizontalProductList extends StatefulWidget implements AutoRouteWrapper {
  final CategoryEntity categoryEntity;

  const HorizontalProductList({super.key, required this.categoryEntity});

  @override
  State<HorizontalProductList> createState() => _HorizontalProductListState();

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
    key: ValueKey('horizontal-product-list-${categoryEntity.id}'),
    create: (_) =>
        inject<SearchBloc>()
          ..add(SearchEvent.getProductByCategory(entity: categoryEntity)),
    child: this,
  );
}

class _HorizontalProductListState extends State<HorizontalProductList>
    with AutomaticKeepAliveClientMixin<HorizontalProductList> {
  static const double _headerHeight = 52;
  static const double _sectionHeight = _headerHeight + Dimen.productCardHeight;
  late final BehaviorLogger _behaviorLogger;
  bool _categoryImpressionRecorded = false;

  @override
  void initState() {
    super.initState();
    _behaviorLogger = inject<BehaviorLogger>();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) => SizedBox(
        height: _sectionHeight,
        width: double.infinity,
        child: switch (state.status) {
          SearchStatus.initial || SearchStatus.loading => _loadingBody(context),
          SearchStatus.loaded => _loadedBody(context, state),
          SearchStatus.failed => _failedLoad(context),
        },
      ),
    );
  }

  Widget _loadedBody(BuildContext context, SearchState state) {
    final products = state.result!.products.take(10).toList(growable: false);
    if (!_categoryImpressionRecorded) {
      _categoryImpressionRecorded = true;
      _behaviorLogger.recordNonBlocking(
        BehaviorEventDraftFactory.categoryOrBrand(
          type: BehaviorEventType.categoryImpression,
          product: widget.categoryEntity.toBehaviorSnapshot(),
          sourceScreen: 'home_shop',
          payload: CategoryBrandBehaviorPayload(
            displaySource: 'home_category_section',
            visibleProductIds: products
                .map((product) => product.id.toString())
                .toList(growable: false),
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: _headerHeight,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                BzText(
                  widget.categoryEntity.name,
                  style: context.body2Bold.copyWith(
                    color: context.scheme().titleText,
                  ),
                ),
                const Spacer(),
                BzGestureDetector(
                  onTap: () {
                    _behaviorLogger.recordNonBlocking(
                      BehaviorEventDraftFactory.categoryOrBrand(
                        type: BehaviorEventType.categoryClick,
                        product: widget.categoryEntity.toBehaviorSnapshot(),
                        sourceScreen: 'home_shop',
                        payload: const CategoryBrandBehaviorPayload(
                          displaySource: 'home_category_section',
                        ),
                      ),
                    );
                    context.pushRoute(
                      ProductListPageRoute(
                        categoryEntity: widget.categoryEntity,
                        searchBloc: context.read<SearchBloc>(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      BzText(
                        ss.seeMore,
                        style: context.body3Medium.copyWith(
                          color: context.scheme().mainText,
                        ),
                      ),
                      const HGap(4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: context.scheme().titleText,
                      ),
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
              itemCount: products.length,
              itemBuilder: (context, index) => ProductWidget.card(
                entity: products[index],
                sourceScreen: 'home_category_section',
                position: index,
              ),
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
                BzShimmerLoadingWidget(
                  height: 18,
                  width: 90,
                  isLoading: true,
                  child: SizedBox.shrink(),
                ),
                Spacer(),
                BzShimmerLoadingWidget(
                  height: 18,
                  width: 70,
                  isLoading: true,
                  child: SizedBox.shrink(),
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
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              itemBuilder: (context, index) => const BzShimmerLoadingWidget(
                width: Dimen.productCardWidth,
                height: Dimen.productCardHeight - 16,
                padding: EdgeInsets.all(8),
                borderRadius: Dimen.defaultRadius,
                isLoading: true,
                child: SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _failedLoad(BuildContext context) {
    return BzRetryWidget(
      onRetryClick: () => context.read<SearchBloc>().add(
        SearchEvent.getProductByCategory(entity: widget.categoryEntity),
      ),
    );
  }
}
