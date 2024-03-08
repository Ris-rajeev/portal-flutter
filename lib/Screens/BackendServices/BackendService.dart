import 'package:dio/dio.dart';
import 'package:authsec_flutter/resources/api_constants.dart';

class backendApiService {
  final String baseUrl = ApiConstants.baseUrl;
  final Dio dio = Dio();

  Future<List<Map<String, dynamic>>> getBackendByprojectId(
      String token, int projectId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
          await dio.get('$baseUrl/BackendConfig/by_project/$projectId');

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
      throw Exception('Failed to get Backend by projectId: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getBackendByModuleId(
      String token, int ModuleId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
          await dio.get('$baseUrl/BackendConfig/moduleid/$ModuleId');

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
      throw Exception('Failed to get Backend by ModuleId: $e');
    }
  }

  Future<void> createBackend(String token, Map<String, dynamic> entity) async {
    try {
      print("in post api...$entity");
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.post('$baseUrl/BackendConfig/BackendConfig', data: entity);
      print(entity);
    } catch (e) {
      throw Exception('Failed to create Backend: $e');
    }
  }

  Future<void> updateBackend(
      String token, int entityId, Map<String, dynamic> entity) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.put('$baseUrl/BackendConfig/BackendConfig/$entityId',
          data: entity);
      print(entity);
    } catch (e) {
      throw Exception('Failed to update Backend: $e');
    }
  }

  Future<void> delete_Backend(String token, int entityId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.delete('$baseUrl/BackendConfig/BackendConfig/$entityId');
    } catch (e) {
      throw Exception('Failed to delete Backend: $e');
    }
  }

  Future<Map<String, dynamic>> getBackendById(String token, int Id) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
          await dio.get('$baseUrl/BackendConfig/BackendConfig/$Id');

      final responseData = response.data;

      print('response data is ... $responseData');

      if (responseData is Map<String, dynamic>) {
        // If the response is a single object, wrap it in a list
        return responseData;
      } else {
        // Handle other unexpected response types here
        throw Exception('Unexpected response type');
      }
    } catch (e) {
      throw Exception('Failed to get Backend by projectId: $e');
    }
  }
}
