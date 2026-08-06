import 'package:dynamic_app/core/presentation/widget/app/product_widget.dart';
import 'package:dynamic_app/core/presentation/widget/bz_retry_widget.dart';
import 'package:dynamic_app/core/presentation/widget/bz_search_bar_widget.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/search/presentation/bloc/search_bloc.dart';
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
              listener: (context, state) {
                _searchController.text = state.query;
              },
              builder: (context, state) => switch (state.status) {
                SearchStatus.initial => _message(context, ss.searchStartMessage),
                SearchStatus.loading => const Center(child: CircularProgressIndicator()),
                SearchStatus.loaded => _results(context, state.result!),
                SearchStatus.failed => BzRetryWidget(message: state.errorMessage, onRetryClick: () => _retry(state)),
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _results(BuildContext context, SearchResultEntity result) {
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
              return ProductWidget.row(entity: product);
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
              onTap: () => context.read<SearchBloc>().add(SearchEvent.getProductByBrand(entity: brand)),
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

    FocusScope.of(context).unfocus();
    context.read<SearchBloc>().add(SearchEvent.search(query: normalizedQuery));
  }

  void _retry(SearchState state) {
    final brand = state.brandEntity;
    if (brand != null) {
      context.read<SearchBloc>().add(SearchEvent.getProductByBrand(entity: brand));
      return;
    }
    _search(state.query);
  }
}
