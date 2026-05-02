import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../models/doctor.dart';

class DoctorEducationSpecializationCard extends StatelessWidget {
  final Doctor doctor;
  const DoctorEducationSpecializationCard({super.key, required this.doctor});

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.black, size: 20),
          ),
          AppGaps.mediumH,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.darkGrey, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(color: AppColors.black, fontWeight: FontWeight.w600, fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
          const Text('Education & Experience', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          AppGaps.largeV,
          _buildDetailRow(Iconsax.teacher, 'Education Qualification', doctor.education),
          _buildDetailRow(Iconsax.award, 'Specialization', doctor.specialization),
          _buildDetailRow(Iconsax.briefcase, 'Experience', doctor.experience),
        ],
      ),
    );
  }
}
