import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'dart:typed_data';
import 'dart:convert';
import '../../models/employee.dart';
import '../api_url.dart';

class EmployeeServices {
  final Dio _dio = Dio();

  EmployeeServices() {
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

  Future<List<Employee>> getEmployeesByAdmin(String adminId) async {
    try {
      final response = await _dio.get('${ApiUrl.getAllEmployees}/$adminId');
      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((json) => Employee.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<Employee?> createEmployee({
    required String fullName,
    required String phoneNo,
    required String email,
    required String password,
    required String designation,
    required String adminId,
    String? alternativePhoneNo,
    String? headquarter,
    Map<String, dynamic>? areaOfWork,
    int? monthlyTarget,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'full_name': fullName,
        'phone_no': phoneNo,
        'email': email,
        'password': password,
        'designation': designation,
        'admin_id': adminId,
      };

      if (alternativePhoneNo != null) data['alternative_phn_no'] = alternativePhoneNo;
      if (headquarter != null) data['headquarter_assigned'] = headquarter;
      if (areaOfWork != null) data['area_of_work'] = jsonEncode(areaOfWork);
      if (monthlyTarget != null) data['monthly_target_in_rupees'] = monthlyTarget;

      if (imageBytes != null) {
        data['profile_photo'] = MultipartFile.fromBytes(
          imageBytes,
          filename: imageName ?? 'employee_photo.jpg',
        );
      }

      final formData = FormData.fromMap(data);
      final response = await _dio.post(ApiUrl.createEmployee, data: formData);

      if (response.statusCode == 200) {
        return Employee.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<Employee?> updateEmployee({
    required String employeeId,
    String? fullName,
    String? phoneNo,
    String? email,
    String? password,
    String? designation,
    String? alternativePhoneNo,
    String? headquarter,
    Map<String, dynamic>? areaOfWork,
    int? monthlyTarget,
    String? status,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (fullName != null) data['full_name'] = fullName;
      if (phoneNo != null) data['phone_no'] = phoneNo;
      if (email != null) data['email'] = email;
      if (password != null) data['password'] = password;
      if (designation != null) data['designation'] = designation;
      if (alternativePhoneNo != null) data['alternative_phn_no'] = alternativePhoneNo;
      if (headquarter != null) data['headquarter_assigned'] = headquarter;
      if (areaOfWork != null) data['area_of_work'] = jsonEncode(areaOfWork);
      if (monthlyTarget != null) data['monthly_target_in_rupees'] = monthlyTarget;
      if (status != null) data['status'] = status;

      if (imageBytes != null) {
        data['profile_photo'] = MultipartFile.fromBytes(
          imageBytes,
          filename: imageName ?? 'employee_update.jpg',
        );
      }

      final formData = FormData.fromMap(data);
      final response = await _dio.put(
        '${ApiUrl.updateEmployee}/$employeeId',
        data: formData,
      );

      if (response.statusCode == 200) {
        return Employee.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteEmployee(String employeeId) async {
    try {
      final response = await _dio.delete('${ApiUrl.deleteEmployee}/$employeeId');
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }

  Future<Employee?> getEmployeeById(String employeeId) async {
    try {
      final response = await _dio.get('${ApiUrl.getEmployeeById}/$employeeId');
      if (response.statusCode == 200) {
        return Employee.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
