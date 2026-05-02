class Employee {
  final String id;
  final String fullName;
  final String phoneNo;
  final String? alternativePhoneNo;
  final String email;
  final String headquarter;
  final List<String> areasOfWork;
  final double monthlyTarget;
  final String password;
  final String? profilePhotoPath;

  const Employee({
    required this.id,
    required this.fullName,
    required this.phoneNo,
    this.alternativePhoneNo,
    required this.email,
    required this.headquarter,
    required this.areasOfWork,
    required this.monthlyTarget,
    required this.password,
    this.profilePhotoPath,
  });

  Employee copyWith({
    String? id,
    String? fullName,
    String? phoneNo,
    String? alternativePhoneNo,
    String? email,
    String? headquarter,
    List<String>? areasOfWork,
    double? monthlyTarget,
    String? password,
    String? profilePhotoPath,
  }) {
    return Employee(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNo: phoneNo ?? this.phoneNo,
      alternativePhoneNo: alternativePhoneNo ?? this.alternativePhoneNo,
      email: email ?? this.email,
      headquarter: headquarter ?? this.headquarter,
      areasOfWork: areasOfWork ?? this.areasOfWork,
      monthlyTarget: monthlyTarget ?? this.monthlyTarget,
      password: password ?? this.password,
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
    );
  }
}
