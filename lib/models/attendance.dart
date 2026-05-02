class Attendance {
  final String id;
  final String employeeId;
  final DateTime date;
  final String status; // 'Present', 'Absent', 'Leave'
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final DateTime? breakInTime;
  final DateTime? breakOutTime;

  const Attendance({
    required this.id,
    required this.employeeId,
    required this.date,
    required this.status,
    this.checkInTime,
    this.checkOutTime,
    this.breakInTime,
    this.breakOutTime,
  });

  Attendance copyWith({
    String? id,
    String? employeeId,
    DateTime? date,
    String? status,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    DateTime? breakInTime,
    DateTime? breakOutTime,
  }) {
    return Attendance(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      date: date ?? this.date,
      status: status ?? this.status,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      breakInTime: breakInTime ?? this.breakInTime,
      breakOutTime: breakOutTime ?? this.breakOutTime,
    );
  }
}
