import 'package:flutter/material.dart';
import 'ProjectListScreen.dart';


class MyProject extends StatefulWidget {
  final Map<String, dynamic> userData;
  const MyProject({required this.userData, Key? key}) : super(key: key);
  @override
  _MyProjectState createState() => _MyProjectState();
}

class _MyProjectState extends State<MyProject> {
  // late List<Map<String, dynamic>> projects = [];
  //
  // final ProjectApiService projectApiService = ProjectApiService();

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    // final token = await TokenManager.getToken();
    // try {
    //   final projectData = await projectApiService.getproject(token!);
    //   setState(() {
    //     projects = projectData;
    //   });
      // After loading the data, navigate to the ProjectListScreen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ProjectListScreen(
            userData: widget.userData,
            type:"myproject"
          ),
        ),
      );
    }
    // catch (e) {
    //   setState(() {});
    //   print('Failed to load projects: $e');
    // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // You can display a loading indicator here while data is being fetched
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
