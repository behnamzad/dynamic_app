import 'package:dynamic_app/shared/product/data/models/product_specifications/product_specifications_dto.dart';
import 'package:dynamic_app/shared/product/domain/entities/product_entity.dart';

extension ProductSpecificationDtoX on ProductSpecificationDto {
  List<ProductSpecificationEntity> toEntityList() {
    return result.map((group) {
      return ProductSpecificationEntity(
        groupTitle: group.title,
        items: group.attributes.map((attr) {
          return ProductSpecificationItemEntity(title: attr.title, values: attr.values);
        }).toList(),
      );
    }).toList();
  }
}
