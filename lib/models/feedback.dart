class FeedbackItem {
  final String id;
  final String message;
  final DateTime createdAt;
  final String? replyMessage;
  final DateTime? repliedAt;

  const FeedbackItem({
    required this.id,
    required this.message,
    required this.createdAt,
    this.replyMessage,
    this.repliedAt,
  });

  FeedbackItem copyWith({
    String? id,
    String? message,
    DateTime? createdAt,
    String? replyMessage,
    DateTime? repliedAt,
  }) {
    return FeedbackItem(
      id: id ?? this.id,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      replyMessage: replyMessage ?? this.replyMessage,
      repliedAt: repliedAt ?? this.repliedAt,
    );
  }
}
