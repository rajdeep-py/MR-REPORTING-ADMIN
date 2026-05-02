import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../providers/about_us_provider.dart';

class DirectorMessageCard extends ConsumerWidget {
  const DirectorMessageCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutUs = ref.watch(aboutUsProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (aboutUs.directorPhotoPath != null)
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: DecorationImage(
                  image: NetworkImage(aboutUs.directorPhotoPath!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          const SizedBox(width: 48),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Message from the Director', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.darkGrey)),
                AppGaps.mediumV,
                Text(
                  '"${aboutUs.directorMessage}"',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
                AppGaps.largeV,
                Text(aboutUs.directorName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                const Text('Director', style: TextStyle(color: AppColors.darkGrey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
