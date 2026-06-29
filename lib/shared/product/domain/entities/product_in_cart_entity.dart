import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';

class ProductInCartEntity{
  final ProductEntity productEntity;
  final int selectedCount;

  ProductInCartEntity({required this.productEntity, required this.selectedCount});
}