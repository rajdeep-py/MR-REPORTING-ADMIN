class Team {
  final String id;
  final String name;
  final String description;
  final String? photoPath;
  final List<String> memberIds;

  const Team({
    required this.id,
    required this.name,
    required this.description,
    this.photoPath,
    required this.memberIds,
  });

  Team copyWith({
    String? id,
    String? name,
    String? description,
    String? photoPath,
    List<String>? memberIds,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      photoPath: photoPath ?? this.photoPath,
      memberIds: memberIds ?? this.memberIds,
    );
  }
}
