class VisualAd {
  final String id;
  final String productName;
  final String imagePath;
  final bool isActive;

  const VisualAd({
    required this.id,
    required this.productName,
    required this.imagePath,
    required this.isActive,
  });

  VisualAd copyWith({
    String? id,
    String? productName,
    String? imagePath,
    bool? isActive,
  }) {
    return VisualAd(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      imagePath: imagePath ?? this.imagePath,
      isActive: isActive ?? this.isActive,
    );
  }
}
