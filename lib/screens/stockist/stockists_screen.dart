import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../providers/stockist_provider.dart';
import '../../providers/employee_provider.dart';
import '../../cards/stockist/stockist_search_filter_card.dart';
import '../../cards/stockist/stockist_card.dart';

class StockistsScreen extends ConsumerWidget {
  const StockistsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stockistProvider);
    final employees = ref.watch(employeeProvider);

    final filteredStockists = state.stockists.where((stockist) {
      if (state.filterLocation != 'All' && stockist.location != state.filterLocation) {
        return false;
      }
      if (state.searchEmployeeQuery.isNotEmpty) {
        final empQuery = state.searchEmployeeQuery.toLowerCase();
        bool match = false;
        for (var emp in employees.employees) {
          if (emp.id == stockist.employeeId && emp.fullName.toLowerCase().contains(empQuery)) {
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
        title: 'Stockist Connections',
        subtitle: 'Manage stockists and their preferences',
        actions: [
          PremiumAppbarAction(icon: Iconsax.document_download, onTap: () {}),
        ],
      ),
      drawer: const SideNavBar(),
      body: Padding(
        padding: const EdgeInsets.all(AppGaps.screenPadding),
        child: Column(
          children: [
            const StockistSearchFilterCard(),
            AppGaps.largeV,
            Expanded(
              child: filteredStockists.isEmpty
                  ? const Center(child: Text('No stockists found.', style: TextStyle(color: AppColors.darkGrey)))
                  : ListView.builder(
                      itemCount: filteredStockists.length,
                      itemBuilder: (context, index) {
                        return StockistCard(stockist: filteredStockists[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
