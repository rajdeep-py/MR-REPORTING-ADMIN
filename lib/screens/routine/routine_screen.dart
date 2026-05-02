import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../providers/routine_provider.dart';
import '../../providers/employee_provider.dart';
import '../../cards/routine/routine_card.dart';
import '../../cards/routine/routine_search_card.dart';

class RoutineScreen extends ConsumerWidget {
  const RoutineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routineState = ref.watch(routineProvider);
    final employeeState = ref.watch(employeeProvider);

    final filteredEmployees = employeeState.employees.where((e) {
      if (routineState.searchQuery.isEmpty) return true;
      return e.fullName.toLowerCase().contains(routineState.searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PremiumAppBar(
        title: 'Routine Management',
        subtitle: 'Manage and oversee daily routines of your representatives',
      ),
      drawer: const SideNavBar(),
      body: employeeState.isLoading && employeeState.employees.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.black))
          : Padding(
              padding: const EdgeInsets.all(AppGaps.screenPadding),
              child: Column(
                children: [
                  const RoutineSearchCard(),
                  AppGaps.largeV,
                  Expanded(
                    child: filteredEmployees.isEmpty
                        ? const Center(child: Text('No employees found', style: TextStyle(color: AppColors.darkGrey)))
                        : ListView.builder(
                            itemCount: filteredEmployees.length,
                            itemBuilder: (context, index) {
                              return RoutineCard(employee: filteredEmployees[index]);
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
