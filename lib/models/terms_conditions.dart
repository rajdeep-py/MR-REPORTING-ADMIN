class TermsCondition {
  final String termId;
  final String termHeader;
  final String termDescription;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TermsCondition({
    required this.termId,
    required this.termHeader,
    required this.termDescription,
    this.createdAt,
    this.updatedAt,
  });

  factory TermsCondition.fromJson(Map<String, dynamic> json) {
    return TermsCondition(
      termId: json['term_id'] ?? '',
      termHeader: json['term_header'] ?? '',
      termDescription: json['term_description'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'term_header': termHeader,
      'term_description': termDescription,
    };
  }

  TermsCondition copyWith({
    String? termId,
    String? termHeader,
    String? termDescription,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TermsCondition(
      termId: termId ?? this.termId,
      termHeader: termHeader ?? this.termHeader,
      termDescription: termDescription ?? this.termDescription,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
