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
    final isDesktop = MediaQuery.of(context).size.width >= 800;
    
    final isExisting = state.employees.any((e) => e.id == id);
    if (!isExisting) {
      return const Scaffold(body: Center(child: Text('Employee not found')));
    }
    
    final employee = state.employees.firstWhere((e) => e.id == id);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(
        title: 'Employee Details',
        subtitle: 'View and manage profile',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppGaps.screenPadding),
        child: isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildProfileCard(context, employee, ref),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildContactCard(context, employee),
                        AppGaps.largeV,
                        _buildWorkCard(context, employee),
                        AppGaps.largeV,
                        _buildSecurityCard(context, employee),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProfileCard(context, employee, ref),
                  AppGaps.largeV,
                  _buildContactCard(context, employee),
                  AppGaps.largeV,
                  _buildWorkCard(context, employee),
                  AppGaps.largeV,
                  _buildSecurityCard(context, employee),
                ],
              ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, employee, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(10),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.black.withAlpha(51), width: 2),
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: AppColors.surface,
              backgroundImage: employee.profilePhotoPath != null
                  ? FileImage(File(employee.profilePhotoPath!))
                  : null,
              child: employee.profilePhotoPath == null
                  ? const Icon(Iconsax.user, size: 48, color: AppColors.black)
                  : null,
            ),
          ),
          AppGaps.largeV,
          Text(
            employee.fullName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                ),
            textAlign: TextAlign.center,
          ),
          AppGaps.smallV,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.black.withAlpha(26),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'ID: ${employee.id}',
              style: const TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          AppGaps.extraLargeV,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push('${AppRouter.addEditEmployee}/${employee.id}'),
                  icon: const Icon(Iconsax.edit_2, size: 18),
                  label: const Text('Edit Profile'),
                ),
              ),
              AppGaps.mediumH,
              Container(
                decoration: BoxDecoration(
                  color: AppColors.error.withAlpha(26),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  onPressed: () => _showDeleteDialog(context, ref, employee.id),
                  icon: const Icon(Iconsax.trash),
                  color: AppColors.error,
                  tooltip: 'Delete Employee',
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, employee) {
    return _buildSectionCard(
      context,
      title: 'Contact Information',
      icon: Iconsax.personalcard,
      children: [
        _buildInfoTile(Iconsax.call, 'Primary Phone', employee.phoneNo),
        if (employee.alternativePhoneNo != null && employee.alternativePhoneNo!.isNotEmpty)
          _buildInfoTile(Iconsax.call_add, 'Alternative Phone', employee.alternativePhoneNo!),
        _buildInfoTile(Iconsax.sms, 'Email Address', employee.email),
      ],
    );
  }

  Widget _buildWorkCard(BuildContext context, employee) {
    return _buildSectionCard(
      context,
      title: 'Work Details',
      icon: Iconsax.briefcase,
      children: [
        _buildInfoTile(Iconsax.location, 'Headquarter', employee.headquarter),
        _buildInfoTile(Iconsax.map, 'Areas of Work', employee.areasOfWork.join(', ')),
        _buildInfoTile(Iconsax.money, 'Monthly Target', '₹${employee.monthlyTarget.toStringAsFixed(2)}'),
      ],
    );
  }

  Widget _buildSecurityCard(BuildContext context, employee) {
    return _buildSectionCard(
      context,
      title: 'Security',
      icon: Iconsax.shield_tick,
      children: [
        _buildInfoTile(Iconsax.lock, 'Account Password', employee.password, isObscured: true),
      ],
    );
  }

  Widget _buildSectionCard(BuildContext context, {required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha(5),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.black, size: 20),
              ),
              AppGaps.mediumH,
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(color: AppColors.lightGrey, height: 1),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value, {bool isObscured = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.darkGrey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.coolGrey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isObscured ? '••••••••' : value,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Iconsax.warning_2, color: AppColors.error),
            SizedBox(width: 8),
            Text('Delete Employee'),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete this employee? This action cannot be undone.',
          style: TextStyle(color: AppColors.darkGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.darkGrey)),
          ),
          ElevatedButton(
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
