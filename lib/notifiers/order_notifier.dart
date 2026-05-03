import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/order.dart';

class OrderState {
  final List<Order> orders;
  final String searchEmployeeQuery;
  final String filterStatus;
  final DateTimeRange? dateRange;

  OrderState({
    this.orders = const [],
    this.searchEmployeeQuery = '',
    this.filterStatus = 'All',
    this.dateRange,
  });

  OrderState copyWith({
    List<Order>? orders,
    String? searchEmployeeQuery,
    String? filterStatus,
    DateTimeRange? dateRange,
    bool clearDateRange = false,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
      searchEmployeeQuery: searchEmployeeQuery ?? this.searchEmployeeQuery,
      filterStatus: filterStatus ?? this.filterStatus,
      dateRange: clearDateRange ? null : (dateRange ?? this.dateRange),
    );
  }
}

class OrderNotifier extends StateNotifier<OrderState> {
  OrderNotifier() : super(OrderState()) {
    _loadMockData();
  }

  void _loadMockData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(orders: [
      Order(
        id: 'ORD-9021',
        orderedOn: DateTime.now().subtract(const Duration(days: 2)),
        deliveryDate: DateTime.now().add(const Duration(days: 1)),
        status: 'pending',
        items: const [OrderItem(productId: '1', quantity: 10), OrderItem(productId: '2', quantity: 5)],
        totalAmount: 15400.50,
        employeeId: 'EMP001',
        chemistShopId: '1', // Matches mock data ID if possible
      ),
      Order(
        id: 'ORD-9022',
        orderedOn: DateTime.now().subtract(const Duration(days: 5)),
        deliveryDate: DateTime.now().subtract(const Duration(days: 1)),
        status: 'completed',
        items: const [OrderItem(productId: '2', quantity: 20)],
        totalAmount: 8200.00,
        employeeId: 'EMP002',
        doctorId: '1',
      ),
      Order(
        id: 'ORD-9023',
        orderedOn: DateTime.now().subtract(const Duration(days: 1)),
        deliveryDate: DateTime.now().add(const Duration(days: 3)),
        status: 'cancelled',
        items: const [OrderItem(productId: '1', quantity: 50)],
        totalAmount: 45000.00,
        employeeId: 'EMP001',
        stockistId: '1',
      ),
    ]);
  }

  void setSearchEmployeeQuery(String query) {
    state = state.copyWith(searchEmployeeQuery: query);
  }

  void setFilterStatus(String status) {
    state = state.copyWith(filterStatus: status);
  }

  void setDateRange(DateTimeRange? range) {
    state = state.copyWith(dateRange: range, clearDateRange: range == null);
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final updated = state.orders.map((o) {
      if (o.id == orderId) return o.copyWith(status: newStatus);
      return o;
    }).toList();
    state = state.copyWith(orders: updated);
  }
}
