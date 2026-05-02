class HelpCenter {
  final String phoneNo;
  final String email;
  final String address;
  final String mapUrl;
  final String officeHours;

  const HelpCenter({
    required this.phoneNo,
    required this.email,
    required this.address,
    required this.mapUrl,
    required this.officeHours,
  });

  HelpCenter copyWith({
    String? phoneNo,
    String? email,
    String? address,
    String? mapUrl,
    String? officeHours,
  }) {
    return HelpCenter(
      phoneNo: phoneNo ?? this.phoneNo,
      email: email ?? this.email,
      address: address ?? this.address,
      mapUrl: mapUrl ?? this.mapUrl,
      officeHours: officeHours ?? this.officeHours,
    );
  }
}
