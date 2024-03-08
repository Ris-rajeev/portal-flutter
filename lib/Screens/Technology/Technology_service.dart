import 'package:dio/dio.dart';
import 'package:authsec_flutter/resources/api_constants.dart';

class TechnologyApiService {
  final String baseUrl = ApiConstants.baseUrl;
  final Dio dio = Dio();

  Future<List<Map<String, dynamic>>> get_technology(String token) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.get('$baseUrl/fnd/project/myproject');
      final entities = (response.data as List).cast<Map<String, dynamic>>();
      return entities;
    } catch (e) {
      throw Exception('Failed to get all projects: $e');
    }
  }

  Future<void> create_technology(
      String token, Map<String, dynamic> entity) async {
    try {
      print("in post api...$entity");
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.post('$baseUrl/api/project-setup', data: entity);
      print(entity);
    } catch (e) {
      throw Exception('Failed to create projects: $e');
    }
  }

  Future<void> update_technology(
      String token, int entityId, Map<String, dynamic> entity) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.put('$baseUrl/api/project-setup/$entityId', data: entity);
      print(entity);
    } catch (e) {
      throw Exception('Failed to update projects: $e');
    }
  }

  Future<void> delete_technology(String token, int entityId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.delete('$baseUrl/api/project-setup/$entityId');
    } catch (e) {
      throw Exception('Failed to delete projects: $e');
    }
  }

  Future<List<Map<String, dynamic>>> get_techbytype(
      String token, String service_type) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio
          .get('$baseUrl/token/flf/tech_stack/get_byservicetype/$service_type');

      final responseData = response.data;
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
      throw Exception('Failed to get data: $e');
    }
  }
}
