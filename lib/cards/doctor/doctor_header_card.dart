import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../models/doctor.dart';
import '../../providers/employee_provider.dart';

class DoctorHeaderCard extends ConsumerWidget {
  final Doctor doctor;
  const DoctorHeaderCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employees = ref.watch(employeeProvider);
    final employeeMatches = employees.employees.where((e) => e.id == doctor.employeeId).toList();
    final employee = employeeMatches.isNotEmpty ? employeeMatches.first : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(doctor.profilePhotoPath),
          ),
          AppGaps.largeV,
          Text(doctor.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(doctor.specialization, style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w600)),
          ),
          AppGaps.largeV,
          const Divider(color: AppColors.lightGrey),
          AppGaps.largeV,
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Added By', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.darkGrey)),
          ),
          AppGaps.mediumV,
          if (employee != null)
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: employee.profilePhotoPath != null ? NetworkImage(employee.profilePhotoPath!) : null,
                  backgroundColor: AppColors.surface,
                  child: employee.profilePhotoPath == null ? const Icon(Iconsax.user, color: AppColors.black) : null,
                ),
                AppGaps.mediumH,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(employee.fullName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Iconsax.location, size: 12, color: AppColors.darkGrey),
                          const SizedBox(width: 4),
                          Text(employee.headquarter, style: const TextStyle(color: AppColors.darkGrey, fontSize: 12)),
                          const SizedBox(width: 8),
                          const Icon(Iconsax.call, size: 12, color: AppColors.darkGrey),
                          const SizedBox(width: 4),
                          Text(employee.phoneNo, style: const TextStyle(color: AppColors.darkGrey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            const Text('Employee information not available.', style: TextStyle(color: AppColors.darkGrey)),
        ],
      ),
    );
  }
}
