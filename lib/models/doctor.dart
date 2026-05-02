class DoctorChamber {
  final String name;
  final String phoneNo;
  final String address;

  const DoctorChamber({
    required this.name,
    required this.phoneNo,
    required this.address,
  });
}

class Doctor {
  final String id;
  final String name;
  final String profilePhotoPath;
  final String specialization;
  final String phoneNo;
  final String email;
  final String address;
  final String employeeId; // Employee who added this doctor
  final String education;
  final String experience;
  final String description;
  final List<DoctorChamber> chambers;

  const Doctor({
    required this.id,
    required this.name,
    required this.profilePhotoPath,
    required this.specialization,
    required this.phoneNo,
    required this.email,
    required this.address,
    required this.employeeId,
    required this.education,
    required this.experience,
    required this.description,
    required this.chambers,
  });
}
