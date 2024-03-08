import 'package:dio/dio.dart';
import 'package:authsec_flutter/Entity/imagemodel/Product.dart';
import 'package:authsec_flutter/resources/api_constants.dart';

class ApiService {
  final String baseUrl = ApiConstants.baseUrl;
  final Dio dio = Dio();

  // Future<String> loginUser(String email, String password) async {
  //   try {
  //     final response = await dio.post('$baseUrl/token/session',
  //         data: {'email': email, 'password': password});
  //     var tok = response.data['item']['token'].toString();
  //     print(tok);

  //     final token = tok;
  //     return token;
  //   } catch (e) {
  //     throw Exception('Failed to login: $e');
  //   }
  // }

  Future<List<Product>> getEntities(String token) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.get('$baseUrl/Gaurav_testing/Gaurav_testing');
      final entities = (response.data as List)
          .map((json) => Product.fromJson(json))
          .toList();
      return entities;
    } catch (e) {
      throw Exception('Failed to get all entities: $e');
    }
  }

  Future<void> createEntity(String token, Product entity) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.post('$baseUrl/Gaurav_testing/Gaurav_testing',
          data: entity.toJson());
      print(entity.toJson());
    } catch (e) {
      throw Exception('Failed to create entity: $e');
    }
  }

  Future<void> updateEntity(String token, int entityId, Product entity) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.put('$baseUrl/Gaurav_testing/Gaurav_testing/$entityId',
          data: entity.toJson());
    } catch (e) {
      throw Exception('Failed to update entity: $e');
    }
  }

  Future<void> deleteEntity(String token, int entityId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.delete('$baseUrl/Gaurav_testing/Gaurav_testing/$entityId');
    } catch (e) {
      throw Exception('Failed to delete entity: $e');
    }
  }
}
