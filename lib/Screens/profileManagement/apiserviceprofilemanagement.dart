import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import '../../resources/api_constants.dart';

class ApiServiceProfileManagement {
  final String baseUrl = ApiConstants.baseUrl;
  final Dio dio = Dio();

  Future<void> createFile(
      Uint8List fileBytes, String fileName, String token) async {
    try {
      String apiUrl = "$baseUrl/api/upload";

      final mimeType = 'image/jpeg'; // You can set the appropriate MIME type

      FormData formData = FormData.fromMap({
        'imageFile': MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
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
}
