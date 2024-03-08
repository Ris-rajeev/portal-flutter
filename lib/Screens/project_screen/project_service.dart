import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:authsec_flutter/resources/api_constants.dart';
import 'package:http_parser/http_parser.dart';

class ProjectApiService {
  final String baseUrl = ApiConstants.baseUrl;
  final Dio dio = Dio();

  Future<List<Map<String, dynamic>>> getproject(String token) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.get('$baseUrl/fnd/project/myproject');
      final entities = (response.data as List).cast<Map<String, dynamic>>();
      return entities;
    } catch (e) {
      throw Exception('Failed to get my projects: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getsharedproject(String token) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.get('$baseUrl/fnd/project/sharewithme');
      final entities = (response.data as List).cast<Map<String, dynamic>>();
      return entities;
    } catch (e) {
      throw Exception('Failed to get shared projects: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getallproject(String token) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.get('$baseUrl/fnd/project/allproject');
      final entities = (response.data as List).cast<Map<String, dynamic>>();
      return entities;
    } catch (e) {
      throw Exception('Failed to get all projects: $e');
    }
  }

  Future<void> createProject(String token, Map<String, dynamic> entity) async {
    try {
      print("in post api...$entity");
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.post('$baseUrl/api/project-setup', data: entity);
    } catch (e) {
      throw Exception('Failed to create projects: $e');
    }
  }

  Future<void> updateProject(
      String token, int entityId, Map<String, dynamic> entity) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.put('$baseUrl/api/project-setup/$entityId', data: entity);
      print(entity);
    } catch (e) {
      throw Exception('Failed to update projects: $e');
    }
  }

  Future<void> deleteProject(String token, int entityId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.delete('$baseUrl/api/project-setup/$entityId');
    } catch (e) {
      throw Exception('Failed to delete projects: $e');
    }
  }

  Future<Response> addProjectToLibrary(String token, int entityId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      Response respones =
          await dio.get('$baseUrl/projectlibrary/copyfromrn_project/$entityId');
      return respones;
    } catch (e) {
      throw Exception('Failed to : $e');
    }
  }

  Future<Response> removeAwesome(String token, int entityId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      print('$baseUrl/api/removeStarById/$entityId');
      Response respones =
          await dio.delete('$baseUrl/api/removeStarById/$entityId');
      return respones;
    } catch (e) {
      throw Exception('Failed to : $e');
    }
  }

  Future<Response> addAwesome(String token, dynamic project) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      dio.options.headers['Content-Type'] = 'application/json';
      Map<String, dynamic> requestData = {
        "objectId": project['id'],
      };

      // Make the POST request
      Response response =
          await dio.post('$baseUrl/api/addStarById', data: requestData);

      return response;
    } catch (e) {
      throw Exception('Failed to : $e');
    }
  }

  Future<Response> removeWatchlist(String token, int entityId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      Response respones =
          await dio.delete('$baseUrl/api/removeWatchlistById/$entityId');
      return respones;
    } catch (e) {
      throw Exception('Failed to : $e');
    }
  }

  Future<Response> addWatchlist(String token, dynamic project) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      dio.options.headers['Content-Type'] = 'application/json';
      Map<String, dynamic> requestData = {
        "objectId": project['id'],
      };

      // Make the POST request
      Response response =
          await dio.post('$baseUrl/api/addWatchlistById', data: requestData);

      return response;
    } catch (e) {
      throw Exception('Failed to : $e');
    }
  }

  Future<Response> removeFavourite(String token, int entityId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      Response respones =
          await dio.delete('$baseUrl/api/removeFavById/$entityId');
      return respones;
    } catch (e) {
      throw Exception('Failed to : $e');
    }
  }

  Future<Response> addFavourite(String token, dynamic project) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      dio.options.headers['Content-Type'] = 'application/json';
      Map<String, dynamic> requestData = {
        "objectId": project['id'],
      };

      // Make the POST request
      Response response =
          await dio.post('$baseUrl/api/addFavById', data: requestData);

      return response;
    } catch (e) {
      throw Exception('Failed to : $e');
    }
  }

//  get all deployment profile2
  Future<List<Map<String, dynamic>>> getDeploymentProfile(String token) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
          await dio.get('$baseUrl/Deployment_profile/Deployment_profile');
      final entities = (response.data as List).cast<Map<String, dynamic>>();
      return entities;
    } catch (e) {
      throw Exception('Failed to get all projects: $e');
    }
  }

  //  get all deployment profile line
  Future<List<Map<String, dynamic>>> getDeploymentProfileLines(
      String token) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
          await dio.get('$baseUrl/deployment/deplomentprofile_line');
      final entities = (response.data as List).cast<Map<String, dynamic>>();
      return entities;
    } catch (e) {
      throw Exception('Failed to get all deplomentprofile_line: $e');
    }
  }

  // get  Health
  Future<Map<String, dynamic>> getHealth(
      String token,String paramvalue) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
      await dio.get('$baseUrl/HealthCheckup/healthcheckup?jobtype=$paramvalue');
      final entities = response.data;
      return entities;
    } catch (e) {
      throw Exception('Failed to get all deplomentprofile_line: $e');
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
