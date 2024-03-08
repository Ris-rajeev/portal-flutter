import 'dart:convert';

import 'package:authsec_flutter/screens/ContainerLogs/LiveLogsScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

import '../../../providers/token_manager.dart';
import '../../../resources/api_constants.dart';

class SureFarmContent extends StatelessWidget {
  final int projectId;

  SureFarmContent({Key? key, required this.projectId}) : super(key: key);

  Future<List<Map<String, dynamic>>> fetchData() async {
    var profileId = 3;
    final token = await TokenManager.getToken();
    const String baseUrlSureOps = ApiConstants.baseUrlSureOps;
    final String apiUrl =
        '$baseUrlSureOps/sureops/getfile/get_allfile/$profileId/$projectId';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode <= 209) {
        final List<dynamic> jsonData = json.decode(response.body);

        print('got json from get all api ');
        return jsonData.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  final Dio dio = Dio();

  Future<String> fetchStatus(String contName) async {
    var status;
    print('container name is $contName');
    try {
      final response = await dio.get(
        'http://13.233.70.96:30168/script/executeCommandtest?privateKey=/usr/app&command= docker inspect $contName',
      );
      var json = response.data;
      var data = json[0];

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(data); // Parse the JSON

        if (jsonData is List) {
          for (var element in jsonData) {
            print('element got');
            if (element is Map && element.containsKey('State')) {
              status = element['State']['Status'];
              print('status is $status');
              break; // Exit the loop after finding the status
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching logs: $e');
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error: Server Error'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available.'));
          } else {
            return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Profile ID')),
                    DataColumn(label: Text('Open Port')),
                    DataColumn(label: Text('Service Name')),
                    DataColumn(label: Text('Action')),
                    DataColumn(label: Text('Web URL')),
                    DataColumn(label: Text('Container Status')),
                    DataColumn(label: Text('Container name')),
                    DataColumn(label: Text('Container Logs')),
                  ],
                  rows: snapshot.data!.map((item) {
                    return DataRow(cells: [
                      DataCell(Text(item['name'] ?? 'N/A')),
                      DataCell(Text(item['profile_id']?.toString() ?? 'N/A')),
                      DataCell(Text(item['openport']?.toString() ?? 'N/A')),
                      DataCell(Text(item['service_name'] ?? 'N/A')),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.info),
                          onPressed: () {
                            // Add your action logic here
                          },
                        ),
                      ),
                      DataCell(
                        Text(item['weburl'] ?? 'N/A'),
                        onTap: () {
                          if (item['weburl'] != null) {
                            // Add logic to open the web URL here
                          }
                        },
                      ),
                      DataCell(
                        FutureBuilder<String>(
                          future: fetchStatus(item['container_name']),
                          builder: (context, statusSnapshot) {
                            if (statusSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (statusSnapshot.hasError) {
                              return const Text('Error',
                                  style: TextStyle(color: Colors.red));
                            } else {
                              final status = statusSnapshot.data;
                              final color = status == 'running'
                                  ? Colors.green
                                  : Colors.red;
                              return Text(status ?? 'N/A',
                                  style: TextStyle(color: color));
                            }
                          },
                        ),
                      ),
                      DataCell(Text(item['container_name'] ?? 'N/A')),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.logo_dev_sharp),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LiveLogsScreen(
                                        containerName:
                                            item['container_name'])));
                          },
                        ),
                      ),
                    ]);
                  }).toList(),
                ));
          }
        },
      ),
    );
  }
}
