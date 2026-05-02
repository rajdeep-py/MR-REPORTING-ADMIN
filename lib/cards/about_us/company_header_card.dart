import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../providers/about_us_provider.dart';

class CompanyHeaderCard extends ConsumerWidget {
  const CompanyHeaderCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutUs = ref.watch(aboutUsProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Image.asset(
              'assets/logo/logo.png',
              height: 80,
            ),
          ),
          AppGaps.extraLargeV,
          Text(
            aboutUs.companyName,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          AppGaps.mediumV,
          Text(
            aboutUs.tagline,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.lightGrey,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
