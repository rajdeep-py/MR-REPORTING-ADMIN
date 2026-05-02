class TermsCondition {
  final String id;
  final String header;
  final String description;

  const TermsCondition({
    required this.id,
    required this.header,
    required this.description,
  });

  TermsCondition copyWith({String? id, String? header, String? description}) {
    return TermsCondition(
      id: id ?? this.id,
      header: header ?? this.header,
      description: description ?? this.description,
    );
  }
}
