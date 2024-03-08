import 'package:dio/dio.dart';
import 'package:authsec_flutter/resources/api_constants.dart';

class DashboardApiService {
  final String baseUrl = ApiConstants.baseUrl;
  final Dio dio = Dio();
  final Map<String, dynamic> wf_formData = {};

  Future<List<Map<String, dynamic>>> getdashboardBymoduleId(
      String token, int moduleId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
          await dio.get('$baseUrl/get_module_id?module_id=$moduleId');

      final responseData = response.data;
      print(' resp dash is $responseData');
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
      throw Exception('Failed to get dashboard by moduleid: $e');
    }
  }

  Future<void> createdashboard(
      String token, Map<String, dynamic> entity) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.post('$baseUrl/Savedata', data: entity);
      print(response);
      // final responseData = response.data;
      // final headerid = responseData['id'];

      // wf_formData['header_id'] = headerid;
      // wf_formData['model'] =
      //     '{"name":"form","description":"Form Description...","theme":{"bannerImage":""},"dashboard":[{"cols":8,"rows":2,"x":0,"y":0,"chartid":1,"name":"Text Field","charttitle":"Text Field","component":"Text Field","type":"text"}]}';

      // print('hear id is $headerid and wfmodel is $wf_formData');
      // createwfmodel(token!, wf_formData);
    } catch (e) {
      throw Exception('Failed to create dashboard: $e');
    }
  }

  // Future<void> createwfmodel(String token, Map<String, dynamic> entity) async {
  //   try {
  //     dio.options.headers['Authorization'] = 'Bearer $token';
  //     await dio.post('$baseUrl/r/create', data: entity);
  //     print('wf model is $entity');
  //   } catch (e) {
  //     throw Exception('Failed to create dashboard: $e');
  //   }
  // }

  Future<void> updatedashboard(
      String token, Map<String, dynamic> entity) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.put('$baseUrl/update_dashboard_header', data: entity);
      print(entity);
    } catch (e) {
      throw Exception('Failed to update dashboard: $e');
    }
  }

// UPDATE DASHBOARD LINE
  Future<void> updatedashboardLine(
      String token, int entityId, Map<String, dynamic> entity) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.put('$baseUrl/update_Dashbord1_Lineby_id/$entityId',
          data: entity);
      print(entity);
    } catch (e) {
      throw Exception('Failed to update dashboard line: $e');
    }
  }

  Future<void> deletedashboard(String token, int entityId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.delete('$baseUrl/delete_by_header_id/$entityId');
    } catch (e) {
      throw Exception('Failed to delete dashboard: $e');
    }
  }

  Future<Map<String, dynamic>> get_dashlinebyheaderid(
      String token, int header_id) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.get('$baseUrl/r/get_wf/$header_id');

      final responseData = response.data;
      return responseData;
      print('model data is $responseData');
    } catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  // Future<void> updateWf_model(
  //     String token, int headerId, Map<String, dynamic> entity) async {
  //   try {
  //     dio.options.headers['Authorization'] = 'Bearer $token';
  //     await dio.put('$baseUrl/r/updatewfline/$headerId', data: entity);
  //     print(entity);
  //   } catch (e) {
  //     throw Exception('Failed to update dashboard: $e');
  //   }
  // }
}
