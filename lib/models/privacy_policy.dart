class PrivacyPolicy {
  final String id;
  final String header;
  final String description;

  const PrivacyPolicy({
    required this.id,
    required this.header,
    required this.description,
  });

  PrivacyPolicy copyWith({String? id, String? header, String? description}) {
    return PrivacyPolicy(
      id: id ?? this.id,
      header: header ?? this.header,
      description: description ?? this.description,
    );
  }
}
