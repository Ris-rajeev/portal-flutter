import 'package:dio/dio.dart';
import 'package:authsec_flutter/resources/api_constants.dart';

class DbApiService {
  final String baseUrl = ApiConstants.baseUrl;
  final Dio dio = Dio();

  Future<List<Map<String, dynamic>>> getDbByprojectId(
      String token, int projectId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.get('$baseUrl/Dbconfig/by_proj_id/$projectId');

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
      throw Exception('Failed to get modules by projectId: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getDbByModuleId(
      String token, int ModuleId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.get('$baseUrl/Dbconfig/bymoduleid/$ModuleId');

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
      throw Exception('Failed to get modules by projectId: $e');
    }
  }

  Future<void> create_db(String token, Map<String, dynamic> entity) async {
    try {
      print("in post api...$entity");
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.post('$baseUrl/Dbconfig/Dbconfig', data: entity);
      print(entity);
    } catch (e) {
      throw Exception('Failed to create Database: $e');
    }
  }

  Future<void> update_db(
      String token, int entityId, Map<String, dynamic> entity) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.put('$baseUrl/Dbconfig/Dbconfig/$entityId', data: entity);
      print(entity);
    } catch (e) {
      throw Exception('Failed to update Database: $e');
    }
  }

  Future<void> delete_db(String token, int entityId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.delete('$baseUrl/Dbconfig/Dbconfig/$entityId');
    } catch (e) {
      throw Exception('Failed to delete Database: $e');
    }
  }
}
