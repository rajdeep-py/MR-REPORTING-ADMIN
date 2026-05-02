import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../providers/employee_provider.dart';
import '../../routes/app_router.dart';

class EmployeeDetailScreen extends ConsumerWidget {
  final String id;
  const EmployeeDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(employeeProvider);
    
    // In case the employee is not found (e.g., just deleted)
    final isExisting = state.employees.any((e) => e.id == id);
    if (!isExisting) {
      return const Scaffold(body: Center(child: Text('Employee not found')));
    }
    
    final employee = state.employees.firstWhere((e) => e.id == id);

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Employee Details',
        subtitle: employee.fullName,
        showBackButton: true,
        actions: [
          IconButton(
            onPressed: () {
              context.push('${AppRouter.addEditEmployee}/$id');
            },
            icon: const Icon(Iconsax.edit),
            color: AppColors.black,
          ),
          IconButton(
            onPressed: () => _showDeleteDialog(context, ref),
            icon: const Icon(Iconsax.trash),
            color: AppColors.error,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppGaps.screenPadding),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.surface,
                backgroundImage: employee.profilePhotoPath != null
                    ? FileImage(File(employee.profilePhotoPath!))
                    : null,
                child: employee.profilePhotoPath == null
                    ? const Icon(Iconsax.user, size: 40, color: AppColors.darkGrey)
                    : null,
              ),
            ),
            AppGaps.largeV,
            Text(
              employee.fullName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            AppGaps.smallV,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.black.withAlpha(20),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'ID: ${employee.id}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            AppGaps.extraLargeV,
            _buildDetailSection(context, 'Contact Information', [
              _buildDetailRow(Iconsax.call, 'Phone', employee.phoneNo),
              if (employee.alternativePhoneNo != null && employee.alternativePhoneNo!.isNotEmpty)
                _buildDetailRow(Iconsax.call_add, 'Alt Phone', employee.alternativePhoneNo!),
              _buildDetailRow(Iconsax.sms, 'Email', employee.email),
            ]),
            AppGaps.largeV,
            _buildDetailSection(context, 'Work Details', [
              _buildDetailRow(Iconsax.location, 'Headquarter', employee.headquarter),
              _buildDetailRow(Iconsax.map, 'Areas of Work', employee.areasOfWork.join(', ')),
              _buildDetailRow(Iconsax.money, 'Monthly Target', '₹${employee.monthlyTarget.toStringAsFixed(2)}'),
            ]),
            AppGaps.largeV,
            _buildDetailSection(context, 'Security', [
              _buildDetailRow(Iconsax.lock, 'Password', employee.password, isObscured: true),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(BuildContext context, String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {bool isObscured = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.darkGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: AppColors.darkGrey, fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  isObscured ? '••••••••' : value,
                  style: const TextStyle(color: AppColors.black, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Employee'),
        content: const Text('Are you sure you want to delete this employee?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              minimumSize: Size.zero,
            ),
            onPressed: () {
              ref.read(employeeProvider.notifier).deleteEmployee(id);
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
  }
}
