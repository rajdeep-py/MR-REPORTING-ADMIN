import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/employee_provider.dart';
import '../../models/employee.dart';

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
            child: LayoutBuilder(
              builder: (context, constraints) {
                final selectedEmp = state.selectedEmployeeId != null
                    ? employees.where((e) => e.id == state.selectedEmployeeId).firstOrNull
                    : null;
                    
                return Autocomplete<Employee>(
                  initialValue: TextEditingValue(text: selectedEmp?.fullName ?? ''),
                  displayStringForOption: (option) => option.fullName,
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) return employees;
                    return employees.where((emp) {
                      return emp.fullName.toLowerCase().contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  onSelected: (Employee selection) {
                    ref.read(attendanceProvider.notifier).selectEmployee(selection.id);
                  },
                  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.search_normal),
                        hintText: 'Search Employee...',
                      ),
                    );
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.white,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 250,
                            maxWidth: constraints.maxWidth,
                          ),
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              final emp = options.elementAt(index);
                              return InkWell(
                                onTap: () => onSelected(emp),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Row(
                                    children: [
                                      const Icon(Iconsax.user, size: 18, color: AppColors.darkGrey),
                                      const SizedBox(width: 12),
                                      Text(emp.fullName, style: const TextStyle(fontWeight: FontWeight.w600)),
                                      const Spacer(),
                                      Text(emp.headquarter, style: const TextStyle(color: AppColors.darkGrey, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
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
