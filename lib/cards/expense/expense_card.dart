import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../models/employee.dart';
import '../../routes/app_router.dart';

class ExpenseCard extends StatelessWidget {
  final Employee employee;
  const ExpenseCard({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => context.push('${AppRouter.expenseDetail}/${employee.id}'),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.surface,
                  backgroundImage: employee.profilePhotoPath != null ? FileImage(File(employee.profilePhotoPath!)) : null,
                  child: employee.profilePhotoPath == null ? const Icon(Iconsax.user, color: AppColors.black) : null,
                ),
                AppGaps.mediumH,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.fullName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      AppGaps.smallV,
                      Text(
                        employee.headquarter,
                        style: const TextStyle(color: AppColors.darkGrey),
                      ),
                    ],
                  ),
                ),
                AppGaps.mediumH,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.black.withAlpha(10),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Iconsax.money_send, size: 18, color: AppColors.black),
                      SizedBox(width: 8),
                      Text(
                        'Track Expenses',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
