import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../providers/monthly_target_provider.dart';
import '../../../providers/employee_provider.dart';
import '../../../providers/order_provider.dart';
import '../../../theme/app_theme.dart';
import '../../../models/monthly_target.dart';

class MonthlyTargetCard extends ConsumerWidget {
  const MonthlyTargetCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(monthlyTargetProvider);
    final employeeState = ref.watch(employeeProvider);
    final orderState = ref.watch(orderProvider);

    if (state.selectedEmployeeId == null) {
      return const SizedBox.shrink();
    }

    final employee = employeeState.employees.firstWhere(
      (e) => e.id == state.selectedEmployeeId,
      orElse: () => employeeState.employees.first,
    );

    // Calculate achieved target based on orders for the selected month and year
    final completedOrders = orderState.orders.where(
      (o) =>
          o.employeeId == employee.id &&
          o.status == 'completed' &&
          o.orderedOn.month == state.selectedMonth &&
          o.orderedOn.year == state.selectedYear,
    );

    final targetAchieved = completedOrders.fold(
      0.0,
      (sum, o) => sum + o.totalAmount,
    );

    final monthlyTarget = MonthlyTarget(
      employeeId: employee.id,
      month: state.selectedMonth,
      year: state.selectedYear,
      targetAmount: employee.monthlyTarget,
      targetAchieved: targetAchieved,
    );

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
                  'Monthly Target Overview',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.black.withAlpha(20),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${monthlyTarget.percentageAchieved.toStringAsFixed(1)}% Achieved',
                    style: const TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    title: 'Target Amount',
                    amount: monthlyTarget.targetAmount,
                    icon: Iconsax.tag,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    context,
                    title: 'Target Achieved',
                    amount: monthlyTarget.targetAchieved,
                    icon: Iconsax.chart_success,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    context,
                    title: 'Target Missed',
                    amount: monthlyTarget.targetMissed,
                    icon: Iconsax.chart_fail,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: monthlyTarget.percentageAchieved > 100
                    ? 1.0
                    : monthlyTarget.percentageAchieved / 100.0,
                backgroundColor: AppColors.lightGrey,
                color: monthlyTarget.percentageAchieved >= 100
                    ? AppColors.success
                    : AppColors.black,
                minHeight: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.darkGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
