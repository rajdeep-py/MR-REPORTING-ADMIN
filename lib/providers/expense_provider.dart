import 'package:flutter_riverpod/legacy.dart';
import '../notifiers/expense_notifier.dart';

final expenseProvider = StateNotifierProvider<ExpenseNotifier, ExpenseState>((ref) {
  return ExpenseNotifier();
});
