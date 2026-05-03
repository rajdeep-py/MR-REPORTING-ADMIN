import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../providers/order_provider.dart';
import '../../providers/employee_provider.dart';
import '../../cards/order/order_search_filter_card.dart';
import '../../cards/order/order_card.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(orderProvider);
    final employees = ref.watch(employeeProvider);

    final filteredOrders = state.orders.where((order) {
      if (state.filterStatus != 'All' && order.status != state.filterStatus) {
        return false;
      }
      
      if (state.dateRange != null) {
        final oDate = DateTime(order.orderedOn.year, order.orderedOn.month, order.orderedOn.day);
        final startDate = DateTime(state.dateRange!.start.year, state.dateRange!.start.month, state.dateRange!.start.day);
        final endDate = DateTime(state.dateRange!.end.year, state.dateRange!.end.month, state.dateRange!.end.day);
        
        if (oDate.isBefore(startDate) || oDate.isAfter(endDate)) {
          return false;
        }
      }

      if (state.searchEmployeeQuery.isNotEmpty) {
        final empQuery = state.searchEmployeeQuery.toLowerCase();
        bool match = false;
        for (var emp in employees.employees) {
          if (emp.id == order.employeeId && emp.fullName.toLowerCase().contains(empQuery)) {
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
        title: 'Order Management',
        subtitle: 'Track and manage product orders',
        actions: [
          PremiumAppbarAction(icon: Iconsax.document_download, onTap: () {}),
        ],
      ),
      drawer: const SideNavBar(),
      body: Padding(
        padding: const EdgeInsets.all(AppGaps.screenPadding),
        child: Column(
          children: [
            const OrderSearchFilterCard(),
            AppGaps.largeV,
            Expanded(
              child: filteredOrders.isEmpty
                  ? const Center(child: Text('No orders found.', style: TextStyle(color: AppColors.darkGrey)))
                  : ListView.builder(
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        return OrderCard(order: filteredOrders[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
