import 'package:flutter_riverpod/legacy.dart';
import '../models/expense.dart';

class ExpenseState {
  final List<DailyExpense> expenses;
  final bool isLoading;
  final String searchQuery;
  final DateTime? filterDate;
  final String filterStatus; // 'All', 'Pending', 'Paid', 'Rejected'

  ExpenseState({
    this.expenses = const [],
    this.isLoading = false,
    this.searchQuery = '',
    this.filterDate,
    this.filterStatus = 'All',
  });

  ExpenseState copyWith({
    List<DailyExpense>? expenses,
    bool? isLoading,
    String? searchQuery,
    DateTime? filterDate,
    String? filterStatus,
    bool clearDate = false,
  }) {
    return ExpenseState(
      expenses: expenses ?? this.expenses,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      filterDate: clearDate ? null : (filterDate ?? this.filterDate),
      filterStatus: filterStatus ?? this.filterStatus,
    );
  }
}

class ExpenseNotifier extends StateNotifier<ExpenseState> {
  ExpenseNotifier() : super(ExpenseState()) {
    _loadMockData();
  }

  void _loadMockData() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 800));

    final today = DateTime.now();

    state = state.copyWith(
      isLoading: false,
      expenses: [
        DailyExpense(
          id: 'E001',
          employeeId: 'EMP001',
          date: DateTime(today.year, today.month, today.day),
          status: 'Pending',
          attachedImages: [
            'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=400&q=80',
            'https://images.unsplash.com/photo-1589829085413-56de8ae18c73?w=400&q=80'
          ],
          items: [
            const ExpenseItem(id: 'I1', title: 'Travel (Bus)', amount: 150.0),
            const ExpenseItem(id: 'I2', title: 'Lunch', amount: 200.0),
          ],
        ),
        DailyExpense(
          id: 'E002',
          employeeId: 'EMP001',
          date: DateTime(today.year, today.month, today.day).subtract(const Duration(days: 1)),
          status: 'Paid',
          attachedImages: [
            'https://images.unsplash.com/photo-1589829085413-56de8ae18c73?w=400&q=80'
          ],
          items: [
            const ExpenseItem(id: 'I3', title: 'Hotel Stay', amount: 1200.0),
            const ExpenseItem(id: 'I4', title: 'Dinner', amount: 300.0),
          ],
        ),
        DailyExpense(
          id: 'E003',
          employeeId: 'EMP002',
          date: DateTime(today.year, today.month, today.day),
          status: 'Rejected',
          items: [
            const ExpenseItem(id: 'I5', title: 'Flight Ticket', amount: 5000.0),
          ],
        ),
      ],
    );
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setFilterDate(DateTime? date) {
    state = state.copyWith(filterDate: date, clearDate: date == null);
  }

  void setFilterStatus(String status) {
    state = state.copyWith(filterStatus: status);
  }

  void updateExpenseStatus(String id, String newStatus) {
    final updated = state.expenses.map((e) {
      if (e.id == id) return e.copyWith(status: newStatus);
      return e;
    }).toList();
    state = state.copyWith(expenses: updated);
  }
}
