class AdminUser {
  final String adminId;
  final String organisationName;
  final String phoneNo;
  final String? alternativePhnNo;
  final String email;
  final String? registeredAddress;
  final String? profilePhoto;
  final String cinNo;
  final String? gstinNo;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AdminUser({
    required this.adminId,
    required this.organisationName,
    required this.phoneNo,
    this.alternativePhnNo,
    required this.email,
    this.registeredAddress,
    this.profilePhoto,
    required this.cinNo,
    this.gstinNo,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      adminId: json['admin_id'] ?? '',
      organisationName: json['organisation_name'] ?? '',
      phoneNo: json['phone_no'] ?? '',
      alternativePhnNo: json['alternative_phn_no'],
      email: json['email'] ?? '',
      registeredAddress: json['registered_address'],
      profilePhoto: json['profile_photo'],
      cinNo: json['cin_no'] ?? '',
      gstinNo: json['gstin_no'],
      status: json['status'] ?? 'active',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  AdminUser copyWith({
    String? adminId,
    String? organisationName,
    String? phoneNo,
    String? alternativePhnNo,
    String? email,
    String? registeredAddress,
    String? profilePhoto,
    String? cinNo,
    String? gstinNo,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AdminUser(
      adminId: adminId ?? this.adminId,
      organisationName: organisationName ?? this.organisationName,
      phoneNo: phoneNo ?? this.phoneNo,
      alternativePhnNo: alternativePhnNo ?? this.alternativePhnNo,
      email: email ?? this.email,
      registeredAddress: registeredAddress ?? this.registeredAddress,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      cinNo: cinNo ?? this.cinNo,
      gstinNo: gstinNo ?? this.gstinNo,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
