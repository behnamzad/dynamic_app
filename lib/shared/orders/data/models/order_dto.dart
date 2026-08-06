class OrderItemDto {
  final int productId;
  final int categoryId;
  final String productName;
  final String imageUrl;
  final int quantity;
  final int unitPrice;

  const OrderItemDto({
    required this.productId,
    required this.categoryId,
    required this.productName,
    required this.imageUrl,
    required this.quantity,
    required this.unitPrice,
  });

  factory OrderItemDto.fromJson(Map<String, dynamic> json) => OrderItemDto(
    productId: int.tryParse(json['product_id'].toString()) ?? 0,
    categoryId: int.tryParse(json['category_id'].toString()) ?? 0,
    productName: json['product_name']?.toString() ?? '',
    imageUrl: json['image_url']?.toString() ?? '',
    quantity: int.tryParse(json['quantity'].toString()) ?? 0,
    unitPrice: int.tryParse(json['unit_price'].toString()) ?? 0,
  );
}

class OrderDto {
  final String id;
  final String status;
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
  final List<OrderItemDto> items;

  const OrderDto({
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

  factory OrderDto.fromJson(Map<String, dynamic> json) {
    final rawItems = json['order_items'] ?? json['items'];
    return OrderDto(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'processing',
      isPaid: json['is_paid'] == true,
      totalQuantity: int.tryParse(json['total_quantity'].toString()) ?? 0,
      subtotalAmount: int.tryParse(json['subtotal_amount'].toString()) ?? 0,
      discountAmount: int.tryParse(json['discount_amount'].toString()) ?? 0,
      totalAmount: int.tryParse(json['total_amount'].toString()) ?? 0,
      province: json['province']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      addressLine: json['address_line']?.toString() ?? '',
      deliveryWindow: json['delivery_window']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      items: rawItems is List
          ? rawItems
                .whereType<Map>()
                .map(
                  (item) =>
                      OrderItemDto.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList(growable: false)
          : const [],
    );
  }
}
