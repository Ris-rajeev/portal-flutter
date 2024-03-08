import 'package:dio/dio.dart';
import 'package:authsec_flutter/resources/api_constants.dart';

class ListBuilderApiService {
  final String baseUrl = ApiConstants.baseUrl;
  final Dio dio = Dio();
  final Map<String, dynamic> wfFormData = {};

  Future<List<Map<String, dynamic>>> getListBuilderBymoduleId(
      String token, int moduleId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio
          .get('$baseUrl/listbuilder/lb/get_module_id?module_id=$moduleId');

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
      throw Exception('Failed to get ListBuiulder by moduleid: $e');
    }
  }

  Future<void> createListBuiulder(
      String token, Map<String, dynamic> entity) async {
    try {
      List<dynamic> lbline = [];
      lbline.add({"model": ""});

      entity['lb_Line'] = lbline;
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
          await dio.post('$baseUrl/listbuilder/lb/Savedata', data: entity);
      print(response);
      // final responseData = response.data;
      // final headerid = responseData['id'];

      // wf_formData['header_id'] = headerid;
      // wf_formData['model'] =
      //     '{"name":"form","description":"Form Description...","theme":{"bannerImage":""},"ListBuiulder":[{"cols":8,"rows":2,"x":0,"y":0,"chartid":1,"name":"Text Field","charttitle":"Text Field","component":"Text Field","type":"text"}]}';

      // print('hear id is $headerid and wfmodel is $wf_formData');
      // createwfmodel(token!, wf_formData);
    } catch (e) {
      throw Exception('Failed to create ListBuiulder: $e');
    }
  }

  // Future<void> createwfmodel(String token, Map<String, dynamic> entity) async {
  //   try {
  //     dio.options.headers['Authorization'] = 'Bearer $token';
  //     await dio.post('$baseUrl/r/create', data: entity);
  //     print('wf model is $entity');
  //   } catch (e) {
  //     throw Exception('Failed to create ListBuiulder: $e');
  //   }
  // }

  Future<void> updateListBuiulder(
      String token, Map<String, dynamic> entity) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.put('$baseUrl/listbuilder/lb/update_lb_header', data: entity);
      print(entity);
    } catch (e) {
      throw Exception('Failed to update ListBuiulder: $e');
    }
  }

  Future<void> deleteListBuiulder(String token, int entityId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.delete('$baseUrl/listbuilder/lb/delete_by_header_id/$entityId');
    } catch (e) {
      throw Exception('Failed to delete ListBuiulder: $e');
    }
  }

  Future<Map<String, dynamic>> get_dashlinebyheaderid(
      String token, int header_id) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.get('$baseUrl/r/get_wf/$header_id');

      final responseData = response.data;
      return responseData;
    } catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  // <............. FOR LISTBUILDER LINE...........>

  Future<List<dynamic>> getAllTable(String token, int lbheadeId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio
          .get('$baseUrl/listbuilder/lb_line/getallwireframe_table/$lbheadeId');

      final responseData = response.data;
      print(' resp table is $responseData');

      return responseData;
    } catch (e) {
      throw Exception('Failed to get Table  by Lbheaderid: $e');
    }
  }

  Future<List<dynamic>> getAllCols(
      String token, int projectId, String tablename) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.get(
          '$baseUrl/formdrag/wireframe/columnlistofwireframe/$projectId/$tablename');

      final responseData = response.data;
      print(' all colums is $responseData');

      return responseData;
    } catch (e) {
      throw Exception('Failed to get Column : $e');
    }
  }

  Future<void> updateLbLine(
      String token, int entityId, Map<String, dynamic> entity) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.put('$baseUrl/listbuilder/lb/update_Lb_Lineby_id/$entityId',
          data: entity);
      print(entity);
    } catch (e) {
      throw Exception('Failed to update Line: $e');
    }
  }

// //	GET ALL LIST NAME BY WIREFRAME ID

  Future<List<dynamic>> getAllList(String token, int wfId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
          await dio.get('$baseUrl/listbuilder/lb/wireframe/all_list/$wfId');

      final responseData = response.data;
      print(' all list is $responseData');

      return responseData;
    } catch (e) {
      throw Exception('Failed to get List : $e');
    }
  }

//	GET ALL COLUMN NAME BY MODULE ID ID AND LIST NAME
  Future<List<dynamic>> getAllListColumns(
      String token, int moduleId, String listName) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio
          .get('$baseUrl/listbuilder/lb/getall_cols/$moduleId/$listName');

      final responseData = response.data;
      // print(' list colums is $responseData');

      return responseData;
    } catch (e) {
      throw Exception('Failed to get List Columns : $e');
    }
  }
}
