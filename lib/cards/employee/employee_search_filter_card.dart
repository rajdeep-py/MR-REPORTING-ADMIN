import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../providers/employee_provider.dart';

class EmployeeSearchFilterCard extends ConsumerWidget {
  const EmployeeSearchFilterCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(employeeProvider);
    final notifier = ref.read(employeeProvider.notifier);

    // Extract unique headquarters from all employees
    final hqs = state.employees.map((e) => e.headquarter).toSet().toList();
    hqs.sort();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: notifier.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search by name or phone...',
                prefixIcon: const Icon(Iconsax.search_normal, color: AppColors.darkGrey),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          AppGaps.mediumH,
          PopupMenuButton<String?>(
            onSelected: notifier.setFilterHeadquarter,
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: null,
                  child: Text('All Headquarters'),
                ),
                ...hqs.map((hq) => PopupMenuItem(
                  value: hq,
                  child: Text(hq),
                )),
              ];
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: state.selectedHeadquarter != null ? AppColors.black : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Iconsax.filter,
                color: state.selectedHeadquarter != null ? AppColors.white : AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
