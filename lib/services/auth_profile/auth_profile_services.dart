import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'dart:typed_data';
import '../../models/admin_user.dart';
import '../api_url.dart';

class AuthProfileServices {
  final Dio _dio = Dio();

  AuthProfileServices() {
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

  Future<AdminUser?> login(String email, String password) async {
    try {
      final formData = FormData.fromMap({
        'email': email,
        'password': password,
      });

      final response = await _dio.post(
        ApiUrl.adminLogin,
        data: formData,
      );

      if (response.statusCode == 200) {
        return AdminUser.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<AdminUser?> getAdminById(String adminId) async {
    try {
      final response = await _dio.get('${ApiUrl.getAdminById}/$adminId');
      if (response.statusCode == 200) {
        return AdminUser.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<AdminUser?> updateAdminProfile({
    required String adminId,
    String? organisationName,
    String? phoneNo,
    String? alternativePhnNo,
    String? email,
    String? password,
    String? registeredAddress,
    String? gstinNo,
    String? status,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (organisationName != null) data['organisation_name'] = organisationName;
      if (phoneNo != null) data['phone_no'] = phoneNo;
      if (alternativePhnNo != null) data['alternative_phn_no'] = alternativePhnNo;
      if (email != null) data['email'] = email;
      if (password != null && password.isNotEmpty) data['password'] = password;
      if (registeredAddress != null) data['registered_address'] = registeredAddress;
      if (gstinNo != null) data['gstin_no'] = gstinNo;
      if (status != null) data['status'] = status;

      if (imageBytes != null) {
        data['profile_photo'] = MultipartFile.fromBytes(
          imageBytes,
          filename: imageName ?? 'profile.jpg',
        );
      }

      final formData = FormData.fromMap(data);

      final response = await _dio.put(
        '${ApiUrl.updateAdminById}/$adminId',
        data: formData,
      );

      if (response.statusCode == 200) {
        return AdminUser.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
