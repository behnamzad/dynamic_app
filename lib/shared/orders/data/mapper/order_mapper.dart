import 'package:dynamic_app/shared/orders/data/models/order_dto.dart';
import 'package:dynamic_app/shared/orders/domain/entities/order_entity.dart';

extension OrderItemDtoMapper on OrderItemDto {
  OrderItemEntity toEntity() => OrderItemEntity(
    productId: productId,
    categoryId: categoryId,
    productName: productName,
    imageUrl: imageUrl,
    quantity: quantity,
    unitPrice: unitPrice,
  );
}

extension OrderDtoMapper on OrderDto {
  OrderEntity toEntity() => OrderEntity(
    id: id,
    status: OrderStatus.fromValue(status),
    isPaid: isPaid,
    totalQuantity: totalQuantity,
    subtotalAmount: subtotalAmount,
    discountAmount: discountAmount,
    totalAmount: totalAmount,
    province: province,
    city: city,
    addressLine: addressLine,
    deliveryWindow: deliveryWindow,
    createdAt: createdAt,
    items: items.map((item) => item.toEntity()).toList(growable: false),
  );
}
