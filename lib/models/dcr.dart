class Dcr {
  final String id;
  final DateTime date;
  final String time;
  final String status;
  final String doctorName;
  final String doctorSpecialization;
  final String placeOfAppointment;
  final String doctorPhoneNo;
  final String employeeId;
  final List<String> presentedVisualAdIds;

  const Dcr({
    required this.id,
    required this.date,
    required this.time,
    required this.status,
    required this.doctorName,
    required this.doctorSpecialization,
    required this.placeOfAppointment,
    required this.doctorPhoneNo,
    required this.employeeId,
    required this.presentedVisualAdIds,
  });

  Dcr copyWith({
    String? id,
    DateTime? date,
    String? time,
    String? status,
    String? doctorName,
    String? doctorSpecialization,
    String? placeOfAppointment,
    String? doctorPhoneNo,
    String? employeeId,
    List<String>? presentedVisualAdIds,
  }) {
    return Dcr(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      doctorName: doctorName ?? this.doctorName,
      doctorSpecialization: doctorSpecialization ?? this.doctorSpecialization,
      placeOfAppointment: placeOfAppointment ?? this.placeOfAppointment,
      doctorPhoneNo: doctorPhoneNo ?? this.doctorPhoneNo,
      employeeId: employeeId ?? this.employeeId,
      presentedVisualAdIds: presentedVisualAdIds ?? this.presentedVisualAdIds,
    );
  }
}
