import 'package:flutter/material.dart';
import 'dart:io';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../models/employee.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;
  final VoidCallback onTap;

  const EmployeeCard({super.key, required this.employee, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.surface,
          backgroundImage: employee.profilePhotoPath != null
              ? FileImage(File(employee.profilePhotoPath!))
              : null,
          child: employee.profilePhotoPath == null
              ? const Icon(Iconsax.user, color: AppColors.darkGrey)
              : null,
        ),
        title: Text(
          employee.fullName,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              const Icon(Iconsax.location, size: 16, color: AppColors.darkGrey),
              const SizedBox(width: 4),
              Text(
                employee.headquarter,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
        ),
        trailing: const Icon(Iconsax.arrow_right_3, color: AppColors.midGrey),
      ),
    );
  }
}
