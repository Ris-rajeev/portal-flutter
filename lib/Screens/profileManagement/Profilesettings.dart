import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../providers/token_manager.dart';
import '../../resources/api_constants.dart';
import '../Login Screen/login_screen.dart';
import 'apiserviceprofilemanagement.dart';
import 'package:http/http.dart' as http;

import 'changepassword.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  ProfileSettingsScreen({required this.userData});

  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  ApiServiceProfileManagement apiService = ApiServiceProfileManagement();
  String? fetchedimageurl =
      'http://43.205.154.152:30165/assets/images/profile-icon.png';
  Uint8List? _imageBytes; // Uint8List to store the image data
  String? _imageFileName;
  final _formKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController pronounsController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //fetchProfileImageData();
    fetchUserProfileData();
  }

  Future<void> _uploadImageFile() async {
    final imagePicker = ImagePicker();

    try {
      final pickedImage =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        final imageBytes = await pickedImage.readAsBytes();

        setState(() {
          _imageBytes = imageBytes;
          _imageFileName = pickedImage.name; // Store the file name
        });
      }
    } catch (e) {
      print(e);
    }
  }

  //api/user-profile
  Future<void> fetchUserProfileData() async {
    final token = await TokenManager.getToken();
    final String baseUrl = ApiConstants.baseUrl;
    final String apiUrl = '$baseUrl/api/user-profile';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode >= 200 && response.statusCode <= 209) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        setState(() {
          fullNameController.text =
              jsonData['fullName'] != null ? jsonData['fullName'] : '';
          pronounsController.text =
              jsonData['pronouns'] != null ? jsonData['pronouns'] : '';
          roleController.text =
              jsonData['role'] != null ? jsonData['role'] : '';
          departmentController.text =
              jsonData['department'] != null ? jsonData['department'] : '';
          emailController.text =
              jsonData['email'] != null ? jsonData['email'] : '';
          aboutMeController.text =
              jsonData['about'] != null ? jsonData['about'] : '';
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<void> fetchProfileImageData() async {
    final token = await TokenManager.getToken();
    final String baseUrl = ApiConstants.baseUrl;
    final String apiUrl = '$baseUrl/api/retrieve-image';
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode >= 200 && response.statusCode <= 209) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final trustedImageUrl = Uri.dataFromString(jsonData['image'],
                mimeType: 'image/*', encoding: Encoding.getByName('utf-8'))
            .toString();
        fetchedimageurl = trustedImageUrl;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<void> _submitImage() async {
    if (_imageBytes == null) {
      // Show an error message if no image is selected
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Please select an image.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    if (_imageFileName == null) {
      // Handle the case where _imageFileName is null (no file name provided)
      print('File name is missing.');
      return;
    }
    try {
      final token = await TokenManager.getToken();
      await apiService.createFile(_imageBytes!, _imageFileName!, token!);
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to upload image: $e'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      // Create a JSON object with the form data
      final profileData = {
        'fullName': fullNameController.text,
        'pronouns': pronounsController.text,
        'role': roleController.text,
        'department': departmentController.text,
        'email': emailController.text,
        'aboutMe': aboutMeController.text,
      };

      //api/user-profile

      final token = await TokenManager.getToken();
      final String baseUrl = ApiConstants.baseUrl;
      final String apiUrl = '$baseUrl/api/user-profile';
      try {
        final response = await http.put(Uri.parse(apiUrl),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: json.encode(profileData));
        if (response.statusCode <= 209) {
          print("success");
          Navigator.of(context).pop();
        } else {
          print(response.statusCode);
        }
      } catch (e) {
        throw Exception('Failed to Update: $e');
      }
    }
  }

  Future<void> _logoutUser() async {
    try {
      String logouturl = "${ApiConstants.baseUrl}/token/logout";
      var response = await http.get(Uri.parse(logouturl));

      if (response.statusCode <= 209) {
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false, // Remove all routes from the stack
        );
      } else {
        const Text('failed to logout');
      }
    } catch (error) {
      print('Error occurred during logout: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile Settings'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Section: Show Profile Photo
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 80, // Adjust as needed
                    backgroundImage: NetworkImage(
                        "$fetchedimageurl"), // Replace with your API URL
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_imageBytes != null) {
                        _submitImage();
                      } else {
                        _uploadImageFile();
                      }
                    },
                    child: _imageBytes == null
                        ? Text('Pick a Profile Photo')
                        : Text('Upload a Profile Photo'),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Section: Profile Form
            Text(
              'Your Profile Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: fullNameController, // Assign the controller
                    decoration: InputDecoration(labelText: 'Your Full Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      fullNameController.text = value;
                    },
                  ),
                  TextFormField(
                    controller: pronounsController, // Assign the controller
                    decoration: InputDecoration(labelText: 'Pronouns'),
                    onChanged: (value) {
                      pronounsController.text = value;
                    },
                  ),
                  TextFormField(
                    controller: roleController, // Assign the controller
                    decoration: InputDecoration(labelText: 'Role'),
                    onChanged: (value) {
                      roleController.text = value;
                    },
                  ),
                  TextFormField(
                    controller: departmentController, // Assign the controller
                    decoration:
                        InputDecoration(labelText: 'Department or Team'),
                    onChanged: (value) {
                      departmentController.text = value;
                    },
                  ),
                  TextFormField(
                    controller: emailController, // Assign the controller
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value!.isEmpty || !value!.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      emailController.text = value;
                    },
                  ),
                  TextFormField(
                    controller: aboutMeController, // Assign the controller
                    decoration: InputDecoration(labelText: 'About Me'),
                    maxLines: 3,
                    onChanged: (value) {
                      aboutMeController.text = value;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateProfile,
                    child: Text('Update Profile'),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResetPasswordScreen(
                      userData: widget.userData,
                      userEmail: emailController.text,
                    ), //go to get all entity
                  ),
                );
              },
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          "Password:Change Password for your account Change password",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                print("change password");
              },
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          'Security:Logout of all sessions except this current browser Logout other sessions',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                _logoutUser();
              },
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          'Deactivation:Remove access to all organizations and workspace in cloudnsure Deactivate account',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
