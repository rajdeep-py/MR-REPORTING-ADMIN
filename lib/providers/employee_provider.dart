import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/employee_notifier.dart';

final employeeProvider = StateNotifierProvider<EmployeeNotifier, EmployeeState>(
  (ref) {
    return EmployeeNotifier();
  },
);
