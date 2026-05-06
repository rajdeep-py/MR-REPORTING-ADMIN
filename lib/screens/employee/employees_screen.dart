import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../routes/app_router.dart';
import '../../providers/employee_provider.dart';
import '../../providers/auth_provider.dart';
import '../../cards/employee/employee_card.dart';
import '../../cards/employee/employee_search_filter_card.dart';

class EmployeesScreen extends ConsumerStatefulWidget {
  const EmployeesScreen({super.key});

  @override
  ConsumerState<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends ConsumerState<EmployeesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final authState = ref.read(authProvider);
      final adminId = authState.value?.adminId;
      if (adminId != null) {
        ref.read(employeeProvider.notifier).fetchEmployees(adminId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(employeeProvider);
    final authState = ref.watch(authProvider);
    final adminId = authState.value?.adminId;

    final employees = state.employees.where((emp) {
      // Search logic
      if (state.searchQuery.isNotEmpty &&
          !emp.fullName.toLowerCase().contains(state.searchQuery.toLowerCase()) &&
          !emp.email.toLowerCase().contains(state.searchQuery.toLowerCase()) &&
          !emp.phoneNo.contains(state.searchQuery)) {
        return false;
      }
      
      // Status filter
      if (state.filterStatus == 'Active' && emp.status != 'active') return false;
      if (state.filterStatus == 'Inactive' && emp.status != 'inactive') return false;
      
      // HQ filter
      if (state.selectedHeadquarter != null && emp.headquarter != state.selectedHeadquarter) {
        return false;
      }
      
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
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
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: const SideNavBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          if (adminId != null) {
            await ref.read(employeeProvider.notifier).fetchEmployees(adminId);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(AppGaps.screenPadding),
          child: Column(
            children: [
              const EmployeeSearchFilterCard(),
              AppGaps.largeV,
              Expanded(
                child: state.isLoading && state.employees.isEmpty
                    ? const Center(child: CircularProgressIndicator(color: AppColors.black))
                    : employees.isEmpty
                        ? const Center(child: Text('No employees found.', style: TextStyle(color: AppColors.darkGrey)))
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
      ),
    );
  }
}
