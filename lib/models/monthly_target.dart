class MonthlyTarget {
  final String employeeId;
  final int month;
  final int year;
  final double targetAmount;
  final double targetAchieved;

  const MonthlyTarget({
    required this.employeeId,
    required this.month,
    required this.year,
    required this.targetAmount,
    required this.targetAchieved,
  });

  double get targetMissed => (targetAmount - targetAchieved) > 0 ? (targetAmount - targetAchieved) : 0;
  double get percentageAchieved => targetAmount > 0 ? (targetAchieved / targetAmount * 100) : 0.0;
}
