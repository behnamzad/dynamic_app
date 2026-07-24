part of 'product_list_bloc.dart';

@freezed
class ProductListEvent with _$ProductListEvent {
  const factory ProductListEvent.init() = _Init;

  const factory ProductListEvent.getProductAndBrandsByCategory({required CategoryEntity entity, int? page}) = _GetProductAndBrandsByCategory;
}
