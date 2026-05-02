import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../providers/doctor_provider.dart';

class DoctorSearchFilterCard extends ConsumerWidget {
  const DoctorSearchFilterCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(doctorProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  onChanged: (val) => ref.read(doctorProvider.notifier).setSearchDoctorQuery(val),
                  decoration: InputDecoration(
                    hintText: 'Search doctor by name or phone...',
                    prefixIcon: const Icon(Iconsax.search_normal),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              AppGaps.mediumH,
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: state.filterSpecialization,
                      icon: const Icon(Iconsax.arrow_down_1, size: 16),
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: 'All', child: Text('All Spec')),
                        DropdownMenuItem(value: 'Cardiologist', child: Text('Cardiologist')),
                        DropdownMenuItem(value: 'Neurologist', child: Text('Neurologist')),
                      ],
                      onChanged: (val) {
                        if (val != null) ref.read(doctorProvider.notifier).setFilterSpecialization(val);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          AppGaps.mediumV,
          TextField(
            onChanged: (val) => ref.read(doctorProvider.notifier).setSearchEmployeeQuery(val),
            decoration: InputDecoration(
              hintText: 'Search by employee who added...',
              prefixIcon: const Icon(Iconsax.user_search),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
