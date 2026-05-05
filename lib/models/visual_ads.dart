import '../services/api_url.dart';

class VisualAd {
  final String visualAdId;
  final String adminId;
  final String productName;
  final String? productQuantity;
  final String? productDescription;
  final String? productImage;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  VisualAd({
    required this.visualAdId,
    required this.adminId,
    required this.productName,
    this.productQuantity,
    this.productDescription,
    this.productImage,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory VisualAd.fromJson(Map<String, dynamic> json) {
    String? imageUrl = json['product_image'];
    if (imageUrl != null && !imageUrl.startsWith('http')) {
      imageUrl = '${ApiUrl.baseUrl}/$imageUrl';
    }

    return VisualAd(
      visualAdId: json['visual_ad_id'] ?? '',
      adminId: json['admin_id'] ?? '',
      productName: json['product_name'] ?? '',
      productQuantity: json['product_quantity'],
      productDescription: json['product_description'],
      productImage: imageUrl,
      status: json['status'] ?? 'active',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  VisualAd copyWith({
    String? visualAdId,
    String? adminId,
    String? productName,
    String? productQuantity,
    String? productDescription,
    String? productImage,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VisualAd(
      visualAdId: visualAdId ?? this.visualAdId,
      adminId: adminId ?? this.adminId,
      productName: productName ?? this.productName,
      productQuantity: productQuantity ?? this.productQuantity,
      productDescription: productDescription ?? this.productDescription,
      productImage: productImage ?? this.productImage,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
