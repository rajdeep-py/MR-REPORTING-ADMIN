import 'package:flutter_riverpod/legacy.dart';
import '../models/dashboard.dart';

class DashboardState {
  final DashboardData? data;
  final bool isLoading;

  DashboardState({this.data, this.isLoading = true});

  DashboardState copyWith({DashboardData? data, bool? isLoading}) {
    return DashboardState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier() : super(DashboardState()) {
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock dashboard data
    final mockData = DashboardData(
      totalEmployees: 48,
      totalDoctors: 124,
      totalChemistShops: 82,
      totalStockists: 24,
      totalTeams: 8,
      pendingGiftRequests: 12,
      pendingDcr: 45,
      completedDcr: 320,
      pendingChemistReporting: 15,
      completedChemistReporting: 240,
      pendingOrders: 8,
      completedOrders: 142,
      pendingExpense: 22,
      completedExpense: 184,
      totalVisualAds: 35,
      employeeOnboardingData: const [
        MonthlyData('Jan', 2), MonthlyData('Feb', 5), MonthlyData('Mar', 3), MonthlyData('Apr', 8),
        MonthlyData('May', 4), MonthlyData('Jun', 6), MonthlyData('Jul', 2), MonthlyData('Aug', 7),
        MonthlyData('Sep', 5), MonthlyData('Oct', 3), MonthlyData('Nov', 1), MonthlyData('Dec', 2),
      ],
      attendanceData: const [
        AttendanceData('Jan', 40, 8), AttendanceData('Feb', 42, 6), AttendanceData('Mar', 45, 3),
        AttendanceData('Apr', 46, 2), AttendanceData('May', 41, 7), AttendanceData('Jun', 44, 4),
        AttendanceData('Jul', 43, 5), AttendanceData('Aug', 47, 1), AttendanceData('Sep', 45, 3),
        AttendanceData('Oct', 46, 2), AttendanceData('Nov', 48, 0), AttendanceData('Dec', 42, 6),
      ],
      dcrData: const [
        MonthlyData('Jan', 120), MonthlyData('Feb', 150), MonthlyData('Mar', 140), MonthlyData('Apr', 210),
        MonthlyData('May', 180), MonthlyData('Jun', 230), MonthlyData('Jul', 190), MonthlyData('Aug', 280),
        MonthlyData('Sep', 310), MonthlyData('Oct', 290), MonthlyData('Nov', 320), MonthlyData('Dec', 340),
      ],
      chemistReportingData: const [
        MonthlyData('Jan', 80), MonthlyData('Feb', 90), MonthlyData('Mar', 110), MonthlyData('Apr', 150),
        MonthlyData('May', 140), MonthlyData('Jun', 170), MonthlyData('Jul', 160), MonthlyData('Aug', 210),
        MonthlyData('Sep', 220), MonthlyData('Oct', 240), MonthlyData('Nov', 230), MonthlyData('Dec', 255),
      ],
      doctorSpecializations: const [
        PieData('Cardiology', 40, 0xFFE57373),
        PieData('Neurology', 25, 0xFF64B5F6),
        PieData('Pediatrics', 30, 0xFF81C784),
        PieData('Orthopedics', 15, 0xFFFFB74D),
        PieData('General', 14, 0xFFBA68C8),
      ],
      ordersData: const [
        MonthlyData('Jan', 20), MonthlyData('Feb', 25), MonthlyData('Mar', 18), MonthlyData('Apr', 30),
        MonthlyData('May', 40), MonthlyData('Jun', 35), MonthlyData('Jul', 45), MonthlyData('Aug', 55),
        MonthlyData('Sep', 50), MonthlyData('Oct', 65), MonthlyData('Nov', 80), MonthlyData('Dec', 90),
      ],
      stockistOnboardingData: const [
        MonthlyData('Jan', 1), MonthlyData('Feb', 0), MonthlyData('Mar', 2), MonthlyData('Apr', 1),
        MonthlyData('May', 3), MonthlyData('Jun', 2), MonthlyData('Jul', 4), MonthlyData('Aug', 1),
        MonthlyData('Sep', 2), MonthlyData('Oct', 3), MonthlyData('Nov', 2), MonthlyData('Dec', 3),
      ],
      giftRequestData: const [
        MonthlyData('Jan', 5), MonthlyData('Feb', 8), MonthlyData('Mar', 12), MonthlyData('Apr', 7),
        MonthlyData('May', 10), MonthlyData('Jun', 15), MonthlyData('Jul', 18), MonthlyData('Aug', 14),
        MonthlyData('Sep', 20), MonthlyData('Oct', 25), MonthlyData('Nov', 30), MonthlyData('Dec', 40),
      ],
    );

    state = state.copyWith(data: mockData, isLoading: false);
  }
}
