import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../providers/about_us_provider.dart';

class CompanyContactCard extends ConsumerWidget {
  const CompanyContactCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutUs = ref.watch(aboutUsProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Get In Touch', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          AppGaps.largeV,
          Row(
            children: [
              Expanded(child: _buildContactItem(Iconsax.call, 'Phone', aboutUs.phoneNo)),
              Expanded(child: _buildContactItem(Iconsax.sms, 'Email', aboutUs.email)),
            ],
          ),
          AppGaps.largeV,
          Row(
            children: [
              Expanded(child: _buildContactItem(Iconsax.global, 'Website', aboutUs.website)),
              Expanded(child: _buildContactItem(Iconsax.location, 'Address', aboutUs.address)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: AppColors.black),
        ),
        AppGaps.mediumH,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: AppColors.darkGrey, fontSize: 12)),
              const SizedBox(height: 4),
              Text(content, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}
