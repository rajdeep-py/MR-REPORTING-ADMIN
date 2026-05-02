class ChemistShop {
  final String id;
  final String name;
  final String photoPath;
  final String address;
  final String location;
  final String phoneNo;
  final String email;
  final String description;
  final String employeeId;
  final List<String> interestedProductIds;

  const ChemistShop({
    required this.id,
    required this.name,
    required this.photoPath,
    required this.address,
    required this.location,
    required this.phoneNo,
    required this.email,
    required this.description,
    required this.employeeId,
    required this.interestedProductIds,
  });

  ChemistShop copyWith({
    String? id,
    String? name,
    String? photoPath,
    String? address,
    String? location,
    String? phoneNo,
    String? email,
    String? description,
    String? employeeId,
    List<String>? interestedProductIds,
  }) {
    return ChemistShop(
      id: id ?? this.id,
      name: name ?? this.name,
      photoPath: photoPath ?? this.photoPath,
      address: address ?? this.address,
      location: location ?? this.location,
      phoneNo: phoneNo ?? this.phoneNo,
      email: email ?? this.email,
      description: description ?? this.description,
      employeeId: employeeId ?? this.employeeId,
      interestedProductIds: interestedProductIds ?? this.interestedProductIds,
    );
  }
}
