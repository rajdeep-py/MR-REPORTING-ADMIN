class AdminUser {
  final String id;
  final String email;
  final String name;
  final String? companyId;
  final String? companyName;
  final String? cinNo;
  final String? gstin;
  final String? address;
  final String? phoneNo;
  final String? alternativePhoneNo;

  AdminUser({
    required this.id,
    required this.email,
    required this.name,
    this.companyId,
    this.companyName,
    this.cinNo,
    this.gstin,
    this.address,
    this.phoneNo,
    this.alternativePhoneNo,
  });

  AdminUser copyWith({
    String? id,
    String? email,
    String? name,
    String? companyId,
    String? companyName,
    String? cinNo,
    String? gstin,
    String? address,
    String? phoneNo,
    String? alternativePhoneNo,
  }) {
    return AdminUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      cinNo: cinNo ?? this.cinNo,
      gstin: gstin ?? this.gstin,
      address: address ?? this.address,
      phoneNo: phoneNo ?? this.phoneNo,
      alternativePhoneNo: alternativePhoneNo ?? this.alternativePhoneNo,
    );
  }
}
