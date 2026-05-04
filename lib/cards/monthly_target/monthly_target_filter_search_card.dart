import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../providers/monthly_target_provider.dart';
import '../../../providers/employee_provider.dart';
import '../../../theme/app_theme.dart';

class MonthlyTargetFilterSearchCard extends ConsumerWidget {
  const MonthlyTargetFilterSearchCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(monthlyTargetProvider);
    final employeeState = ref.watch(employeeProvider);

    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final currentYear = DateTime.now().year;
    final years = List.generate(5, (index) => currentYear - index);

    return Card(
      color: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.lightGrey, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter & Search',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Employee',
                      prefixIcon: const Icon(
                        Iconsax.user_search,
                        color: AppColors.darkGrey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.lightGrey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.lightGrey,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    initialValue: state.selectedEmployeeId,
                    items: employeeState.employees
                        .map(
                          (e) => DropdownMenuItem(
                            value: e.id,
                            child: Text(e.fullName),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      ref
                          .read(monthlyTargetProvider.notifier)
                          .setSelectedEmployee(val);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Month',
                      prefixIcon: const Icon(
                        Iconsax.calendar_1,
                        color: AppColors.darkGrey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.lightGrey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.lightGrey,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    initialValue: state.selectedMonth,
                    items: List.generate(
                      12,
                      (index) => DropdownMenuItem(
                        value: index + 1,
                        child: Text(months[index]),
                      ),
                    ),
                    onChanged: (val) {
                      if (val != null) {
                        ref
                            .read(monthlyTargetProvider.notifier)
                            .setSelectedMonth(val);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Year',
                      prefixIcon: const Icon(
                        Iconsax.calendar_2,
                        color: AppColors.darkGrey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.lightGrey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.lightGrey,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    initialValue: state.selectedYear,
                    items: years
                        .map(
                          (y) => DropdownMenuItem(
                            value: y,
                            child: Text(y.toString()),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        ref
                            .read(monthlyTargetProvider.notifier)
                            .setSelectedYear(val);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
