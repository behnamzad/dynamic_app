import 'package:dynamic_app/core/presentation/widget/app/product_widget.dart';
import 'package:dynamic_app/core/presentation/widget/bz_retry_widget.dart';
import 'package:dynamic_app/core/presentation/widget/bz_search_bar_widget.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/search/presentation/bloc/search_bloc.dart';
import 'package:dynamic_app/shared/behavior/data/mapper/product_behavior_snapshot_mapper.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_payload.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_type.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_product_snapshot.dart';
import 'package:dynamic_app/shared/behavior/domain/factory/behavior_event_draft_factory.dart';
import 'package:dynamic_app/shared/behavior/domain/manager/behavior_logger.dart';
import 'package:dynamic_app/shared/product/domain/entities/brand_entity.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';
import 'package:dynamic_app/shared/product/domain/entities/search_result_entity.dart';

class SearchPage extends StatefulWidget implements AutoRouteWrapper {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(create: (_) => inject<SearchBloc>(), child: this);
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  late final BehaviorLogger _behaviorLogger;
  String? _lastSubmittedQuery;

  @override
  void initState() {
    super.initState();
    _behaviorLogger = inject<BehaviorLogger>();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePageWidget(
      child: Column(
        children: [
          BzSearchBarWidget(
            hint: ss.searchHint,
            isEditMode: false,
            searchBoxAutoFocus: false,
            searchCtrl: _searchController,
            onBackClick: () => FocusScope.of(context).unfocus(),
            onSearchClick: _submit,
          ),
          Expanded(
            child: BlocConsumer<SearchBloc, SearchState>(
              listenWhen: (previous, current) => previous.status != current.status || previous.query != current.query,
              listener: (context, state) {
                _searchController.text = state.query;
                if (state.query.isNotEmpty && state.status.isLoaded) {
                  _recordSearchResults(state);
                } else if (state.brandEntity != null && state.status.isLoaded) {
                  _recordBrandResults(state);
                }
              },
              builder: (context, state) => switch (state.status) {
                SearchStatus.initial => _message(context, ss.searchStartMessage),
                SearchStatus.loading => const Center(child: CircularProgressIndicator()),
                SearchStatus.loaded => _results(context, state.result!, state.query),
                SearchStatus.failed => BzRetryWidget(message: state.errorMessage, onRetryClick: () => _retry(state)),
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _results(BuildContext context, SearchResultEntity result, String query) {
    if (result.brands.isEmpty && result.products.isEmpty) {
      return _message(context, ss.searchEmptyMessage);
    }

    return CustomScrollView(
      slivers: [
        if (result.brands.isNotEmpty) ...[
          PinnedHeaderSliver(
            child: Container(color: context.scheme().mainBackground1, child: _brands(context, result.brands)),
          ),
        ],
        if (result.products.isNotEmpty)
          SliverList.builder(
            itemCount: result.products.length,
            itemBuilder: (context, index) {
              final ProductEntity product = result.products[index];
              return ProductWidget.row(
                entity: product,
                sourceScreen: 'search_results',
                position: index,
                searchQuery: query,
              );
            },
          ),
      ],
    );
  }

  Widget _brands(BuildContext context, List<BrandEntity> brands) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 48,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          scrollDirection: Axis.horizontal,
          itemCount: brands.length,
          separatorBuilder: (_, _) => const HGap(4),
          itemBuilder: (context, index) {
            final brand = brands[index];
            return BzGestureDetector(
              onTap: () {
                final snapshot = BehaviorProductSnapshot(brandId: brand.id.toString(), brandName: brand.titleFa);
                _behaviorLogger.recordNonBlocking(
                  BehaviorEventDraftFactory.categoryOrBrand(
                    type: BehaviorEventType.brandClick,
                    product: snapshot,
                    sourceScreen: 'search_results',
                    position: index,
                    payload: CategoryBrandBehaviorPayload(displaySource: 'search_results', displayRank: index),
                  ),
                );
                context.read<SearchBloc>().add(SearchEvent.getProductByBrand(entity: brand));
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: context.scheme().mainBackground2,
                  border: Border.all(color: context.scheme().divider),
                  borderRadius: BorderRadius.circular(Dimen.defaultRadius),
                ),
                child: BzText(brand.titleFa, style: context.body3Medium.copyWith(color: context.scheme().mainText)),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _message(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: BzText(
          message,
          style: context.body2Medium.copyWith(color: context.scheme().subText),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _submit() {
    _search(_searchController.text);
  }

  void _search(String query) {
    final normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) return;

    final previousQuery = _lastSubmittedQuery;
    final eventType = previousQuery != null && previousQuery != normalizedQuery
        ? BehaviorEventType.searchRefined
        : BehaviorEventType.searchSubmitted;
    _behaviorLogger.recordNonBlocking(
      BehaviorEventDraftFactory.search(
        type: eventType,
        sourceScreen: 'search',
        payload: SearchBehaviorPayload(
          query: normalizedQuery,
          normalizedQuery: normalizedQuery.toLowerCase(),
          previousQuery: eventType == BehaviorEventType.searchRefined ? previousQuery : null,
        ),
      ),
    );
    _lastSubmittedQuery = normalizedQuery;

    FocusScope.of(context).unfocus();
    context.read<SearchBloc>().add(SearchEvent.search(query: normalizedQuery));
  }

  void _recordSearchResults(SearchState state) {
    final result = state.result;
    if (result == null) return;
    final products = result.products;
    final snapshots = products.map((product) => product.toBehaviorSnapshot()).toList(growable: false);
    final payload = SearchBehaviorPayload(
      query: state.query,
      normalizedQuery: state.query.toLowerCase(),
      resultCount: products.length,
      resultProductIds: products.map((product) => product.id.toString()).toList(growable: false),
      resultSnapshots: snapshots,
    );
    _behaviorLogger.recordNonBlocking(
      BehaviorEventDraftFactory.search(
        type: products.isEmpty && result.brands.isEmpty
            ? BehaviorEventType.searchNoResults
            : BehaviorEventType.searchResultsImpression,
        sourceScreen: 'search_results',
        payload: payload,
      ),
    );
  }

  void _recordBrandResults(SearchState state) {
    final brand = state.brandEntity;
    final products = state.result?.products;
    if (brand == null || products == null) return;
    _behaviorLogger.recordNonBlocking(
      BehaviorEventDraftFactory.categoryOrBrand(
        type: BehaviorEventType.brandView,
        product: BehaviorProductSnapshot(brandId: brand.id.toString(), brandName: brand.titleFa),
        sourceScreen: 'search_results',
        payload: CategoryBrandBehaviorPayload(
          displaySource: 'search_brand_filter',
          visibleProductIds: products.map((product) => product.id.toString()).toList(growable: false),
        ),
      ),
    );
  }

  void _retry(SearchState state) {
    final brand = state.brandEntity;
    if (brand != null) {
      context.read<SearchBloc>().add(SearchEvent.getProductByBrand(entity: brand));
      return;
    }
    if (state.query.isNotEmpty) {
      context.read<SearchBloc>().add(SearchEvent.search(query: state.query));
    }
  }
}
