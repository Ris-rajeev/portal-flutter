import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:authsec_flutter/Entity/Productmodel/Product.dart';
import 'package:authsec_flutter/Entity/Productmodel/api_service.dart';
import 'package:authsec_flutter/providers/token_manager.dart';

class CreateEntityScreen extends StatefulWidget {
  const CreateEntityScreen({Key? key}) : super(key: key);

  @override
  _CreateEntityScreenState createState() => _CreateEntityScreenState();
}

class _CreateEntityScreenState extends State<CreateEntityScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobnoController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();

  String? selectedDescription;
  List<Product> entities = [];
  FlutterSoundRecorder? _audioRecorder;
  FlutterSoundPlayer? _audioPlayer;
  bool _isRecording = false;
  String? _recordedFilePath;
  bool _isPlaying = false;

  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();
    _audioRecorder = FlutterSoundRecorder();
    _audioPlayer = FlutterSoundPlayer();
    _initAudioRecorder();
    fetchEntities();
  }

  Future<void> fetchEntities() async {
    final token = await TokenManager.getToken();
    final fetchedEntities = await apiService.getEntities(token!);
    setState(() {
      entities = fetchedEntities;
    });
  }

  void _initAudioRecorder() async {
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/recording.aac';
    await _audioRecorder!.startRecorder(toFile: filePath);
  }

  void _startRecording() async {
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/recording.aac';

    await _audioRecorder!.startRecorder(toFile: filePath);
    setState(() {
      _isRecording = true;
      _recordedFilePath = null;
      _isPlaying = false;
    });
  }

  void _stopRecording() async {
    final recordedFilePath = await _audioRecorder!.stopRecorder();
    setState(() {
      _isRecording = false;
      _recordedFilePath = recordedFilePath;
    });
  }

  void _playRecording() async {
    if (_recordedFilePath != null) {
      await _audioPlayer!.startPlayer(
        fromURI: _recordedFilePath,
        whenFinished: () {
          setState(() {
            _isPlaying = false;
          });
        },
      );
      setState(() {
        _isPlaying = true;
      });
    }
  }

  void _pauseRecording() async {
    await _audioPlayer!.pausePlayer();
    setState(() {
      _isPlaying = false;
    });
  }

  void _selectLocation() async {
    final LatLng? pickedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MapScreen(),
      ),
    );

    if (pickedLocation != null) {
      setState(() {
        selectedLocation = pickedLocation;
      });
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                ),
                IconButton(
                  icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                  onPressed: () {
                    setState(() {
                      if (_isRecording) {
                        // Stop recording
                        _stopRecording();
                      } else {
                        // Start recording
                        _startRecording();
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                IconButton(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    setState(() {
                      if (_isPlaying) {
                        // Pause playback
                        _pauseRecording();
                      } else {
                        // Start playback
                        _playRecording();
                      }
                    });
                  },
                ),
                const SizedBox(width: 8),
                Text(_recordedFilePath ?? 'No recording'),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: Text(selectedLocation != null
                      ? 'Location: ${selectedLocation!.latitude}, ${selectedLocation!.longitude}'
                      : 'No location selected'),
                ),
                IconButton(
                  icon: Icon(Icons.map),
                  onPressed: _selectLocation,
                ),
              ],
            ),
            const SizedBox(height: 5),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ElevatedButton(
                onPressed: () async {
                  final name = nameController.text;
                  final address = addressController.text;
                  final mobno = mobnoController.text;
                  final email = emailController.text;
                  final pincode = pincodeController.text;

                  final token = await TokenManager.getToken();
                  try {
                    await apiService.createEntity(
                      token!,
                      Product(
                        id: 0,
                        name: name,
                        address: address,
                        mobno: mobno,
                        email: email,
                        pincode: pincode,
                        description: selectedDescription ?? '',
                        // latitude: selectedLocation?.latitude as double? ?? 0.0,
                        // longitude: selectedLocation?.longitude as double? ?? 0.0,
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

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng? selectedLocation;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _selectLocation(LatLng location) async {
    final addresses =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    if (addresses.isNotEmpty) {
      final address = addresses.first;
      print(
          'Selected Address: ${address.street}, ${address.locality}, ${address.postalCode}');
    }
    setState(() {
      selectedLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Location')),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(0, 0),
          zoom: 13,
        ),
        onTap: _selectLocation,
        markers: selectedLocation != null
            ? {
                Marker(
                  markerId: MarkerId('selectedLocation'),
                  position: selectedLocation!,
                ),
              }
            : {},
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          Navigator.of(context).pop(selectedLocation);
        },
      ),
    );
  }
}
