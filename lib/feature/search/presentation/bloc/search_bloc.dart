import 'package:dynamic_app/core/util/common_bloc_imports.dart';
import 'package:dynamic_app/shared/category/domain/entities/category_entity.dart';
import 'package:dynamic_app/shared/product/domain/entities/brand_entity.dart';
import 'package:dynamic_app/shared/product/domain/entities/search_result_entity.dart';
import 'package:dynamic_app/shared/product/domain/repository/product_repo.dart';

part 'search_bloc.freezed.dart';
part 'search_event.dart';
part 'search_state.dart';

@injectable
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ProductRepo _productRepo;
  int _requestId = 0;

  SearchBloc(this._productRepo) : super(SearchState.initial()) {
    on<_Search>(_onSearch);
    on<_GetProductByCategory>(_onGetProductByCategory);
    on<_GetProductByBrand>(_onGetProductByBrand);
  }

  Future<void> _onSearch(_Search event, Emitter<SearchState> emit) async {
    final query = event.query.trim();
    if (query.isEmpty) return;

    final requestId = ++_requestId;
    emit(
      state.copyWith(
        status: SearchStatus.loading,
        query: query,
        categoryEntity: null,
        brandEntity: null,
        errorMessage: null,
      ),
    );

    final response = await _productRepo.search(query: query, page: event.page);
    if (requestId != _requestId) return;

    switch (response) {
      case Success<SearchResultEntity>(data: final result):
        emit(state.copyWith(status: SearchStatus.loaded, query: query, result: result, errorMessage: null));
      case Failure<SearchResultEntity>(error: final error):
        emit(state.copyWith(status: SearchStatus.failed, query: query, errorMessage: error.message));
    }
  }

  Future<void> _onGetProductByCategory(_GetProductByCategory event, Emitter<SearchState> emit) async {
    final requestId = ++_requestId;
    emit(
      state.copyWith(status: SearchStatus.loading, categoryEntity: event.entity, brandEntity: null, errorMessage: null),
    );

    final response = await _productRepo.getProductByCategory(categoryId: event.entity.id, page: event.page);
    if (requestId != _requestId) return;

    _emitResult(response, emit);
  }

  Future<void> _onGetProductByBrand(_GetProductByBrand event, Emitter<SearchState> emit) async {
    emit(state.copyWith(query: ''));
    final requestId = ++_requestId;
    emit(
      state.copyWith(status: SearchStatus.loading, categoryEntity: null, brandEntity: event.entity, errorMessage: null),
    );

    final response = await _productRepo.getProductByBrand(brandId: event.entity.id, page: event.page);
    if (requestId != _requestId) return;

    _emitResult(response, emit);
  }

  void _emitResult(Result<SearchResultEntity> response, Emitter<SearchState> emit) {
    switch (response) {
      case Success<SearchResultEntity>(data: final result):
        emit(state.copyWith(status: SearchStatus.loaded, result: result, errorMessage: null));
      case Failure<SearchResultEntity>(error: final error):
        emit(state.copyWith(status: SearchStatus.failed, errorMessage: error.message));
    }
  }
}
