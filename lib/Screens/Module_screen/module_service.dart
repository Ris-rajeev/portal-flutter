import 'package:dio/dio.dart';
import 'package:authsec_flutter/resources/api_constants.dart';

class ModuleApiService {
  final String baseUrl = ApiConstants.baseUrl;
  final Dio dio = Dio();

  Future<List<Map<String, dynamic>>> getModulesByEntityId(
      String token, int projectId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
          await dio.get('$baseUrl/api/module-setup?projectId=$projectId');

      final responseData = response.data['items'];
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

// get all module by project Id that tech stack is flutter
  Future<List<Map<String, dynamic>>> getOnlyFlutterServicesByProjectId(
      String token, int projectId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
          await dio.get('$baseUrl/fnd/project2/module/flutter/$projectId');

      final responseData = response.data;
      print(' response is $responseData');
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

  Future<void> createmodule(String token, Map<String, dynamic> entity) async {
    try {
      print("in post api...$entity");
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.post('$baseUrl/api/module-setup', data: entity);
      print(entity);
    } catch (e) {
      throw Exception('Failed to create projects: $e');
    }
  }

  Future<Response> moduleaddtolibrary(String token, int moduleid) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      return await dio
          .get('$baseUrl/library/modulelibrary/copyfromrn_module/$moduleid');
    } catch (e) {
      throw Exception('Failed to create projects: $e');
    }
  }

  Future<void> updatemodule(
      String token, int entityId, Map<String, dynamic> entity) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.put('$baseUrl/api/module-setup/$entityId', data: entity);
      print(entity);
    } catch (e) {
      throw Exception('Failed to update Module: $e');
    }
  }

  Future<void> deletemodule(String token, int entityId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.delete('$baseUrl/api/module-setup/$entityId');
    } catch (e) {
      throw Exception('Failed to delete projects: $e');
    }
  }

  Future<Map<String, dynamic>> getModuleById(String token, int Id) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.get('$baseUrl/api/module-setup/$Id');

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

  Future<Map<String, List<String>>> getAllConfigByModuleId(
      String token, int ModuleId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
          await dio.get('$baseUrl/fnd/project/getallconfig/$ModuleId');

      final responseData = response.data;

      if (responseData is Map<String, dynamic>) {
        final Map<String, List<String>> configData = {
          'dbconfig': (responseData['dbconfig'] as List).cast<String>(),
          'backend': (responseData['backend'] as List).cast<String>(),
        };
        print('response is $configData');
        return configData;
      } else {
        throw Exception('Unexpected response type');
      }
    } catch (e) {
      throw Exception('Failed to get All Configs by ModuleId: $e');
    }
  }
}
