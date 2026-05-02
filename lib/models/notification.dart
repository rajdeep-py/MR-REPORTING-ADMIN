class AppNotification {
  final String id;
  final String header;
  final String description;
  final DateTime timestamp;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.header,
    required this.description,
    required this.timestamp,
    this.isRead = false,
  });

  AppNotification copyWith({
    String? id,
    String? header,
    String? description,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      header: header ?? this.header,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}
