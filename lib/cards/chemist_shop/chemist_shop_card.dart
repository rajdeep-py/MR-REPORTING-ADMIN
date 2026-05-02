import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../models/chemist_shop.dart';

class ChemistShopCard extends StatelessWidget {
  final ChemistShop shop;
  const ChemistShopCard({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => context.push('/chemist-detail/${shop.id}'),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(shop.photoPath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(shop.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Iconsax.location, size: 14, color: AppColors.darkGrey),
                          const SizedBox(width: 4),
                          Expanded(child: Text(shop.address, style: const TextStyle(color: AppColors.darkGrey, fontSize: 13), overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Iconsax.call, size: 14, color: AppColors.darkGrey),
                          const SizedBox(width: 4),
                          Text(shop.phoneNo, style: const TextStyle(color: AppColors.darkGrey, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Iconsax.arrow_right_3, color: AppColors.darkGrey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
