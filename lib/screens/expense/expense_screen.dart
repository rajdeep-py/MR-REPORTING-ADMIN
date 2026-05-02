import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../providers/expense_provider.dart';
import '../../providers/employee_provider.dart';
import '../../cards/expense/expense_card.dart';
import '../../cards/expense/expense_search_card.dart';

class ExpenseScreen extends ConsumerWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseState = ref.watch(expenseProvider);
    final employeeState = ref.watch(employeeProvider);

    final filteredEmployees = employeeState.employees.where((e) {
      if (expenseState.searchQuery.isEmpty) return true;
      return e.fullName.toLowerCase().contains(expenseState.searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PremiumAppBar(
        title: 'Expense Tracker',
        subtitle: 'Review and manage employee expenses',
      ),
      drawer: const SideNavBar(),
      body: employeeState.isLoading && employeeState.employees.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.black))
          : Padding(
              padding: const EdgeInsets.all(AppGaps.screenPadding),
              child: Column(
                children: [
                  const ExpenseSearchCard(),
                  AppGaps.largeV,
                  Expanded(
                    child: filteredEmployees.isEmpty
                        ? const Center(child: Text('No employees found', style: TextStyle(color: AppColors.darkGrey)))
                        : ListView.builder(
                            itemCount: filteredEmployees.length,
                            itemBuilder: (context, index) {
                              return ExpenseCard(employee: filteredEmployees[index]);
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
