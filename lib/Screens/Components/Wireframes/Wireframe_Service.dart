import 'package:dio/dio.dart';
import 'package:authsec_flutter/resources/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WireframeApiService {
  final String baseUrl = ApiConstants.baseUrl;
  final Dio dio = Dio();
  final Map<String, dynamic> wf_formData = {};

  Future<List<Map<String, dynamic>>> getwirrframeBymoduleId(
      String token, int moduleId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
          await dio.get('$baseUrl/api/wireframe?moduleId=$moduleId');

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
      throw Exception('Failed to get wireframe by moduleid: $e');
    }
  }

  Future<void> createWireframe(
      String token, Map<String, dynamic> entity) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.post('$baseUrl/api/wireframe', data: entity);
      print(response);
      final responseData = response.data;
      final headerid = responseData['id'];

      wf_formData['header_id'] = headerid;
      wf_formData['model'] =
          '{"name":"form","description":"Form Description...","theme":{"bannerImage":""},"dashboard":[{"cols":8,"rows":2,"x":0,"y":0,"chartid":1,"name":"Text Field","charttitle":"Text Field","component":"Text Field","type":"text"}]}';

      print('hear id is $headerid and wfmodel is $wf_formData');
      createwfmodel(token!, wf_formData);
    } catch (e) {
      throw Exception('Failed to create wireframe: $e');
    }
  }

  Future<void> createwfmodel(String token, Map<String, dynamic> entity) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.post('$baseUrl/r/create', data: entity);
      print('wf model is $entity');
    } catch (e) {
      throw Exception('Failed to create wireframe: $e');
    }
  }

  Future<void> updateWireframe(
      String token, int entityId, Map<String, dynamic> entity) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.put('$baseUrl/wfb/newupdate/headersnew/$entityId',
          data: entity);
      print(entity);
    } catch (e) {
      throw Exception('Failed to update wireframe: $e');
    }
  }

  Future<void> deleteWireframe(String token, int entityId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      await dio.delete('$baseUrl/api/wireframe_delete_header/$entityId');
    } catch (e) {
      throw Exception('Failed to delete wireframe: $e');
    }
  }

  Future<Map<String, dynamic>> get_wflinebyheaderid(
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

  Future<void> updateWf_model(
      String token, int headerId, Map<String, dynamic> entity) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
          await dio.put('$baseUrl/r/updatewfline/$headerId', data: entity);
      print(entity);

      final responsecode = response.statusCode;
      print('response is $responsecode');
      if (responsecode! <= 209) {
        Fluttertoast.showToast(
          msg: 'Update Successfull',
          backgroundColor: Colors.green,
          gravity: ToastGravity.TOP, // Set toast gravity to top
          timeInSecForIosWeb: 5,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Update failed',
          backgroundColor: Colors.red,
          gravity: ToastGravity.TOP, // Set toast gravity to top
          timeInSecForIosWeb: 5,
        );
      }
    } catch (e) {
      throw Exception('Failed to update wireframe: $e');
    }
  }

  //  API OF FORM DRAG ........................................
  Future<List<dynamic>> getwfForchild(
      String token, int projId, int wfId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio
          .get('$baseUrl/formdrag/wireframe/getall_table/$projId/$wfId');

      final responseData = response.data;
      return responseData;
    } catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

//  get all lookuptype
  Future<List<dynamic>> getlookuptype(String token) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response =
          await dio.get('$baseUrl/listbuilder_library/lb/module/lookup/getall');

      final responseData = response.data;
      return responseData;
    } catch (e) {
      throw Exception('Failed to get lookup type data: $e');
    }
  }

// CREATE MASTER
  Future<void> createmaster(
      String token, int moduleId, int backendId, String name) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.get(
        '$baseUrl/api/wireframe/master/$backendId/$moduleId?listName=$name',
      );

      final responsecode = response.statusCode;
      print('response is $responsecode');
      if (response.statusCode! <= 209) {
        Fluttertoast.showToast(
          msg: 'Create Master successful',
          backgroundColor: Colors.green,
          gravity: ToastGravity.TOP, // Set toast gravity to top
          timeInSecForIosWeb: 5,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Create Master failed',
          backgroundColor: Colors.red,
          gravity: ToastGravity.TOP, // Set toast gravity to top
          timeInSecForIosWeb: 5,
        );
      }
    } catch (e) {
      throw Exception('Failed to create master: $e');
    }
  }

// CREATE MASTER
  Future<void> createlookUptype(
      String token, String lbId, int moduleId, int backendId) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.get(
        '$baseUrl/listbuilder_library/lb/lookuptype/create?lbId=$lbId&moduleid=$moduleId&backendId=$backendId',
      );

      final responsecode = response.statusCode;
      print('response is $responsecode');
      if (response.statusCode! <= 209) {
        Fluttertoast.showToast(
          msg: 'Create lookup successful',
          backgroundColor: Colors.green,
          gravity: ToastGravity.TOP, // Set toast gravity to top
          timeInSecForIosWeb: 5,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Create lookup failed',
          backgroundColor: Colors.red,
          gravity: ToastGravity.TOP, // Set toast gravity to top
          timeInSecForIosWeb: 5,
        );
      }
    } catch (e) {
      throw Exception('Failed to create lookup: $e');
    }
  }
}
