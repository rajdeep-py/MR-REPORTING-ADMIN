import 'package:flutter_riverpod/legacy.dart';

class MonthlyTargetState {
  final String? selectedEmployeeId;
  final int selectedMonth;
  final int selectedYear;

  MonthlyTargetState({
    this.selectedEmployeeId,
    required this.selectedMonth,
    required this.selectedYear,
  });

  MonthlyTargetState copyWith({
    String? selectedEmployeeId,
    int? selectedMonth,
    int? selectedYear,
  }) {
    return MonthlyTargetState(
      selectedEmployeeId: selectedEmployeeId ?? this.selectedEmployeeId,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
    );
  }
}

class MonthlyTargetNotifier extends StateNotifier<MonthlyTargetState> {
  MonthlyTargetNotifier()
    : super(
        MonthlyTargetState(
          selectedMonth: DateTime.now().month,
          selectedYear: DateTime.now().year,
        ),
      );

  void setSelectedEmployee(String? employeeId) {
    state = state.copyWith(selectedEmployeeId: employeeId);
  }

  void setSelectedMonth(int month) {
    state = state.copyWith(selectedMonth: month);
  }

  void setSelectedYear(int year) {
    state = state.copyWith(selectedYear: year);
  }
}
