import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../providers/monthly_target_provider.dart';
import '../../../providers/order_provider.dart';
import '../../../theme/app_theme.dart';

class MonthlyTargetDetailsCard extends ConsumerWidget {
  const MonthlyTargetDetailsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(monthlyTargetProvider);
    final orderState = ref.watch(orderProvider);

    if (state.selectedEmployeeId == null) {
      return const SizedBox.shrink();
    }

    final completedOrders = orderState.orders.where((o) =>
        o.employeeId == state.selectedEmployeeId &&
        o.status == 'completed' &&
        o.orderedOn.month == state.selectedMonth &&
        o.orderedOn.year == state.selectedYear).toList();

    return Card(
      color: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.lightGrey, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Target Achieved Details',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.lightGrey),
                  ),
                  child: Text(
                    '${completedOrders.length} Orders',
                    style: const TextStyle(
                      color: AppColors.darkGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (completedOrders.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(Iconsax.document_text_1, size: 48, color: AppColors.lightGrey),
                      const SizedBox(height: 16),
                      Text(
                        'No completed orders found for this month.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.darkGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: completedOrders.length,
                separatorBuilder: (context, index) => const Divider(color: AppColors.lightGrey),
                itemBuilder: (context, index) {
                  final order = completedOrders[index];
                  final date = '${order.orderedOn.day.toString().padLeft(2, '0')}/${order.orderedOn.month.toString().padLeft(2, '0')}/${order.orderedOn.year}';
                  
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.success.withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Iconsax.bag_tick, color: AppColors.success, size: 20),
                    ),
                    title: Text(
                      'Order #${order.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Ordered on: $date',
                        style: const TextStyle(color: AppColors.darkGrey, fontSize: 12),
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${order.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${order.items.length} Items',
                          style: const TextStyle(
                            color: AppColors.darkGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
