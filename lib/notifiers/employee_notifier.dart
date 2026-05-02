import 'package:flutter_riverpod/legacy.dart';
import '../models/employee.dart';

class EmployeeState {
  final List<Employee> employees;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final String? selectedHeadquarter;

  EmployeeState({
    this.employees = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.selectedHeadquarter,
  });

  EmployeeState copyWith({
    List<Employee>? employees,
    bool? isLoading,
    String? error,
    String? searchQuery,
    String? selectedHeadquarter,
    bool clearError = false,
  }) {
    return EmployeeState(
      employees: employees ?? this.employees,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      searchQuery: searchQuery ?? this.searchQuery,
      selectedHeadquarter: selectedHeadquarter ?? this.selectedHeadquarter,
    );
  }

  List<Employee> get filteredEmployees {
    return employees.where((e) {
      final matchesSearch =
          e.fullName.toLowerCase().contains(searchQuery.toLowerCase()) ||
          e.phoneNo.contains(searchQuery);
      final matchesHQ =
          selectedHeadquarter == null ||
          selectedHeadquarter!.isEmpty ||
          e.headquarter == selectedHeadquarter;
      return matchesSearch && matchesHQ;
    }).toList();
  }
}

class EmployeeNotifier extends StateNotifier<EmployeeState> {
  EmployeeNotifier() : super(EmployeeState()) {
    _loadMockData();
  }

  void _loadMockData() {
    state = state.copyWith(isLoading: true);
    // Simulate network delay
    Future.delayed(const Duration(seconds: 1), () {
      state = state.copyWith(
        isLoading: false,
        employees: [
          const Employee(
            id: 'EMP001',
            fullName: 'Rajdeep Dey',
            phoneNo: '+91 9876543210',
            email: 'rajdeep@example.com',
            headquarter: 'Mumbai',
            areasOfWork: ['Andheri', 'Bandra', 'Dadar'],
            monthlyTarget: 500000.0,
            password: 'password123',
          ),
          const Employee(
            id: 'EMP002',
            fullName: 'Amit Kumar',
            phoneNo: '+91 8765432109',
            email: 'amit@example.com',
            headquarter: 'Delhi',
            areasOfWork: ['CP', 'Rohini'],
            monthlyTarget: 450000.0,
            password: 'password123',
          ),
        ],
      );
    });
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setFilterHeadquarter(String? hq) {
    state = state.copyWith(selectedHeadquarter: hq);
  }

  Future<void> addEmployee(Employee employee) async {
    state = state.copyWith(isLoading: true, clearError: true);
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(
      isLoading: false,
      employees: [...state.employees, employee],
    );
  }

  Future<void> updateEmployee(Employee employee) async {
    state = state.copyWith(isLoading: true, clearError: true);
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(
      isLoading: false,
      employees: state.employees
          .map((e) => e.id == employee.id ? employee : e)
          .toList(),
    );
  }

  Future<void> deleteEmployee(String id) async {
    state = state.copyWith(isLoading: true, clearError: true);
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(
      isLoading: false,
      employees: state.employees.where((e) => e.id != id).toList(),
    );
  }
}
