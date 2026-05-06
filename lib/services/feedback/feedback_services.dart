import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../models/feedback.dart';
import '../api_url.dart';

class FeedbackServices {
  final Dio _dio = Dio();

  FeedbackServices() {
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

  Future<List<FeedbackItem>> getFeedbackByAdmin(String adminId) async {
    try {
      final response = await _dio.get('${ApiUrl.getAllFeedback}/$adminId');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((e) => FeedbackItem.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<FeedbackItem> createFeedback(Map<String, dynamic> feedbackData) async {
    try {
      final response = await _dio.post(ApiUrl.createFeedback, data: feedbackData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return FeedbackItem.fromJson(response.data);
      }
      throw Exception('Failed to create feedback');
    } catch (e) {
      rethrow;
    }
  }

  Future<FeedbackItem> updateFeedback(String feedbackId, Map<String, dynamic> feedbackData) async {
    try {
      final response = await _dio.put('${ApiUrl.updateFeedback}/$feedbackId', data: feedbackData);
      if (response.statusCode == 200) {
        return FeedbackItem.fromJson(response.data);
      }
      throw Exception('Failed to update feedback');
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteFeedback(String feedbackId) async {
    try {
      final response = await _dio.delete('${ApiUrl.deleteFeedback}/$feedbackId');
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }
}
