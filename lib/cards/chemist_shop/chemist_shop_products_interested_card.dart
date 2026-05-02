import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:io';
import '../../theme/app_theme.dart';
import '../../models/chemist_shop.dart';
import '../../providers/visual_ads_provider.dart';

class ChemistShopProductsInterestedCard extends ConsumerWidget {
  final ChemistShop shop;
  const ChemistShopProductsInterestedCard({super.key, required this.shop});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visualAdsState = ref.watch(visualAdsProvider);
    final interestedProducts = visualAdsState.ads.where((ad) => shop.interestedProductIds.contains(ad.id)).toList();

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
              const Icon(Iconsax.box, color: AppColors.black, size: 20),
              AppGaps.mediumH,
              const Text('Products Interested In', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            ],
          ),
          AppGaps.largeV,
          if (interestedProducts.isEmpty)
            const Text('No specific product interests found.', style: TextStyle(color: AppColors.darkGrey))
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: interestedProducts.map((ad) => Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.lightGrey),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: ad.imagePath.startsWith('http')
                              ? NetworkImage(ad.imagePath) as ImageProvider
                              : FileImage(File(ad.imagePath)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(ad.productName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(width: 8),
                  ],
                ),
              )).toList(),
            ),
        ],
      ),
    );
  }
}
