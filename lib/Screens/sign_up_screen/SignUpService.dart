import 'package:dio/dio.dart';
import 'package:authsec_flutter/resources/api_constants.dart';

class SignUpApiService {
  final String baseUrl = ApiConstants.baseUrl;
  final Dio dio = Dio();

// get all account
  Future<List<Map<String, dynamic>>> getallAccount(String token) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.get('$baseUrl/users/sysaccount/sysaccount');

      final responseData = response.data;

      print('response data is ... $responseData');

      if (responseData is List) {
        // If the response is a list, cast it to the expected type
        final entities = responseData.cast<Map<String, dynamic>>();
        return entities;
      } else if (responseData is Map<String, dynamic>) {
        // If the response is a single object, wrap it in a list
        return [responseData];
      } else {
        // Handle other unexpected response types here
        throw Exception('Unexpected response type');
      }
    } catch (e) {
      throw Exception('Failed to Account: $e');
    }
  }

// Create account
  Future<Map<String, dynamic>> createAccount(
      Map<String, dynamic> entity) async {
    try {
      // dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio
          .post('$baseUrl/token/users/sysaccount/savesysaccount', data: entity);

      print(' created account is $response');
      return response.data;
    } catch (e) {
      throw Exception('Failed To Create Account: $e');
    }
  }

// SEND EMAIL FOR OTP
  Future<void> sendEmail(Map<String, dynamic> entity) async {
    try {
      print("in post api...$entity");
      // dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.post('$baseUrl/token/user/send_email', data: entity);
      print(entity);
    } catch (e) {
      throw Exception('Failed to Send Email: $e');
    }
  }

  // RESEND EMAIL FOR OTP
  Future<void> resendEmail(String email) async {
    try {
      // dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.post('$baseUrl/token/user/resend_otp?email=$email');
    } catch (e) {
      throw Exception('Failed to ReSend Email: $e');
    }
  }

  // OTP VEFICATION
  Future<void> otpverification(String email, String otp) async {
    try {
      // dio.options.headers['Authorization'] = 'Bearer $token';
      await dio
          .post('$baseUrl/token/user/otp_verification?email=$email&otp=$otp');
    } catch (e) {
      throw Exception('Failed to Verify Otp: $e');
    }
  }

  Future<void> createuser(String token, Map<String, dynamic> entity) async {
    try {
      print("in post api...$entity");
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.post('$baseUrl/token/addOneAppUser', data: entity);
      print(entity);
    } catch (e) {
      throw Exception('Failed to create User: $e');
    }
  }

  Future<void> updateUser(
      String token, int entityId, Map<String, dynamic> entity) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.put('$baseUrl/api/updateAppUserDto/$entityId', data: entity);
      print(entity);
    } catch (e) {
      throw Exception('Failed to update Backend: $e');
    }
  }

  Future<void> deleteUser(String token, int entityId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.delete('$baseUrl/api/delete_usr/$entityId');
    } catch (e) {
      throw Exception('Failed to delete User: $e');
    }
  }
}
