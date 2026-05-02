import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../models/employee.dart';
import '../../models/expense.dart';
import '../../providers/expense_provider.dart';

class ExpenseDetailsCard extends ConsumerWidget {
  final Employee employee;
  const ExpenseDetailsCard({super.key, required this.employee});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(expenseProvider);
    
    final expenses = state.expenses.where((e) {
      if (e.employeeId != employee.id) {
        return false;
      }
      if (state.filterDate != null) {
        if (e.date.year != state.filterDate!.year || 
            e.date.month != state.filterDate!.month || 
            e.date.day != state.filterDate!.day) {
          return false;
        }
      }
      if (state.filterStatus != 'All' && e.status != state.filterStatus) {
        return false;
      }
      return true;
    }).toList();
    
    expenses.sort((a, b) => b.date.compareTo(a.date));

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildEmployeeHeader(context),
          AppGaps.extraLargeV,
          const Divider(color: AppColors.lightGrey),
          AppGaps.largeV,
          Text('Expense Reports', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          AppGaps.largeV,
          if (expenses.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(child: Text('No expenses found for this filter.', style: TextStyle(color: AppColors.darkGrey))),
            )
          else
            ...expenses.map((expense) => _buildExpenseDay(context, ref, expense)),
        ],
      ),
    );
  }

  Widget _buildEmployeeHeader(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.surface,
          backgroundImage: employee.profilePhotoPath != null ? FileImage(File(employee.profilePhotoPath!)) : null,
          child: employee.profilePhotoPath == null ? const Icon(Iconsax.user, size: 30, color: AppColors.black) : null,
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(employee.fullName, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
              AppGaps.smallV,
              Row(
                children: [
                  const Icon(Iconsax.location, size: 16, color: AppColors.darkGrey),
                  const SizedBox(width: 4),
                  Text(employee.headquarter, style: const TextStyle(color: AppColors.darkGrey)),
                  const SizedBox(width: 16),
                  const Icon(Iconsax.call, size: 16, color: AppColors.darkGrey),
                  const SizedBox(width: 4),
                  Text(employee.phoneNo, style: const TextStyle(color: AppColors.darkGrey)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseDay(BuildContext context, WidgetRef ref, DailyExpense expense) {
    Color statusColor;
    if (expense.status == 'Paid') {
      statusColor = Colors.green;
    } else if (expense.status == 'Rejected') {
      statusColor = AppColors.error;
    } else {
      statusColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(12)),
                child: Text(
                  DateFormat('EEEE, MMM dd, yyyy').format(expense.date),
                  style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor),
                ),
                child: DropdownButton<String>(
                  value: expense.status,
                  underline: const SizedBox.shrink(),
                  icon: const Icon(Iconsax.arrow_down_1, size: 16),
                  items: const [
                    DropdownMenuItem(value: 'Pending', child: Text('Pending', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold))),
                    DropdownMenuItem(value: 'Paid', child: Text('Paid', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                    DropdownMenuItem(value: 'Rejected', child: Text('Rejected', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      ref.read(expenseProvider.notifier).updateExpenseStatus(expense.id, val);
                    }
                  },
                ),
              ),
            ],
          ),
          AppGaps.largeV,
          ...expense.items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Iconsax.receipt_2, size: 18, color: AppColors.darkGrey),
                    const SizedBox(width: 8),
                    Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  ],
                ),
                Text('₹${item.amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              ],
            ),
          )),
          const Divider(color: AppColors.lightGrey),
          AppGaps.smallV,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Amount', style: TextStyle(color: AppColors.darkGrey, fontWeight: FontWeight.w600)),
              Text('₹${expense.totalAmount.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            ],
          ),
          if (expense.attachedImages.isNotEmpty) ...[
            AppGaps.largeV,
            const Text('Attachments', style: TextStyle(fontWeight: FontWeight.w700)),
            AppGaps.smallV,
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: expense.attachedImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: expense.attachedImages[index].startsWith('http')
                            ? NetworkImage(expense.attachedImages[index]) as ImageProvider
                            : FileImage(File(expense.attachedImages[index])),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
