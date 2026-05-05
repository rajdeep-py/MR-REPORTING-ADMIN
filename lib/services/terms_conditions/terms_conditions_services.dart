import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../models/terms_conditions.dart';
import '../api_url.dart';

class TermsConditionsServices {
  final Dio _dio = Dio();

  TermsConditionsServices() {
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

  Future<List<TermsCondition>> getAllTermsConditions() async {
    try {
      final response = await _dio.get(ApiUrl.getAllTermsConditions);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => TermsCondition.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<TermsCondition?> getTermsConditionsById(String id) async {
    try {
      final response = await _dio.get('${ApiUrl.getTermsConditionsById}/$id');
      if (response.statusCode == 200) {
        return TermsCondition.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
