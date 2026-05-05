import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../models/privacy_policy.dart';
import '../api_url.dart';

class PrivacyPolicyServices {
  final Dio _dio = Dio();

  PrivacyPolicyServices() {
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  Future<List<PrivacyPolicy>> getAllPrivacyPolicies() async {
    try {
      final response = await _dio.get(ApiUrl.getAllPrivacyPolicies);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => PrivacyPolicy.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<PrivacyPolicy?> getPrivacyPolicyById(String id) async {
    try {
      final response = await _dio.get('${ApiUrl.getPrivacyPolicyById}/$id');
      if (response.statusCode == 200) {
        return PrivacyPolicy.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
