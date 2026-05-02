import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../providers/chemist_shop_reporting_provider.dart';
import '../../providers/employee_provider.dart';
import '../../cards/chemist_shop_reporting/chemist_shop_reporting_search_filter_card.dart';
import '../../cards/chemist_shop_reporting/chemist_shop_reporting_card.dart';

class ChemistShopReportingScreen extends ConsumerWidget {
  const ChemistShopReportingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chemistShopReportingProvider);
    final employees = ref.watch(employeeProvider);

    final filteredReports = state.reports.where((report) {
      if (state.filterStatus != 'All' && report.status != state.filterStatus) {
        return false;
      }
      
      if (state.dateRange != null) {
        final rDate = DateTime(report.date.year, report.date.month, report.date.day);
        final startDate = DateTime(state.dateRange!.start.year, state.dateRange!.start.month, state.dateRange!.start.day);
        final endDate = DateTime(state.dateRange!.end.year, state.dateRange!.end.month, state.dateRange!.end.day);
        
        if (rDate.isBefore(startDate) || rDate.isAfter(endDate)) {
          return false;
        }
      }

      if (state.searchEmployeeQuery.isNotEmpty) {
        final empQuery = state.searchEmployeeQuery.toLowerCase();
        bool match = false;
        for (var emp in employees.employees) {
          if (emp.id == report.employeeId && emp.fullName.toLowerCase().contains(empQuery)) {
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
        title: 'Chemist Reporting',
        subtitle: 'Shop visit logs & visual ads presented',
        actions: [
          PremiumAppbarAction(icon: Iconsax.document_download, onTap: () {}),
        ],
      ),
      drawer: const SideNavBar(),
      body: Padding(
        padding: const EdgeInsets.all(AppGaps.screenPadding),
        child: Column(
          children: [
            const ChemistShopReportingSearchFilterCard(),
            AppGaps.largeV,
            Expanded(
              child: filteredReports.isEmpty
                  ? const Center(child: Text('No reports found.', style: TextStyle(color: AppColors.darkGrey)))
                  : ListView.builder(
                      itemCount: filteredReports.length,
                      itemBuilder: (context, index) {
                        return ChemistShopReportingCard(report: filteredReports[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
