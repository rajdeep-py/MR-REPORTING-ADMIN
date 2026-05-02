import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../providers/about_us_provider.dart';

class CompanyDescriptionCard extends ConsumerWidget {
  const CompanyDescriptionCard({super.key});

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
          Text('Who We Are', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          AppGaps.mediumV,
          Text(
            aboutUs.description,
            style: const TextStyle(color: AppColors.darkGrey, height: 1.6, fontSize: 16),
          ),
          AppGaps.largeV,
          const Divider(color: AppColors.lightGrey),
          AppGaps.largeV,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildSection(context, 'Our Mission', aboutUs.mission, Iconsax.award)),
              const SizedBox(width: 32),
              Expanded(child: _buildSection(context, 'Our Vision', aboutUs.vision, Iconsax.eye)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.black.withAlpha(10), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: AppColors.black, size: 20),
            ),
            AppGaps.mediumH,
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
          ],
        ),
        AppGaps.mediumV,
        Text(content, style: const TextStyle(color: AppColors.darkGrey, height: 1.5)),
      ],
    );
  }
}
