class GiftItem {
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final int stockCount;

  const GiftItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.stockCount,
  });
}

class GiftRequest {
  final String id;
  final DateTime requestedOn;
  final String employeeId;
  final String doctorId;
  final String occasion;
  final String status;
  final String giftItemId;

  const GiftRequest({
    required this.id,
    required this.requestedOn,
    required this.employeeId,
    required this.doctorId,
    required this.occasion,
    required this.status,
    required this.giftItemId,
  });

  GiftRequest copyWith({
    String? id,
    DateTime? requestedOn,
    String? employeeId,
    String? doctorId,
    String? occasion,
    String? status,
    String? giftItemId,
  }) {
    return GiftRequest(
      id: id ?? this.id,
      requestedOn: requestedOn ?? this.requestedOn,
      employeeId: employeeId ?? this.employeeId,
      doctorId: doctorId ?? this.doctorId,
      occasion: occasion ?? this.occasion,
      status: status ?? this.status,
      giftItemId: giftItemId ?? this.giftItemId,
    );
  }
}
