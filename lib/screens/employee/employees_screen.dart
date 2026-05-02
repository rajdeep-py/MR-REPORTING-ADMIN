import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../routes/app_router.dart';
import '../../providers/employee_provider.dart';
import '../../cards/employee/employee_card.dart';
import '../../cards/employee/employee_search_filter_card.dart';

class EmployeesScreen extends ConsumerWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(employeeProvider);
    final employees = state.filteredEmployees;

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Employee Management',
        subtitle: 'Manage your field force',
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              context.push(AppRouter.addEditEmployee);
            },
            icon: const Icon(Iconsax.add, size: 18),
            label: const Text('Onboard Employee'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              minimumSize: Size.zero,
            ),
          ),
        ],
      ),
      drawer: const SideNavBar(),
      body: state.isLoading && state.employees.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.black))
          : Padding(
              padding: const EdgeInsets.all(AppGaps.screenPadding),
              child: Column(
                children: [
                  const EmployeeSearchFilterCard(),
                  AppGaps.largeV,
                  Expanded(
                    child: employees.isEmpty
                        ? const Center(child: Text('No employees found.'))
                        : ListView.builder(
                            itemCount: employees.length,
                            itemBuilder: (context, index) {
                              final emp = employees[index];
                              return EmployeeCard(
                                employee: emp,
                                onTap: () {
                                  context.push('${AppRouter.employeeDetail}/${emp.id}');
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
