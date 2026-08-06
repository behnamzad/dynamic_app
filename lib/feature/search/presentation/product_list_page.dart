import 'package:dynamic_app/core/presentation/widget/app/product_widget.dart';
import 'package:dynamic_app/core/util/common_ui_imports.dart';
import 'package:dynamic_app/feature/search/presentation/bloc/search_bloc.dart';
import 'package:dynamic_app/shared/category/domain/entities/category_entity.dart';

@RoutePage()
class ProductListPage extends StatelessWidget implements AutoRouteWrapper {
  final CategoryEntity categoryEntity;
  final SearchBloc searchBloc;

  const ProductListPage({super.key, required this.categoryEntity, required this.searchBloc});

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider.value(value: searchBloc, child: this);

  @override
  Widget build(BuildContext context) {
    return BasePageWidget(
      appBar: BzAppBar(title: categoryEntity.name),
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          final products = state.result?.products;
          if (products == null) return const SizedBox.shrink();

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) => ProductWidget.row(entity: products[index]),
          );
        },
      ),
    );
  }
}
