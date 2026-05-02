import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../providers/expense_provider.dart';

class ExpenseFilterCard extends ConsumerWidget {
  const ExpenseFilterCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(expenseProvider);

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
            child: InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: state.filterDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (date != null) {
                  ref.read(expenseProvider.notifier).setFilterDate(date);
                }
              },
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
                        const Text('Filter by Date', style: TextStyle(fontSize: 12, color: AppColors.darkGrey)),
                        const SizedBox(height: 4),
                        Text(
                          state.filterDate != null ? DateFormat('MMM dd, yyyy').format(state.filterDate!) : 'All Dates',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    if (state.filterDate != null) ...[
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Iconsax.close_circle, size: 18),
                        onPressed: () => ref.read(expenseProvider.notifier).setFilterDate(null),
                      )
                    ],
                  ],
                ),
              ),
            ),
          ),
          AppGaps.mediumH,
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 56, // to match typical text field height
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.darkGrey),
                borderRadius: BorderRadius.circular(16),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: state.filterStatus,
                  icon: const Icon(Iconsax.arrow_down_1, size: 16),
                  isExpanded: true,
                  hint: const Row(
                    children: [
                      Icon(Iconsax.filter, size: 18, color: AppColors.darkGrey),
                      SizedBox(width: 8),
                      Text('Filter by Status'),
                    ],
                  ),
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All Statuses')),
                    DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                    DropdownMenuItem(value: 'Paid', child: Text('Paid')),
                    DropdownMenuItem(value: 'Rejected', child: Text('Rejected')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      ref.read(expenseProvider.notifier).setFilterStatus(val);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
