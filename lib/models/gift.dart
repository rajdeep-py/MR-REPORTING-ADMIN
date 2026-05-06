class GiftItem {
  final String giftId;
  final String adminId;
  final String giftItemName;
  final String giftItemDescription;
  final String status;
  final double price;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GiftItem({
    required this.giftId,
    required this.adminId,
    required this.giftItemName,
    required this.giftItemDescription,
    required this.status,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GiftItem.fromJson(Map<String, dynamic> json) {
    return GiftItem(
      giftId: json['gift_id'] ?? '',
      adminId: json['admin_id'] ?? '',
      giftItemName: json['gift_item_name'] ?? '',
      giftItemDescription: json['gift_item_description'] ?? '',
      status: json['status'] ?? 'active',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gift_id': giftId,
      'admin_id': adminId,
      'gift_item_name': giftItemName,
      'gift_item_description': giftItemDescription,
      'status': status,
      'price': price,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
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
