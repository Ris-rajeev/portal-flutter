import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:typed_data';
import 'package:authsec_flutter/resources/api_constants.dart';
import 'dart:convert';
import 'dart:typed_data';
class ApiService {
  final String baseUrl = ApiConstants.baseUrl;
  final Dio dio = Dio();


   Future<List<Map<String, dynamic>>> getEntities(String token) async {

    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.get('$baseUrl/Bookmarks/Bookmarks');
      final entities = (response.data as List).cast<Map<String, dynamic>>();
      return entities;
    } catch (e) {
      throw Exception('Failed to get all entities: $e');
    }
  }


 Future<void> createEntity(
      String token, Map<String, dynamic> fData, dynamic selectedFile) async {
    try {
      String apiUrl = "$baseUrl/Bookmarks/Bookmarks";

      final Uint8List fileBytes = selectedFile.bytes!;
      final mimeType = lookupMimeType(selectedFile.name!);

      FormData formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          fileBytes,
          filename: selectedFile.name!,
          contentType: MediaType.parse(mimeType!),
        ),
        'data': jsonEncode(
            fData), // Convert the map to JSON and include it as a parameter
      });

      Dio dio = Dio(); // Create a new Dio instance
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.post(apiUrl, data: formData);

      if (response.statusCode == 200) {
        // Handle successful response
        print('File uploaded successfully');
      } else {
        print('Failed to upload file with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred during form submission: $error');
    }
  }

  String lookupMimeType(String filePath) {
    final ext = filePath.split('.').last;
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'pdf':
        return 'application/pdf';
      // Add more cases for other file types as needed
      default:
        return 'application/octet-stream'; // Default MIME type
    }
  } 

  Future<void> updateEntity(String token, int entityId, Map<String, dynamic> entity) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.put('$baseUrl/Bookmarks/Bookmarks/$entityId',
          data: entity);                print(entity);

    } catch (e) {
      throw Exception('Failed to update entity: $e');
    }
  }

  Future<void> deleteEntity(String token, int entityId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.delete('$baseUrl/Bookmarks/Bookmarks/$entityId');
    } catch (e) {
      throw Exception('Failed to delete entity: $e');
    }
  }
}