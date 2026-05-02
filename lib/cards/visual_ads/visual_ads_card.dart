import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:io';
import '../../theme/app_theme.dart';
import '../../models/visual_ads.dart';
import '../../providers/visual_ads_provider.dart';
import 'visual_ads_image_preview_card.dart';
import 'create_edit_visual_ads_card.dart';

class VisualAdsCard extends ConsumerWidget {
  final VisualAd ad;
  const VisualAdsCard({super.key, required this.ad});

  void _showImagePreview(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => VisualAdsImagePreviewCard(imagePath: ad.imagePath),
    );
  }

  void _showEdit(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateEditVisualAdsCard(ad: ad),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showImagePreview(context),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.surface,
                image: DecorationImage(
                  image: ad.imagePath.startsWith('http')
                      ? NetworkImage(ad.imagePath) as ImageProvider
                      : FileImage(File(ad.imagePath)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ad.productName, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                AppGaps.smallV,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: ad.isActive ? Colors.green.withAlpha(20) : Colors.red.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: ad.isActive ? Colors.green : Colors.red),
                  ),
                  child: Text(
                    ad.isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                      color: ad.isActive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppGaps.mediumH,
          IconButton(
            onPressed: () => _showEdit(context),
            icon: const Icon(Iconsax.edit),
          ),
          IconButton(
            onPressed: () {
              ref.read(visualAdsProvider.notifier).deleteAd(ad.id);
            },
            icon: const Icon(Iconsax.trash, color: AppColors.error),
          ),
        ],
      ),
    );
  }
}
