import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../providers/dcr_provider.dart';
import '../../providers/employee_provider.dart';
import '../../cards/dcr/dcr_search_filter_card.dart';
import '../../cards/dcr/dcr_card.dart';

class DcrScreen extends ConsumerWidget {
  const DcrScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dcrProvider);
    final employees = ref.watch(employeeProvider);

    final filteredDcrs = state.dcrs.where((dcr) {
      if (state.filterStatus != 'All' && dcr.status != state.filterStatus) {
        return false;
      }
      
      if (state.dateRange != null) {
        final dcrDate = DateTime(dcr.date.year, dcr.date.month, dcr.date.day);
        final startDate = DateTime(state.dateRange!.start.year, state.dateRange!.start.month, state.dateRange!.start.day);
        final endDate = DateTime(state.dateRange!.end.year, state.dateRange!.end.month, state.dateRange!.end.day);
        
        if (dcrDate.isBefore(startDate) || dcrDate.isAfter(endDate)) {
          return false;
        }
      }

      if (state.searchEmployeeQuery.isNotEmpty) {
        final empQuery = state.searchEmployeeQuery.toLowerCase();
        bool match = false;
        for (var emp in employees.employees) {
          if (emp.id == dcr.employeeId && emp.fullName.toLowerCase().contains(empQuery)) {
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
        title: 'DCR Management',
        subtitle: 'Daily Call Reports from representatives',
        actions: [
          PremiumAppbarAction(icon: Iconsax.document_download, onTap: () {}),
        ],
      ),
      drawer: const SideNavBar(),
      body: Padding(
        padding: const EdgeInsets.all(AppGaps.screenPadding),
        child: Column(
          children: [
            const DcrSearchFilterCard(),
            AppGaps.largeV,
            Expanded(
              child: filteredDcrs.isEmpty
                  ? const Center(child: Text('No DCRs found.', style: TextStyle(color: AppColors.darkGrey)))
                  : ListView.builder(
                      itemCount: filteredDcrs.length,
                      itemBuilder: (context, index) {
                        return DcrCard(dcr: filteredDcrs[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
