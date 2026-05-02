import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../providers/stockist_provider.dart';

class StockistSearchFilterCard extends ConsumerWidget {
  const StockistSearchFilterCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stockistProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withAlpha(128)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  onChanged: (val) => ref.read(stockistProvider.notifier).setSearchEmployeeQuery(val),
                  decoration: InputDecoration(
                    hintText: 'Search employee who added...',
                    prefixIcon: const Icon(Iconsax.user_search),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
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
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: state.filterLocation,
                      icon: const Icon(Iconsax.arrow_down_1, size: 16),
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: 'All', child: Text('All Loc')),
                        DropdownMenuItem(value: 'Mumbai', child: Text('Mumbai')),
                        DropdownMenuItem(value: 'Delhi', child: Text('Delhi')),
                      ],
                      onChanged: (val) {
                        if (val != null) ref.read(stockistProvider.notifier).setFilterLocation(val);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
