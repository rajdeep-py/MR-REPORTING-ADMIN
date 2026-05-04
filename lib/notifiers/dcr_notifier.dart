import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/dcr.dart';

class DcrState {
  final List<Dcr> dcrs;
  final String searchEmployeeQuery;
  final String filterStatus; // 'All', 'pending', 'completed', 'cancelled'
  final DateTimeRange? dateRange;

  DcrState({
    this.dcrs = const [],
    this.searchEmployeeQuery = '',
    this.filterStatus = 'All',
    this.dateRange,
  });

  DcrState copyWith({
    List<Dcr>? dcrs,
    String? searchEmployeeQuery,
    String? filterStatus,
    DateTimeRange? dateRange,
    bool clearDateRange = false,
  }) {
    return DcrState(
      dcrs: dcrs ?? this.dcrs,
      searchEmployeeQuery: searchEmployeeQuery ?? this.searchEmployeeQuery,
      filterStatus: filterStatus ?? this.filterStatus,
      dateRange: clearDateRange ? null : (dateRange ?? this.dateRange),
    );
  }
}

class DcrNotifier extends StateNotifier<DcrState> {
  DcrNotifier() : super(DcrState()) {
    _loadMockData();
  }

  void _loadMockData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(
      dcrs: [
        Dcr(
          id: 'DCR-10293',
          date: DateTime.now().subtract(const Duration(days: 1)),
          time: '10:30 AM',
          status: 'completed',
          doctorName: 'Dr. Sarah Mitchell',
          doctorSpecialization: 'Cardiologist',
          placeOfAppointment: 'City Heart Clinic, Mumbai',
          doctorPhoneNo: '+1 234 567 8901',
          employeeId: 'EMP001',
          presentedVisualAdIds: ['1', '2'],
        ),
        Dcr(
          id: 'DCR-10294',
          date: DateTime.now(),
          time: '02:00 PM',
          status: 'pending',
          doctorName: 'Dr. James Wilson',
          doctorSpecialization: 'Neurologist',
          placeOfAppointment: 'NeuroCare Center, Delhi',
          doctorPhoneNo: '+1 987 654 3210',
          employeeId: 'EMP002',
          presentedVisualAdIds: ['2'],
        ),
        Dcr(
          id: 'DCR-10295',
          date: DateTime.now().add(const Duration(days: 1)),
          time: '04:15 PM',
          status: 'cancelled',
          doctorName: 'Dr. Emily Chen',
          doctorSpecialization: 'Pediatrician',
          placeOfAppointment: 'Kids Health Hub',
          doctorPhoneNo: '+1 555 123 4567',
          employeeId: 'EMP001',
          presentedVisualAdIds: [],
        ),
      ],
    );
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
