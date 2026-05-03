class OrderItem {
  final String productId;
  final int quantity;

  const OrderItem({required this.productId, required this.quantity});
}

class Order {
  final String id;
  final DateTime orderedOn;
  final DateTime deliveryDate;
  final String status;
  final List<OrderItem> items;
  final double totalAmount;
  final String employeeId;
  final String? doctorId;
  final String? chemistShopId;
  final String? stockistId;

  const Order({
    required this.id,
    required this.orderedOn,
    required this.deliveryDate,
    required this.status,
    required this.items,
    required this.totalAmount,
    required this.employeeId,
    this.doctorId,
    this.chemistShopId,
    this.stockistId,
  });

  Order copyWith({
    String? id,
    DateTime? orderedOn,
    DateTime? deliveryDate,
    String? status,
    List<OrderItem>? items,
    double? totalAmount,
    String? employeeId,
    String? doctorId,
    String? chemistShopId,
    String? stockistId,
  }) {
    return Order(
      id: id ?? this.id,
      orderedOn: orderedOn ?? this.orderedOn,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      status: status ?? this.status,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      employeeId: employeeId ?? this.employeeId,
      doctorId: doctorId ?? this.doctorId,
      chemistShopId: chemistShopId ?? this.chemistShopId,
      stockistId: stockistId ?? this.stockistId,
    );
  }
}
