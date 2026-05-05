import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'dart:typed_data';
import '../../models/visual_ads.dart';
import '../api_url.dart';

class VisualAdsServices {
  final Dio _dio = Dio();

  VisualAdsServices() {
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ));
  }

  Future<List<VisualAd>> getAllVisualAds(String adminId) async {
    try {
      final response = await _dio.get('${ApiUrl.getAllVisualAds}/$adminId');
      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((json) => VisualAd.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<VisualAd?> createVisualAd({
    required String adminId,
    required String productName,
    String? productQuantity,
    String? productDescription,
    String? status,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'admin_id': adminId,
        'product_name': productName,
      };
      if (productQuantity != null) data['product_quantity'] = productQuantity;
      if (productDescription != null) data['product_description'] = productDescription;
      if (status != null) data['status'] = status;

      if (imageBytes != null) {
        data['product_image'] = MultipartFile.fromBytes(
          imageBytes,
          filename: imageName ?? 'visual_ad.jpg',
        );
      }

      final formData = FormData.fromMap(data);
      final response = await _dio.post(ApiUrl.createVisualAd, data: formData);

      if (response.statusCode == 200) {
        return VisualAd.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<VisualAd?> updateVisualAd({
    required String visualAdId,
    String? productName,
    String? productQuantity,
    String? productDescription,
    String? status,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (productName != null) data['product_name'] = productName;
      if (productQuantity != null) data['product_quantity'] = productQuantity;
      if (productDescription != null) data['product_description'] = productDescription;
      if (status != null) data['status'] = status;

      if (imageBytes != null) {
        data['product_image'] = MultipartFile.fromBytes(
          imageBytes,
          filename: imageName ?? 'visual_ad_update.jpg',
        );
      }

      final formData = FormData.fromMap(data);
      final response = await _dio.put(
        '${ApiUrl.updateVisualAd}/$visualAdId',
        data: formData,
      );

      if (response.statusCode == 200) {
        return VisualAd.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteVisualAd(String visualAdId) async {
    try {
      final response = await _dio.delete('${ApiUrl.deleteVisualAd}/$visualAdId');
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }
}
