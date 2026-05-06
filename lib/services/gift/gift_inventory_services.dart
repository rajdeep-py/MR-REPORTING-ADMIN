import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../models/gift.dart';
import '../api_url.dart';

class GiftInventoryServices {
  final Dio _dio = Dio();

  GiftInventoryServices() {
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

  Future<List<GiftItem>> getGiftsByAdmin(String adminId) async {
    try {
      final response = await _dio.get('${ApiUrl.getAllGifts}/$adminId');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((e) => GiftItem.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<GiftItem> createGift(Map<String, dynamic> giftData) async {
    try {
      final response = await _dio.post(ApiUrl.createGift, data: giftData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return GiftItem.fromJson(response.data);
      }
      throw Exception('Failed to create gift');
    } catch (e) {
      rethrow;
    }
  }

  Future<GiftItem> updateGift(String giftId, Map<String, dynamic> giftData) async {
    try {
      final response = await _dio.put('${ApiUrl.updateGift}/$giftId', data: giftData);
      if (response.statusCode == 200) {
        return GiftItem.fromJson(response.data);
      }
      throw Exception('Failed to update gift');
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteGift(String giftId) async {
    try {
      final response = await _dio.delete('${ApiUrl.deleteGift}/$giftId');
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }
}
