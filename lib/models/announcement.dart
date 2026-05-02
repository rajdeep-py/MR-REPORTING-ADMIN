class Announcement {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;

  const Announcement({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  Announcement copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
  }) {
    return Announcement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
