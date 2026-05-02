import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../providers/chemist_shop_provider.dart';
import '../../providers/employee_provider.dart';
import '../../cards/chemist_shop/chemist_shop_search_filter_card.dart';
import '../../cards/chemist_shop/chemist_shop_card.dart';

class ChemistShopsScreen extends ConsumerWidget {
  const ChemistShopsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chemistShopProvider);
    final employees = ref.watch(employeeProvider);

    final filteredShops = state.shops.where((shop) {
      if (state.filterLocation != 'All' && shop.location != state.filterLocation) {
        return false;
      }
      if (state.searchEmployeeQuery.isNotEmpty) {
        final empQuery = state.searchEmployeeQuery.toLowerCase();
        bool match = false;
        for (var emp in employees.employees) {
          if (emp.id == shop.employeeId && emp.fullName.toLowerCase().contains(empQuery)) {
            match = true;
            break;
          }
        }
        if (!match) return false;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(
        title: 'Chemist Connections',
        subtitle: 'Manage chemist shops and their preferences',
        actions: [
          PremiumAppbarAction(icon: Iconsax.document_download, onTap: () {}),
        ],
      ),
      drawer: const SideNavBar(),
      body: Padding(
        padding: const EdgeInsets.all(AppGaps.screenPadding),
        child: Column(
          children: [
            const ChemistShopSearchFilterCard(),
            AppGaps.largeV,
            Expanded(
              child: filteredShops.isEmpty
                  ? const Center(child: Text('No chemist shops found.', style: TextStyle(color: AppColors.darkGrey)))
                  : ListView.builder(
                      itemCount: filteredShops.length,
                      itemBuilder: (context, index) {
                        return ChemistShopCard(shop: filteredShops[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
