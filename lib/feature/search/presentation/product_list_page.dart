import 'package:dynamic_app/core/presentation/widget/app/product_widget.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/search/presentation/bloc/search_bloc.dart';
import 'package:dynamic_app/shared/behavior/data/mapper/product_behavior_snapshot_mapper.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_payload.dart';
import 'package:dynamic_app/shared/behavior/domain/entities/behavior_event_type.dart';
import 'package:dynamic_app/shared/behavior/domain/factory/behavior_event_draft_factory.dart';
import 'package:dynamic_app/shared/behavior/domain/manager/behavior_logger.dart';
import 'package:dynamic_app/shared/category/domain/entities/category_entity.dart';

@RoutePage()
class ProductListPage extends StatefulWidget implements AutoRouteWrapper {
  final CategoryEntity categoryEntity;
  final SearchBloc searchBloc;

  const ProductListPage({
    super.key,
    required this.categoryEntity,
    required this.searchBloc,
  });

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocProvider.value(value: searchBloc, child: this);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late final BehaviorLogger _behaviorLogger;
  late final DateTime _openedAt;

  @override
  void initState() {
    super.initState();
    _behaviorLogger = inject<BehaviorLogger>();
    _openedAt = DateTime.now();
    _behaviorLogger.recordNonBlocking(
      BehaviorEventDraftFactory.categoryOrBrand(
        type: BehaviorEventType.categoryView,
        product: widget.categoryEntity.toBehaviorSnapshot(),
        sourceScreen: 'category_product_list',
        payload: const CategoryBrandBehaviorPayload(
          displaySource: 'home_category_section',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _behaviorLogger.recordNonBlocking(
      BehaviorEventDraftFactory.categoryOrBrand(
        type: BehaviorEventType.categoryViewEnd,
        product: widget.categoryEntity.toBehaviorSnapshot(),
        sourceScreen: 'category_product_list',
        durationMs: DateTime.now().difference(_openedAt).inMilliseconds,
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasePageWidget(
      appBar: BzAppBar(title: widget.categoryEntity.name),
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          final products = state.result?.products;
          if (products == null) return const SizedBox.shrink();

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) => ProductWidget.row(
              entity: products[index],
              sourceScreen: 'category_product_list',
              position: index,
            ),
          );
        },
      ),
    );
  }
}
