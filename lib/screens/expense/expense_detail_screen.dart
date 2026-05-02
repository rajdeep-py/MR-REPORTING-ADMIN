import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../providers/employee_provider.dart';
import '../../cards/expense/expense_filter_card.dart';
import '../../cards/expense/expense_details_card.dart';

class ExpenseDetailScreen extends ConsumerWidget {
  final String id;
  const ExpenseDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeState = ref.watch(employeeProvider);
    
    final employeeExists = employeeState.employees.any((e) => e.id == id);
    if (!employeeExists) {
      return const Scaffold(body: Center(child: Text('Employee not found')));
    }

    final employee = employeeState.employees.firstWhere((e) => e.id == id);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PremiumAppBar(
        title: 'Expense Details',
        subtitle: 'Review and approve expenses',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppGaps.screenPadding),
        child: Column(
          children: [
            const ExpenseFilterCard(),
            AppGaps.largeV,
            ExpenseDetailsCard(employee: employee),
          ],
        ),
      ),
    );
  }
}
