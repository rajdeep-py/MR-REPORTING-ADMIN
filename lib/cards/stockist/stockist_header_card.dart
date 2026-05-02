import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../models/stockist.dart';
import '../../providers/employee_provider.dart';

class StockistHeaderCard extends ConsumerWidget {
  final Stockist stockist;
  const StockistHeaderCard({super.key, required this.stockist});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employees = ref.watch(employeeProvider);
    final employeeMatches = employees.employees.where((e) => e.id == stockist.employeeId).toList();
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
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              image: DecorationImage(
                image: NetworkImage(stockist.photoPath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          AppGaps.largeV,
          Text(stockist.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Iconsax.location, size: 16, color: AppColors.darkGrey),
              const SizedBox(width: 4),
              Flexible(child: Text(stockist.address, style: const TextStyle(color: AppColors.darkGrey, fontWeight: FontWeight.w500), textAlign: TextAlign.center)),
            ],
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
