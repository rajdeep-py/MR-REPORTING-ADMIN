import 'dart:typed_data';
import 'package:flutter_riverpod/legacy.dart';
import '../models/employee.dart';
import '../services/employee/employee_services.dart';

class EmployeeState {
  final List<Employee> employees;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final String filterStatus;
  final String? selectedHeadquarter;

  EmployeeState({
    this.employees = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.filterStatus = 'All',
    this.selectedHeadquarter,
  });

  EmployeeState copyWith({
    List<Employee>? employees,
    bool? isLoading,
    String? error,
    String? searchQuery,
    String? filterStatus,
    String? selectedHeadquarter,
    bool clearHeadquarter = false,
  }) {
    return EmployeeState(
      employees: employees ?? this.employees,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      filterStatus: filterStatus ?? this.filterStatus,
      selectedHeadquarter: clearHeadquarter ? null : (selectedHeadquarter ?? this.selectedHeadquarter),
    );
  }
}

class EmployeeNotifier extends StateNotifier<EmployeeState> {
  final EmployeeServices _services = EmployeeServices();

  EmployeeNotifier() : super(EmployeeState());

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setFilterStatus(String status) {
    state = state.copyWith(filterStatus: status);
  }

  void setFilterHeadquarter(String? hq) {
    if (hq == null) {
      state = state.copyWith(clearHeadquarter: true);
    } else {
      state = state.copyWith(selectedHeadquarter: hq);
    }
  }

  Future<void> fetchEmployees(String adminId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final employees = await _services.getEmployeesByAdmin(adminId);
      state = state.copyWith(employees: employees, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<bool> addEmployee({
    required String fullName,
    required String phoneNo,
    required String email,
    required String password,
    required String designation,
    required String adminId,
    String? alternativePhoneNo,
    String? headquarter,
    Map<String, dynamic>? areaOfWork,
    int? monthlyTarget,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final newEmployee = await _services.createEmployee(
        fullName: fullName,
        phoneNo: phoneNo,
        email: email,
        password: password,
        designation: designation,
        adminId: adminId,
        alternativePhoneNo: alternativePhoneNo,
        headquarter: headquarter,
        areaOfWork: areaOfWork,
        monthlyTarget: monthlyTarget,
        imageBytes: imageBytes,
        imageName: imageName,
      );
      if (newEmployee != null) {
        state = state.copyWith(
          employees: [...state.employees, newEmployee],
          isLoading: false,
        );
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> updateEmployee({
    required String employeeId,
    String? fullName,
    String? phoneNo,
    String? email,
    String? password,
    String? designation,
    String? alternativePhoneNo,
    String? headquarter,
    Map<String, dynamic>? areaOfWork,
    int? monthlyTarget,
    String? status,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedEmployee = await _services.updateEmployee(
        employeeId: employeeId,
        fullName: fullName,
        phoneNo: phoneNo,
        email: email,
        password: password,
        designation: designation,
        alternativePhoneNo: alternativePhoneNo,
        headquarter: headquarter,
        areaOfWork: areaOfWork,
        monthlyTarget: monthlyTarget,
        status: status,
        imageBytes: imageBytes,
        imageName: imageName,
      );
      if (updatedEmployee != null) {
        state = state.copyWith(
          employees: state.employees.map((e) => e.id == employeeId ? updatedEmployee : e).toList(),
          isLoading: false,
        );
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> deleteEmployee(String employeeId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final success = await _services.deleteEmployee(employeeId);
      if (success) {
        state = state.copyWith(
          employees: state.employees.where((e) => e.id != employeeId).toList(),
          isLoading: false,
        );
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      return false;
    }
  }
}
