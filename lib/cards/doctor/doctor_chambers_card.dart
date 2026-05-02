import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../models/doctor.dart';

class DoctorChambersCard extends StatelessWidget {
  final Doctor doctor;
  const DoctorChambersCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.building, color: AppColors.black, size: 20),
              AppGaps.mediumH,
              const Text('Chambers', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            ],
          ),
          AppGaps.largeV,
          if (doctor.chambers.isEmpty)
            const Text('No chambers listed.', style: TextStyle(color: AppColors.darkGrey))
          else
            ...doctor.chambers.map((chamber) => Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Iconsax.hospital, color: AppColors.black, size: 20),
                      ),
                      AppGaps.mediumH,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(chamber.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Iconsax.location, size: 14, color: AppColors.darkGrey),
                                const SizedBox(width: 4),
                                Expanded(child: Text(chamber.address, style: const TextStyle(color: AppColors.darkGrey, fontSize: 13))),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Iconsax.call, size: 14, color: AppColors.darkGrey),
                                const SizedBox(width: 4),
                                Text(chamber.phoneNo, style: const TextStyle(color: AppColors.darkGrey, fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }
}
