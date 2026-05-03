import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/side_nav_bar.dart';
import '../../providers/dashboard_provider.dart';
import '../../cards/dashboard/greeting_card.dart';
import '../../cards/dashboard/count_card.dart';
import '../../cards/dashboard/employee_graph_card.dart';
import '../../cards/dashboard/attendance_graph_card.dart';
import '../../cards/dashboard/dcr_graph_card.dart';
import '../../cards/dashboard/chemist_shop_graph_card.dart';
import '../../cards/dashboard/doctor_pie_graph_card.dart';
import '../../cards/dashboard/order_graph_card.dart';
import '../../cards/dashboard/stockist_graph_card.dart';
import '../../cards/dashboard/gift_reuqest_graph_card.dart';
import '../../widgets/footer.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PremiumAppBar(
        title: 'Dashboard & Analytics',
        subtitle: 'Comprehensive overview of your entire ecosystem',
      ),
      drawer: const SideNavBar(),
      body: state.isLoading || state.data == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.black))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppGaps.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const GreetingCard(),
                  AppGaps.largeV,
                  CountCard(data: state.data!),
                  AppGaps.largeV,
                  EmployeeGraphCard(data: state.data!.employeeOnboardingData),
                  AppGaps.largeV,
                  AttendanceGraphCard(data: state.data!.attendanceData),
                  AppGaps.largeV,
                  DcrGraphCard(data: state.data!.dcrData),
                  AppGaps.largeV,
                  ChemistShopGraphCard(data: state.data!.chemistReportingData),
                  AppGaps.largeV,
                  DoctorPieGraphCard(data: state.data!.doctorSpecializations),
                  AppGaps.largeV,
                  OrderGraphCard(data: state.data!.ordersData),
                  AppGaps.largeV,
                  StockistGraphCard(data: state.data!.stockistOnboardingData),
                  AppGaps.largeV,
                  GiftRequestGraphCard(data: state.data!.giftRequestData),
                  AppGaps.extraLargeV,
                  const Footer(),
                ],
              ),
            ),
    );
  }
}
