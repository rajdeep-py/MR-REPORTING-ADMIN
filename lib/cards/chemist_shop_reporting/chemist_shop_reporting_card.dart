import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../models/chemist_shop_reporting.dart';
import '../../providers/employee_provider.dart';

class ChemistShopReportingCard extends ConsumerWidget {
  final ChemistShopReporting report;
  const ChemistShopReportingCard({super.key, required this.report});

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
    final employees = ref.watch(employeeProvider);
    final employeeMatches = employees.employees.where((e) => e.id == report.employeeId).toList();
    final employeeName = employeeMatches.isNotEmpty ? employeeMatches.first.fullName : 'Unknown Employee';

    final statusColor = _getStatusColor(report.status);

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
          onTap: () => context.push('/chemist-shop-reporting-detail/${report.id}'),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(report.id, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor.withAlpha(50)),
                      ),
                      child: Text(
                        report.status.toUpperCase(),
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
                    Text(DateFormat('MMM dd, yyyy').format(report.date), style: const TextStyle(color: AppColors.darkGrey, fontSize: 13)),
                    const SizedBox(width: 16),
                    const Icon(Iconsax.clock, size: 14, color: AppColors.darkGrey),
                    const SizedBox(width: 6),
                    Text(report.time, style: const TextStyle(color: AppColors.darkGrey, fontSize: 13)),
                  ],
                ),
                AppGaps.mediumV,
                const Divider(color: AppColors.lightGrey),
                AppGaps.mediumV,
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Iconsax.shop, color: AppColors.black, size: 20),
                    ),
                    AppGaps.mediumH,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(report.chemistShopName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                          const SizedBox(height: 2),
                          Text('Added by $employeeName', style: const TextStyle(color: AppColors.darkGrey, fontSize: 12)),
                        ],
                      ),
                    ),
                    const Icon(Iconsax.arrow_right_3, color: AppColors.darkGrey),
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
