import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../models/announcement.dart';
import '../api_url.dart';

class AnnouncementServices {
  final Dio _dio = Dio();

  AnnouncementServices() {
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

  Future<List<Announcement>> getAnnouncementsByAdmin(String adminId) async {
    try {
      final response = await _dio.get('${ApiUrl.getAllAnnouncements}/$adminId');
      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((json) => Announcement.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<Announcement?> createAnnouncement({
    required String adminId,
    required String title,
    required String description,
    String status = "active",
  }) async {
    try {
      final response = await _dio.post(
        ApiUrl.createAnnouncement,
        data: {
          'admin_id': adminId,
          'announcement_header': title,
          'announcement_description': description,
          'status': status,
        },
      );

      if (response.statusCode == 200) {
        return Announcement.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<Announcement?> updateAnnouncement({
    required String announcementId,
    String? title,
    String? description,
    String? status,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (title != null) data['announcement_header'] = title;
      if (description != null) data['announcement_description'] = description;
      if (status != null) data['status'] = status;

      final response = await _dio.put(
        '${ApiUrl.updateAnnouncement}/$announcementId',
        data: data,
      );

      if (response.statusCode == 200) {
        return Announcement.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteAnnouncement(String announcementId) async {
    try {
      final response = await _dio.delete('${ApiUrl.deleteAnnouncement}/$announcementId');
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }
}
