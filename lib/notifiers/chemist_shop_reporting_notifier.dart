import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/chemist_shop_reporting.dart';

class ChemistShopReportingState {
  final List<ChemistShopReporting> reports;
  final String searchEmployeeQuery;
  final String filterStatus;
  final DateTimeRange? dateRange;

  ChemistShopReportingState({
    this.reports = const [],
    this.searchEmployeeQuery = '',
    this.filterStatus = 'All',
    this.dateRange,
  });

  ChemistShopReportingState copyWith({
    List<ChemistShopReporting>? reports,
    String? searchEmployeeQuery,
    String? filterStatus,
    DateTimeRange? dateRange,
    bool clearDateRange = false,
  }) {
    return ChemistShopReportingState(
      reports: reports ?? this.reports,
      searchEmployeeQuery: searchEmployeeQuery ?? this.searchEmployeeQuery,
      filterStatus: filterStatus ?? this.filterStatus,
      dateRange: clearDateRange ? null : (dateRange ?? this.dateRange),
    );
  }
}

class ChemistShopReportingNotifier extends StateNotifier<ChemistShopReportingState> {
  ChemistShopReportingNotifier() : super(ChemistShopReportingState()) {
    _loadMockData();
  }

  void _loadMockData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(reports: [
      ChemistShopReporting(
        id: 'CSR-8812',
        date: DateTime.now().subtract(const Duration(days: 1)),
        time: '11:00 AM',
        status: 'completed',
        chemistShopName: 'HealthPlus Pharmacy',
        placeOfAppointment: '101 Wellness Blvd, Sector 4, Mumbai',
        chemistShopPhoneNo: '+91 98765 43210',
        employeeId: 'EMP001',
        presentedVisualAdIds: ['1'],
      ),
      ChemistShopReporting(
        id: 'CSR-8813',
        date: DateTime.now(),
        time: '01:30 PM',
        status: 'pending',
        chemistShopName: 'CareWell Meds',
        placeOfAppointment: '42 Health St, Main Market, Delhi',
        chemistShopPhoneNo: '+91 87654 32109',
        employeeId: 'EMP002',
        presentedVisualAdIds: ['1', '2'],
      ),
    ]);
  }

  void setSearchEmployeeQuery(String query) {
    state = state.copyWith(searchEmployeeQuery: query);
  }

  void setFilterStatus(String status) {
    state = state.copyWith(filterStatus: status);
  }

  void setDateRange(DateTimeRange? range) {
    state = state.copyWith(dateRange: range, clearDateRange: range == null);
  }
}
