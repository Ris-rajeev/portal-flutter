import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:authsec_flutter/resources/api_constants.dart';
import 'package:http_parser/http_parser.dart';


class SystemParameterApiService {
  final String baseUrl = ApiConstants.baseUrl;
  final Dio dio = Dio();

  Future<Map<String, dynamic>> getsystemparameters(String token,int id) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.get('$baseUrl/sysparam/getSysParams/$id');
      final entities = (response.data);
      return entities;
    } catch (e) {
      throw Exception('Failed to get all projects: $e');
    }
  }

  Future<void> updateParameter(
      String token, int entityId, Map<String, dynamic> entity) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.put('$baseUrl/sysparam/updateSysParams/$entityId', data: entity);
      print(entity);
    } catch (e) {
      throw Exception('Failed to update projects: $e');
    }
  }

  Future<Map<String, dynamic>> createFile(
      Uint8List fileBytes, String fileName, String token) async {
    try {
      String apiUrl = "$baseUrl/api/logos/upload?ref=test";

      final mimeType = 'image/jpeg'; // You can set the appropriate MIME type

      FormData formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
      });

      Dio dio = Dio(); // Create a new Dio instance
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.post(apiUrl, data: formData);

      if (response.statusCode == 200) {
        print('File uploaded successfully');
        return response.data; // Return the response data on success
      } else {
        print('Failed to upload file with status: ${response.statusCode}');
        // You might want to handle this error case more explicitly
        throw Exception('Failed to upload file');
      }
    } catch (error) {
      print('Error occurred during form submission: $error');
      // You might want to handle this error case more explicitly
      throw Exception('Error during file upload: $error');
    }
  }
}
