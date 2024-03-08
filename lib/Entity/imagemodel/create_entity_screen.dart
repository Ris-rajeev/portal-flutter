// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:authsec_flutter/Entity/imagemodel/Product.dart';
import 'package:authsec_flutter/Entity/imagemodel/api_service.dart';
import 'package:authsec_flutter/providers/token_manager.dart';
import 'package:image_picker/image_picker.dart';

class CreateEntityScreen extends StatefulWidget {
  const CreateEntityScreen({Key? key}) : super(key: key);

  @override
  _CreateEntityScreenState createState() => _CreateEntityScreenState();
}

class _CreateEntityScreenState extends State<CreateEntityScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String? selectedDescription;
  List<Product> entities = [];

  @override
  void initState() {
    super.initState();
    fetchEntities();
  }

//GET ALL API FOR DROP DOWN
  Future<void> fetchEntities() async {
    final token = await TokenManager.getToken();
    final fetchedEntities = await apiService.getEntities(token!);
    setState(() {
      entities = fetchedEntities;
    });
  }

  Future<void> takePictureFromCamera() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      var filename = pickedFile.name;
      nameController.text = filename;

      // final reader = FileReader();
      // File photofile = File(pickedFile.path);

      // reader.readAsDataUrl(pickedFile.path);
      // reader.onLoadEnd.listen((event) {
      //   final imageData = reader.result as String?;
      //   setState(() {
      //     final blob = Blob([imageData!.split(',')[1]]);
      //     // TODO: Save the blob or perform any necessary operations
      //     nameController.text = pickedFile.name;
      //   });
      // }
      // );
    }
  }

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      var filename = pickedFile.name;
      nameController.text = filename;
      // final reader = FileReader();

      // reader.readAsDataUrl(pickedFile.path);
      // reader.onLoadEnd.listen((event) {
      //   final imageData = reader.result as String?;
      //   setState(() {
      //     final blob = Blob([imageData!.split(',')[1]]);
      //     // TODO: Save the blob or perform any necessary operations
      //     nameController.text = pickedFile.name;
      //   });
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Entity')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 5),

            // Camera and Gallery Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: takePictureFromCamera,
                  child: const Text('Take Picture'),
                ),
                ElevatedButton(
                  onPressed: pickImageFromGallery,
                  child: const Text('Pick from Gallery'),
                ),
              ],
            ),
            const SizedBox(height: 5),

            // ADDED DROP DOWN
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: DropdownButton<Product>(
                value: entities.isNotEmpty ? entities[0] : null,
                onChanged: (Product? newValue) {
                  setState(() {
                    selectedDescription = newValue?.name;
                  });
                },
                items: entities.map((Product entity) {
                  return DropdownMenuItem<Product>(
                    value: entity,
                    child: Text(entity.name),
                  );
                }).toList(),
                hint: const Text('Select Description'),
              ),
            ),
            const SizedBox(height: 5),

            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            const SizedBox(height: 5),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ElevatedButton(
                onPressed: () async {
                  final name = nameController.text;
                  final address = addressController.text;

                  final token = await TokenManager.getToken();
                  try {
                    await apiService.createEntity(
                      token!,
                      Product(
                        id: 0,
                        name: name,
                        address: address,
                        description: selectedDescription ?? '',
                      ),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: Text('Failed to create entity: $e'),
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
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(21)),
                  child: const Center(
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
