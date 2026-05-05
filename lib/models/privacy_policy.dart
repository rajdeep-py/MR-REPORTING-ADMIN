class PrivacyPolicy {
  final String privacyId;
  final String privacyHeader;
  final String privacyDescription;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PrivacyPolicy({
    required this.privacyId,
    required this.privacyHeader,
    required this.privacyDescription,
    this.createdAt,
    this.updatedAt,
  });

  factory PrivacyPolicy.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicy(
      privacyId: json['privacy_id'] ?? '',
      privacyHeader: json['privacy_header'] ?? '',
      privacyDescription: json['privacy_description'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'privacy_header': privacyHeader,
      'privacy_description': privacyDescription,
    };
  }

  PrivacyPolicy copyWith({
    String? privacyId,
    String? privacyHeader,
    String? privacyDescription,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PrivacyPolicy(
      privacyId: privacyId ?? this.privacyId,
      privacyHeader: privacyHeader ?? this.privacyHeader,
      privacyDescription: privacyDescription ?? this.privacyDescription,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
