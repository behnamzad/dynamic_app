import 'package:dynamic_app/core/config/strings.dart';
import 'package:equatable/equatable.dart';

enum OrderStatus {
  processing,
  shipping,
  delivered,
  cancelled;

  static OrderStatus fromValue(String value) => switch (value) {
    'shipping' => OrderStatus.shipping,
    'delivered' => OrderStatus.delivered,
    'cancelled' => OrderStatus.cancelled,
    _ => OrderStatus.processing,
  };

  String get title => switch (this) {
    OrderStatus.processing => ss.orderStatusProcessing,
    OrderStatus.shipping => ss.orderStatusShipping,
    OrderStatus.delivered => ss.orderStatusDelivered,
    OrderStatus.cancelled => ss.orderStatusCancelled,
  };
}

class OrderItemEntity extends Equatable {
  final int productId;
  final int categoryId;
  final String productName;
  final String imageUrl;
  final int quantity;
  final int unitPrice;

  const OrderItemEntity({
    required this.productId,
    required this.categoryId,
    required this.productName,
    required this.imageUrl,
    required this.quantity,
    required this.unitPrice,
  });

  int get totalPrice => quantity * unitPrice;

  @override
  List<Object?> get props => [
    productId,
    categoryId,
    productName,
    imageUrl,
    quantity,
    unitPrice,
  ];
}

class OrderEntity extends Equatable {
  final String id;
  final OrderStatus status;
  final bool isPaid;
  final int totalQuantity;
  final int subtotalAmount;
  final int discountAmount;
  final int totalAmount;
  final String province;
  final String city;
  final String addressLine;
  final String deliveryWindow;
  final DateTime? createdAt;
  final List<OrderItemEntity> items;

  const OrderEntity({
    required this.id,
    required this.status,
    required this.isPaid,
    required this.totalQuantity,
    required this.subtotalAmount,
    required this.discountAmount,
    required this.totalAmount,
    required this.province,
    required this.city,
    required this.addressLine,
    required this.deliveryWindow,
    required this.createdAt,
    required this.items,
  });

  @override
  List<Object?> get props => [
    id,
    status,
    isPaid,
    totalQuantity,
    subtotalAmount,
    discountAmount,
    totalAmount,
    province,
    city,
    addressLine,
    deliveryWindow,
    createdAt,
    items,
  ];
}
