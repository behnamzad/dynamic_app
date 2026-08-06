part of 'search_bloc.dart';

@freezed
class SearchEvent with _$SearchEvent {
  const factory SearchEvent.search({required String query, int? page}) = _Search;

  const factory SearchEvent.getProductByCategory({required CategoryEntity entity, int? page}) = _GetProductByCategory;

  const factory SearchEvent.getProductByBrand({required BrandEntity entity, int? page}) = _GetProductByBrand;
}
