import 'package:flutter_riverpod/legacy.dart';
import '../models/attendance.dart';

class AttendanceState {
  final List<Attendance> records;
  final bool isLoading;
  final String? selectedEmployeeId;
  final DateTime selectedDate;

  AttendanceState({
    this.records = const [],
    this.isLoading = false,
    this.selectedEmployeeId,
    DateTime? selectedDate,
  }) : selectedDate = selectedDate ?? DateTime.now();

  AttendanceState copyWith({
    List<Attendance>? records,
    bool? isLoading,
    String? selectedEmployeeId,
    DateTime? selectedDate,
  }) {
    return AttendanceState(
      records: records ?? this.records,
      isLoading: isLoading ?? this.isLoading,
      selectedEmployeeId: selectedEmployeeId ?? this.selectedEmployeeId,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}

class AttendanceNotifier extends StateNotifier<AttendanceState> {
  AttendanceNotifier() : super(AttendanceState()) {
    _loadMockData();
  }

  void _loadMockData() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 800));

    final today = DateTime.now();

    state = state.copyWith(
      isLoading: false,
      records: [
        Attendance(
          id: 'A001',
          employeeId: 'EMP001',
          date: DateTime(today.year, today.month, today.day),
          status: 'Present',
          checkInTime: DateTime(today.year, today.month, today.day, 9, 15),
          breakInTime: DateTime(today.year, today.month, today.day, 13, 0),
          breakOutTime: DateTime(today.year, today.month, today.day, 14, 0),
          checkOutTime: DateTime(today.year, today.month, today.day, 18, 30),
        ),
        Attendance(
          id: 'A002',
          employeeId: 'EMP001',
          date: DateTime(
            today.year,
            today.month,
            today.day,
          ).subtract(const Duration(days: 1)),
          status: 'Present',
          checkInTime: DateTime(
            today.year,
            today.month,
            today.day,
            9,
            0,
          ).subtract(const Duration(days: 1)),
          checkOutTime: DateTime(
            today.year,
            today.month,
            today.day,
            18,
            0,
          ).subtract(const Duration(days: 1)),
        ),
        Attendance(
          id: 'A003',
          employeeId: 'EMP001',
          date: DateTime(
            today.year,
            today.month,
            today.day,
          ).subtract(const Duration(days: 2)),
          status: 'Absent',
        ),
        Attendance(
          id: 'A004',
          employeeId: 'EMP002',
          date: DateTime(today.year, today.month, today.day),
          status: 'Absent',
        ),
      ],
      selectedEmployeeId: 'EMP001',
    );
  }

  void selectEmployee(String id) {
    state = state.copyWith(selectedEmployeeId: id);
  }

  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void markAttendance(String status) {
    if (state.selectedEmployeeId == null) return;

    final existingIndex = state.records.indexWhere(
      (r) =>
          r.employeeId == state.selectedEmployeeId &&
          r.date.year == state.selectedDate.year &&
          r.date.month == state.selectedDate.month &&
          r.date.day == state.selectedDate.day,
    );

    List<Attendance> updated = List.from(state.records);
    if (existingIndex >= 0) {
      updated[existingIndex] = updated[existingIndex].copyWith(status: status);
    } else {
      updated.add(
        Attendance(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          employeeId: state.selectedEmployeeId!,
          date: state.selectedDate,
          status: status,
        ),
      );
    }

    state = state.copyWith(records: updated);
  }
}
