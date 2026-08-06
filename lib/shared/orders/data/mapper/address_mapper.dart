import 'package:dynamic_app/shared/orders/data/models/address_dto.dart';
import 'package:dynamic_app/shared/orders/domain/entities/address_entity.dart';

extension AddressDtoMapper on AddressDto {
  AddressEntity toEntity() => AddressEntity(
    id: id,
    province: province,
    city: city,
    addressLine: addressLine,
    createdAt: createdAt,
  );
}
