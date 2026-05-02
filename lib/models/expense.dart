class ExpenseItem {
  final String id;
  final String title;
  final double amount;

  const ExpenseItem({
    required this.id,
    required this.title,
    required this.amount,
  });

  ExpenseItem copyWith({String? title, double? amount}) {
    return ExpenseItem(
      id: id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
    );
  }
}

class DailyExpense {
  final String id;
  final String employeeId;
  final DateTime date;
  final String status; // 'Pending', 'Paid', 'Rejected'
  final List<ExpenseItem> items;
  final List<String> attachedImages;

  const DailyExpense({
    required this.id,
    required this.employeeId,
    required this.date,
    required this.status,
    required this.items,
    this.attachedImages = const [],
  });

  double get totalAmount => items.fold(0, (sum, item) => sum + item.amount);

  DailyExpense copyWith({
    String? id,
    String? employeeId,
    DateTime? date,
    String? status,
    List<ExpenseItem>? items,
    List<String>? attachedImages,
  }) {
    return DailyExpense(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      date: date ?? this.date,
      status: status ?? this.status,
      items: items ?? this.items,
      attachedImages: attachedImages ?? this.attachedImages,
    );
  }
}
