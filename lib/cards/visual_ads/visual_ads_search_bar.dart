import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../providers/visual_ads_provider.dart';

class VisualAdsSearchBar extends ConsumerWidget {
  const VisualAdsSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(visualAdsProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              onChanged: (val) => ref.read(visualAdsProvider.notifier).setSearchQuery(val),
              decoration: const InputDecoration(
                hintText: 'Search by product name...',
                prefixIcon: Icon(Iconsax.search_normal),
              ),
            ),
          ),
          AppGaps.mediumH,
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 56,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.darkGrey),
                borderRadius: BorderRadius.circular(16),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: state.filterStatus,
                  icon: const Icon(Iconsax.arrow_down_1, size: 16),
                  isExpanded: true,
                  hint: const Row(
                    children: [
                      Icon(Iconsax.filter, size: 18, color: AppColors.darkGrey),
                      SizedBox(width: 8),
                      Text('Filter'),
                    ],
                  ),
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All Statuses')),
                    DropdownMenuItem(value: 'Active', child: Text('Active')),
                    DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
                  ],
                  onChanged: (val) {
                    if (val != null) ref.read(visualAdsProvider.notifier).setFilterStatus(val);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
