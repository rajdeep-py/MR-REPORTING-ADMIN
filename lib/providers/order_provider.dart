import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/order_notifier.dart';

final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  return OrderNotifier();
});
