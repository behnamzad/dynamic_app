import 'package:equatable/equatable.dart';

class CartTotals extends Equatable {
  final int productCount;
  final int subtotalAmount;
  final int discountAmount;
  final int totalAmount;

  const CartTotals({
    required this.productCount,
    required this.subtotalAmount,
    required this.discountAmount,
    required this.totalAmount,
  });

  const CartTotals.empty()
    : productCount = 0,
      subtotalAmount = 0,
      discountAmount = 0,
      totalAmount = 0;

  @override
  List<Object?> get props => [
    productCount,
    subtotalAmount,
    discountAmount,
    totalAmount,
  ];
}
