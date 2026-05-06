class FeedbackItem {
  final String feedbackId;
  final String adminId;
  final String organisationName;
  final String phoneNo;
  final String email;
  final String feedbackMessage;
  final String? feedbackReply;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FeedbackItem({
    required this.feedbackId,
    required this.adminId,
    required this.organisationName,
    required this.phoneNo,
    required this.email,
    required this.feedbackMessage,
    this.feedbackReply,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FeedbackItem.fromJson(Map<String, dynamic> json) {
    return FeedbackItem(
      feedbackId: json['feedback_id'] ?? '',
      adminId: json['admin_id'] ?? '',
      organisationName: json['organisation_name'] ?? '',
      phoneNo: json['phone_no'] ?? '',
      email: json['email'] ?? '',
      feedbackMessage: json['feedback_message'] ?? '',
      feedbackReply: json['feedback_reply'],
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
      'feedback_id': feedbackId,
      'admin_id': adminId,
      'organisation_name': organisationName,
      'phone_no': phoneNo,
      'email': email,
      'feedback_message': feedbackMessage,
      'feedback_reply': feedbackReply,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  FeedbackItem copyWith({
    String? feedbackId,
    String? adminId,
    String? organisationName,
    String? phoneNo,
    String? email,
    String? feedbackMessage,
    String? feedbackReply,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FeedbackItem(
      feedbackId: feedbackId ?? this.feedbackId,
      adminId: adminId ?? this.adminId,
      organisationName: organisationName ?? this.organisationName,
      phoneNo: phoneNo ?? this.phoneNo,
      email: email ?? this.email,
      feedbackMessage: feedbackMessage ?? this.feedbackMessage,
      feedbackReply: feedbackReply ?? this.feedbackReply,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
