import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../models/doctor.dart';

class DoctorDescriptionCard extends StatelessWidget {
  final Doctor doctor;
  const DoctorDescriptionCard({super.key, required this.doctor});

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
              const Icon(Iconsax.document_text, color: AppColors.black, size: 20),
              AppGaps.mediumH,
              const Text('About Doctor', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            ],
          ),
          AppGaps.largeV,
          Text(doctor.description, style: const TextStyle(color: AppColors.darkGrey, height: 1.6, fontSize: 15)),
        ],
      ),
    );
  }
}
