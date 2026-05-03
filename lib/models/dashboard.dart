class MonthlyData {
  final String month;
  final int count;
  const MonthlyData(this.month, this.count);
}

class AttendanceData {
  final String month;
  final int present;
  final int absent;
  const AttendanceData(this.month, this.present, this.absent);
}

class PieData {
  final String category;
  final int count;
  final int colorValue;
  const PieData(this.category, this.count, this.colorValue);
}

class DashboardData {
  final int totalEmployees;
  final int totalDoctors;
  final int totalChemistShops;
  final int totalStockists;
  final int totalTeams;
  final int pendingGiftRequests;
  final int pendingDcr;
  final int completedDcr;
  final int pendingChemistReporting;
  final int completedChemistReporting;
  final int pendingOrders;
  final int completedOrders;
  final int pendingExpense;
  final int completedExpense;
  final int totalVisualAds;

  final List<MonthlyData> employeeOnboardingData;
  final List<AttendanceData> attendanceData;
  final List<MonthlyData> dcrData;
  final List<MonthlyData> chemistReportingData;
  final List<PieData> doctorSpecializations;
  final List<MonthlyData> ordersData;
  final List<MonthlyData> stockistOnboardingData;
  final List<MonthlyData> giftRequestData;

  const DashboardData({
    required this.totalEmployees,
    required this.totalDoctors,
    required this.totalChemistShops,
    required this.totalStockists,
    required this.totalTeams,
    required this.pendingGiftRequests,
    required this.pendingDcr,
    required this.completedDcr,
    required this.pendingChemistReporting,
    required this.completedChemistReporting,
    required this.pendingOrders,
    required this.completedOrders,
    required this.pendingExpense,
    required this.completedExpense,
    required this.totalVisualAds,
    required this.employeeOnboardingData,
    required this.attendanceData,
    required this.dcrData,
    required this.chemistReportingData,
    required this.doctorSpecializations,
    required this.ordersData,
    required this.stockistOnboardingData,
    required this.giftRequestData,
  });
}
