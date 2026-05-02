class ChemistShopReporting {
  final String id;
  final DateTime date;
  final String time;
  final String status;
  final String chemistShopName;
  final String placeOfAppointment;
  final String chemistShopPhoneNo;
  final String employeeId;
  final List<String> presentedVisualAdIds;

  const ChemistShopReporting({
    required this.id,
    required this.date,
    required this.time,
    required this.status,
    required this.chemistShopName,
    required this.placeOfAppointment,
    required this.chemistShopPhoneNo,
    required this.employeeId,
    required this.presentedVisualAdIds,
  });

  ChemistShopReporting copyWith({
    String? id,
    DateTime? date,
    String? time,
    String? status,
    String? chemistShopName,
    String? placeOfAppointment,
    String? chemistShopPhoneNo,
    String? employeeId,
    List<String>? presentedVisualAdIds,
  }) {
    return ChemistShopReporting(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      chemistShopName: chemistShopName ?? this.chemistShopName,
      placeOfAppointment: placeOfAppointment ?? this.placeOfAppointment,
      chemistShopPhoneNo: chemistShopPhoneNo ?? this.chemistShopPhoneNo,
      employeeId: employeeId ?? this.employeeId,
      presentedVisualAdIds: presentedVisualAdIds ?? this.presentedVisualAdIds,
    );
  }
}
