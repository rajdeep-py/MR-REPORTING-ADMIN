class Stockist {
  final String id;
  final String name;
  final String photoPath;
  final String address;
  final String location;
  final String phoneNo;
  final String email;
  final String description;
  final String expectedDeliveryTime;
  final double minimumOrderValue;
  final String employeeId;
  final List<String> interestedProductIds;

  const Stockist({
    required this.id,
    required this.name,
    required this.photoPath,
    required this.address,
    required this.location,
    required this.phoneNo,
    required this.email,
    required this.description,
    required this.expectedDeliveryTime,
    required this.minimumOrderValue,
    required this.employeeId,
    required this.interestedProductIds,
  });

  Stockist copyWith({
    String? id,
    String? name,
    String? photoPath,
    String? address,
    String? location,
    String? phoneNo,
    String? email,
    String? description,
    String? expectedDeliveryTime,
    double? minimumOrderValue,
    String? employeeId,
    List<String>? interestedProductIds,
  }) {
    return Stockist(
      id: id ?? this.id,
      name: name ?? this.name,
      photoPath: photoPath ?? this.photoPath,
      address: address ?? this.address,
      location: location ?? this.location,
      phoneNo: phoneNo ?? this.phoneNo,
      email: email ?? this.email,
      description: description ?? this.description,
      expectedDeliveryTime: expectedDeliveryTime ?? this.expectedDeliveryTime,
      minimumOrderValue: minimumOrderValue ?? this.minimumOrderValue,
      employeeId: employeeId ?? this.employeeId,
      interestedProductIds: interestedProductIds ?? this.interestedProductIds,
    );
  }
}
