import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../providers/gift_provider.dart';

class GiftFilterCard extends ConsumerWidget {
  const GiftFilterCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(giftProvider);

    String dateRangeText = 'Select Date Range';
    if (state.dateRange != null) {
      final start = DateFormat('MMM dd').format(state.dateRange!.start);
      final end = DateFormat('MMM dd').format(state.dateRange!.end);
      dateRangeText = '$start - $end';
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: state.filterStatus,
                  icon: const Icon(Iconsax.arrow_down_1, size: 16),
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All Status')),
                    DropdownMenuItem(value: 'pending', child: Text('Pending')),
                    DropdownMenuItem(value: 'approved', child: Text('Approved')),
                    DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
                  ],
                  onChanged: (val) {
                    if (val != null) ref.read(giftProvider.notifier).setFilterStatus(val);
                  },
                ),
              ),
            ),
          ),
          AppGaps.mediumH,
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  initialDateRange: state.dateRange,
                );
                ref.read(giftProvider.notifier).setDateRange(picked);
              },
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(dateRangeText, style: const TextStyle(color: AppColors.darkGrey), overflow: TextOverflow.ellipsis)),
                    if (state.dateRange != null)
                      GestureDetector(
                        onTap: () => ref.read(giftProvider.notifier).setDateRange(null),
                        child: const Icon(Iconsax.close_circle, size: 18, color: AppColors.darkGrey),
                      )
                    else
                      const Icon(Iconsax.calendar_1, size: 18, color: AppColors.darkGrey),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
