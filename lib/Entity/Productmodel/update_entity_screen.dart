import 'package:flutter/material.dart';
import 'package:authsec_flutter/Entity/Productmodel/Product.dart';
import 'package:authsec_flutter/Entity/Productmodel/api_service.dart';
import 'package:authsec_flutter/providers/token_manager.dart';

class UpdateEntityScreen extends StatefulWidget {
  final Product entity;

  UpdateEntityScreen({required this.entity});

  @override
  _UpdateEntityScreenState createState() => _UpdateEntityScreenState();
}

class _UpdateEntityScreenState extends State<UpdateEntityScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobnoController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.entity.name;
    descriptionController.text = widget.entity.description;
    addressController.text = widget.entity.address;
    emailController.text = widget.entity.email;

    mobnoController.text = widget.entity.mobno;
    pincodeController.text = widget.entity.pincode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Entity')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'email'),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: mobnoController,
              decoration: const InputDecoration(labelText: 'mobno'),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: pincodeController,
              decoration: const InputDecoration(labelText: 'pincode'),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'address'),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5), // Add margin
              child: ElevatedButton(
                onPressed: () async {
                  final name = nameController.text;
                  final description = descriptionController.text;
                  final address = addressController.text;
                  final mobno = mobnoController.text;

                  final email = emailController.text;
                  final pincode = pincodeController.text;
                  final token = await TokenManager.getToken();
                  try {
                    await apiService.updateEntity(
                      token!,
                      widget.entity.id,
                      Product(
                        name: name,
                        address: address,
                        description: description,
                        mobno: mobno,
                        email: email,
                        pincode: pincode,
                        id: widget.entity.id,
                      ),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: Text('Failed to update entity: $e'),
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
                  child: const Center(
                    child: Text(
                      'UPDATE',
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
