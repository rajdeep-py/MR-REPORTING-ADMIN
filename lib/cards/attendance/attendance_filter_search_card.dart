import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/employee_provider.dart';

class AttendanceFilterSearchCard extends ConsumerWidget {
  const AttendanceFilterSearchCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employees = ref.watch(employeeProvider).employees;
    final state = ref.watch(attendanceProvider);

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
            flex: 2,
            child: DropdownButtonFormField<String>(
              initialValue: state.selectedEmployeeId,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.user_search),
                hintText: 'Select Employee',
              ),
              items: employees.map((emp) {
                return DropdownMenuItem(
                  value: emp.id,
                  child: Text(emp.fullName),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  ref.read(attendanceProvider.notifier).selectEmployee(val);
                }
              },
            ),
          ),
          AppGaps.mediumH,
          Expanded(
            flex: 1,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Iconsax.document_download, size: 18),
              label: const Text('Download Report'),
            ),
          ),
        ],
      ),
    );
  }
}
