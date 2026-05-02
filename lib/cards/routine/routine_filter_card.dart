import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../providers/routine_provider.dart';

class RoutineFilterCard extends ConsumerWidget {
  const RoutineFilterCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(routineProvider);

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
            child: _buildDateSelector(
              context, 
              label: 'From Date', 
              date: state.startDate,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: state.startDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (date != null) {
                  ref.read(routineProvider.notifier).setDateRange(date, state.endDate ?? date);
                }
              },
            ),
          ),
          AppGaps.mediumH,
          Expanded(
            child: _buildDateSelector(
              context, 
              label: 'To Date', 
              date: state.endDate,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: state.endDate ?? DateTime.now(),
                  firstDate: state.startDate ?? DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (date != null) {
                  ref.read(routineProvider.notifier).setDateRange(state.startDate ?? date, date);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context, {required String label, required DateTime? date, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
        ),
        child: Row(
          children: [
            const Icon(Iconsax.calendar_1, color: AppColors.darkGrey),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: AppColors.darkGrey)),
                const SizedBox(height: 4),
                Text(
                  date != null ? DateFormat('MMM dd, yyyy').format(date) : 'Select Date',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
