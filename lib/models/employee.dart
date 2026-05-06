import '../services/api_url.dart';

class Employee {
  final String id;
  final String adminId;
  final String fullName;
  final String phoneNo;
  final String? alternativePhoneNo;
  final String email;
  final String headquarter;
  final Map<String, dynamic>? areaOfWork;
  final String designation;
  final int? monthlyTarget;
  final String? profilePhotoPath;
  final String status;
  final String? createdAt;
  final String? updatedAt;

  const Employee({
    required this.id,
    required this.adminId,
    required this.fullName,
    required this.phoneNo,
    this.alternativePhoneNo,
    required this.email,
    required this.headquarter,
    this.areaOfWork,
    required this.designation,
    this.monthlyTarget,
    this.profilePhotoPath,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    String? photoUrl = json['profile_photo'];
    if (photoUrl != null && !photoUrl.startsWith('http')) {
      photoUrl = '${ApiUrl.baseUrl}/$photoUrl';
    }

    return Employee(
      id: json['employee_id'] ?? '',
      adminId: json['admin_id'] ?? '',
      fullName: json['full_name'] ?? '',
      phoneNo: json['phone_no'] ?? '',
      alternativePhoneNo: json['alternative_phn_no'],
      email: json['email'] ?? '',
      headquarter: json['headquarter_assigned'] ?? '',
      areaOfWork: json['area_of_work'],
      designation: json['designation'] ?? '',
      monthlyTarget: json['monthly_target_in_rupees'],
      profilePhotoPath: photoUrl,
      status: json['status'] ?? 'active',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Employee copyWith({
    String? id,
    String? adminId,
    String? fullName,
    String? phoneNo,
    String? alternativePhoneNo,
    String? email,
    String? headquarter,
    Map<String, dynamic>? areaOfWork,
    String? designation,
    int? monthlyTarget,
    String? profilePhotoPath,
    String? status,
    String? createdAt,
    String? updatedAt,
  }) {
    return Employee(
      id: id ?? this.id,
      adminId: adminId ?? this.adminId,
      fullName: fullName ?? this.fullName,
      phoneNo: phoneNo ?? this.phoneNo,
      alternativePhoneNo: alternativePhoneNo ?? this.alternativePhoneNo,
      email: email ?? this.email,
      headquarter: headquarter ?? this.headquarter,
      areaOfWork: areaOfWork ?? this.areaOfWork,
      designation: designation ?? this.designation,
      monthlyTarget: monthlyTarget ?? this.monthlyTarget,
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
