class AboutUs {
  final String companyName;
  final String tagline;
  final String description;
  final String mission;
  final String vision;
  final String directorMessage;
  final String directorName;
  final String? directorPhotoPath;
  final String email;
  final String address;
  final String website;
  final String phoneNo;

  const AboutUs({
    required this.companyName,
    required this.tagline,
    required this.description,
    required this.mission,
    required this.vision,
    required this.directorMessage,
    required this.directorName,
    this.directorPhotoPath,
    required this.email,
    required this.address,
    required this.website,
    required this.phoneNo,
  });

  AboutUs copyWith({
    String? companyName,
    String? tagline,
    String? description,
    String? mission,
    String? vision,
    String? directorMessage,
    String? directorName,
    String? directorPhotoPath,
    String? email,
    String? address,
    String? website,
    String? phoneNo,
  }) {
    return AboutUs(
      companyName: companyName ?? this.companyName,
      tagline: tagline ?? this.tagline,
      description: description ?? this.description,
      mission: mission ?? this.mission,
      vision: vision ?? this.vision,
      directorMessage: directorMessage ?? this.directorMessage,
      directorName: directorName ?? this.directorName,
      directorPhotoPath: directorPhotoPath ?? this.directorPhotoPath,
      email: email ?? this.email,
      address: address ?? this.address,
      website: website ?? this.website,
      phoneNo: phoneNo ?? this.phoneNo,
    );
  }
}
