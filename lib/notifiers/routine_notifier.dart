import 'package:flutter_riverpod/legacy.dart';
import '../models/routine.dart';

class RoutineState {
  final List<Routine> routines;
  final bool isLoading;
  final String searchQuery;
  final DateTime? startDate;
  final DateTime? endDate;

  RoutineState({
    this.routines = const [],
    this.isLoading = false,
    this.searchQuery = '',
    this.startDate,
    this.endDate,
  });

  RoutineState copyWith({
    List<Routine>? routines,
    bool? isLoading,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
    bool clearDates = false,
  }) {
    return RoutineState(
      routines: routines ?? this.routines,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      startDate: clearDates ? null : (startDate ?? this.startDate),
      endDate: clearDates ? null : (endDate ?? this.endDate),
    );
  }
}

class RoutineNotifier extends StateNotifier<RoutineState> {
  RoutineNotifier() : super(RoutineState()) {
    _loadMockData();
  }

  void _loadMockData() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 800));

    final today = DateTime.now();

    state = state.copyWith(
      isLoading: false,
      routines: [
        Routine(
          id: 'R001',
          employeeId: 'EMP001',
          date: DateTime(today.year, today.month, today.day),
          tasks: [
            RoutineTask(id: 'T1', title: 'Visit Dr. Sharma', description: 'Introduce new cardiovascular product line.', time: '10:00 AM'),
            RoutineTask(id: 'T2', title: 'Apollo Pharmacy Audit', description: 'Check stock levels and place new orders.', time: '02:30 PM'),
          ],
        ),
        Routine(
          id: 'R002',
          employeeId: 'EMP001',
          date: DateTime(today.year, today.month, today.day).add(const Duration(days: 1)),
          tasks: [
            RoutineTask(id: 'T3', title: 'Weekly Reporting', description: 'Compile weekly DCR and submit to manager.', time: '09:00 AM'),
          ],
        ),
      ],
      startDate: DateTime(today.year, today.month, today.day),
      endDate: DateTime(today.year, today.month, today.day).add(const Duration(days: 7)),
    );
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setDateRange(DateTime start, DateTime end) {
    state = state.copyWith(startDate: start, endDate: end);
  }

  void addRoutine(Routine routine) {
    state = state.copyWith(routines: [...state.routines, routine]);
  }

  void updateTask(String routineId, RoutineTask updatedTask) {
    final updatedRoutines = state.routines.map((r) {
      if (r.id == routineId) {
        final updatedTasks = r.tasks.map((t) => t.id == updatedTask.id ? updatedTask : t).toList();
        return r.copyWith(tasks: updatedTasks);
      }
      return r;
    }).toList();
    state = state.copyWith(routines: updatedRoutines);
  }

  void deleteTask(String routineId, String taskId) {
    final updatedRoutines = state.routines.map((r) {
      if (r.id == routineId) {
        final updatedTasks = r.tasks.where((t) => t.id != taskId).toList();
        return r.copyWith(tasks: updatedTasks);
      }
      return r;
    }).where((r) => r.tasks.isNotEmpty).toList(); // Optional: remove routine if empty
    state = state.copyWith(routines: updatedRoutines);
  }

  void deleteRoutine(String routineId) {
    state = state.copyWith(routines: state.routines.where((r) => r.id != routineId).toList());
  }
}
