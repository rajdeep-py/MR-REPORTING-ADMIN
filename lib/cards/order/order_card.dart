import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../models/order.dart';

class OrderCard extends ConsumerWidget {
  final Order order;
  const OrderCard({super.key, required this.order});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.darkGrey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = _getStatusColor(order.status);
    final totalQuantity = order.items.fold<int>(0, (sum, item) => sum + item.quantity);
    final totalProducts = order.items.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => context.push('/order-detail/${order.id}'),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(order.id, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor.withAlpha(50)),
                      ),
                      child: Text(
                        order.status.toUpperCase(),
                        style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                    ),
                  ],
                ),
                AppGaps.mediumV,
                Row(
                  children: [
                    const Icon(Iconsax.calendar_1, size: 14, color: AppColors.darkGrey),
                    const SizedBox(width: 6),
                    Text('Ordered: ${DateFormat('MMM dd, yyyy').format(order.orderedOn)}', style: const TextStyle(color: AppColors.darkGrey, fontSize: 13)),
                  ],
                ),
                AppGaps.mediumV,
                const Divider(color: AppColors.lightGrey),
                AppGaps.mediumV,
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Amount', style: TextStyle(color: AppColors.darkGrey, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text('₹${order.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Items / Qty', style: TextStyle(color: AppColors.darkGrey, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text('$totalProducts / $totalQuantity', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Delivery', style: TextStyle(color: AppColors.darkGrey, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(DateFormat('MMM dd').format(order.deliveryDate), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
