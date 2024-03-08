import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../providers/token_manager.dart';
import 'SystemParameterApiService.dart';

class SysParameter extends StatefulWidget {
  final int sysparameter = 1;

  // const SysParameter({Key? key, required this.sysparameter}) : super(key: key);
  @override
  _SysParameterState createState() => _SysParameterState();
}

class _SysParameterState extends State<SysParameter> {
  TextEditingController schedulerTimerController = TextEditingController();
  TextEditingController leaseTaxCodeController = TextEditingController();
  TextEditingController vesselConfirmationController = TextEditingController();
  TextEditingController rowToDisplayController = TextEditingController();
  TextEditingController linkToDisplayController = TextEditingController();
  TextEditingController rowToAddController = TextEditingController();
  TextEditingController lovRowToDisplayController = TextEditingController();
  TextEditingController lovLinkToDisplayController = TextEditingController();
  TextEditingController oidServerNameController = TextEditingController();
  TextEditingController oidBaseController = TextEditingController();
  TextEditingController oidAdminUserController = TextEditingController();
  TextEditingController oidServerPortController = TextEditingController();
  TextEditingController userDefaultGroupController = TextEditingController();
  TextEditingController defaultDepartmentController = TextEditingController();
  TextEditingController defaultPositionController = TextEditingController();
  TextEditingController singleChargeController = TextEditingController();
  TextEditingController firstDayOfWeekController = TextEditingController();
  TextEditingController hourPerShiftController = TextEditingController();
  TextEditingController cnBillingFrequencyController = TextEditingController();
  TextEditingController billingDepartmentCodeController =
      TextEditingController();
  TextEditingController basePriceListController = TextEditingController();
  TextEditingController nonContainerServiceController = TextEditingController();
  TextEditingController ediMaeSchedulerController = TextEditingController();
  TextEditingController ediSchedulerController = TextEditingController();
  TextEditingController lastController = TextEditingController();
  TextEditingController companynameController = TextEditingController();

  Map<String, dynamic> formData = {};
  var logoname;
  var logopath;

  SystemParameterApiService apiService = SystemParameterApiService();

  String? uploadimageurl;
  Uint8List? _imageBytes; // Uint8List to store the image data
  String? _imageFileName;

  late Map<String, dynamic> sysparameter;

  @override
  void initState() {
    _loadParameters();
  }

  Future<void> _loadParameters() async {
    final token = await TokenManager.getToken();
    try {
      final projectData =
          await apiService.getsystemparameters(token!, widget.sysparameter);
      setState(() {
        sysparameter = projectData;
        lastController.text = "('SYSADMIN','ITSUPPORTMSC')";
        schedulerTimerController.text =
            sysparameter['schedulerTime'].toString() ?? '';
        leaseTaxCodeController.text =
            sysparameter['leaseTaxCode'].toString() ?? '';
        vesselConfirmationController.text =
            sysparameter['vesselConfProcessLimit'].toString() ?? '';
        rowToDisplayController.text =
            sysparameter['rowToDisplay'].toString() ?? '';
        linkToDisplayController.text =
            sysparameter['linkToDisplay'].toString() ?? '';
        rowToAddController.text = sysparameter['rowToAdd'].toString() ?? '';
        lovRowToDisplayController.text =
            sysparameter['lovRowToDisplay'].toString() ?? '';
        lovLinkToDisplayController.text =
            sysparameter['lovLinkToDisplay'].toString() ?? '';
        oidServerNameController.text =
            sysparameter['oidserverName'].toString() ?? '';
        oidBaseController.text = sysparameter['oidBase'].toString() ?? '';
        oidAdminUserController.text =
            sysparameter['oidAdminUser'].toString() ?? '';
        oidServerPortController.text =
            sysparameter['oidServerPort'].toString() ?? '';
        userDefaultGroupController.text =
            sysparameter['userDefaultGroup'].toString() ?? '';
        defaultDepartmentController.text =
            sysparameter['defaultDepartment'].toString() ?? '';
        defaultPositionController.text =
            sysparameter['defaultPosition'].toString() ?? '';
        singleChargeController.text =
            sysparameter['singleCharge'].toString() ?? '';
        firstDayOfWeekController.text =
            sysparameter['firstDayOftheWeek'].toString() ?? '';
        hourPerShiftController.text =
            sysparameter['hourPerShift'].toString() ?? '';
        cnBillingFrequencyController.text =
            sysparameter['cnBillingFrequency'].toString() ?? '';
        billingDepartmentCodeController.text =
            sysparameter['billingDepartmentCode'].toString() ?? '';
        basePriceListController.text =
            sysparameter['basePriceList'].toString() ?? '';
        nonContainerServiceController.text =
            sysparameter['nonContainerServiceOrder'].toString() ?? '';
        ediMaeSchedulerController.text =
            sysparameter['ediMaeSchedulerONOFF'].toString() ?? '';
        ediSchedulerController.text =
            sysparameter['ediSchedulerONOFF'].toString() ?? '';
        lastController.text = "('SYSADMIN','ITSUPPORTMSC')" ?? '';
        companynameController.text =
            sysparameter['company_Display_Name'].toString() ?? '';
        print(sysparameter['schedulerTime']);
      });
    } catch (e) {
      print('Failed to load projects: $e');
    }
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
      _submitImage();
    } catch (e) {
      print(e);
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
      Map<String, dynamic> fileuploadeddata =
          await apiService.createFile(_imageBytes!, _imageFileName!, token!);
      logoname = fileuploadeddata['image_name'];
      logopath = fileuploadeddata['image_path'];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Add an AppBar
          title: Text('System Parameter'), // Set the app bar title
        ),
        body: Material(
            child: SingleChildScrollView(
          // Wrap the form in a SingleChildScrollView
          scrollDirection: Axis.vertical, // Allow vertical scrolling
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldWithTooltip(
                  fieldName: 'Scheduler Timer',
                  controller: schedulerTimerController,
                  tooltip: 'Tooltip for Scheduler Timer',
                ),
                _buildFieldWithTooltip(
                  fieldName: 'Lease Tax Code',
                  controller: leaseTaxCodeController,
                  tooltip: 'Tooltip for Lease Tax Code',
                ),
                _buildFieldWithTooltip(
                  fieldName: 'Vessel Confirmation Process Limit',
                  controller: vesselConfirmationController,
                  tooltip: 'Tooltip for Vessel Confirmation Process Limit',
                ),
                _buildFieldWithTooltip(
                  fieldName: 'Row To Display',
                  controller: rowToDisplayController,
                  tooltip: 'Tooltip for Row To Display',
                ),
                _buildFieldWithTooltip(
                  fieldName: 'Link To Display',
                  controller: linkToDisplayController,
                  tooltip: 'Tooltip for Link To Display',
                ),
                _buildFieldWithTooltip(
                  fieldName: 'Row To Add',
                  controller: rowToAddController,
                  tooltip: 'Tooltip for Row To Add',
                ),
                _buildFieldWithTooltip(
                  fieldName: 'LOV Row To Display',
                  controller: lovRowToDisplayController,
                  tooltip: 'Tooltip for LOV Row To Display',
                ),
                _buildFieldWithTooltip(
                  fieldName: 'LOV Link To Display',
                  controller: lovLinkToDisplayController,
                  tooltip: 'Tooltip for LOV Link To Display',
                ),
                _buildFieldWithTooltip(
                  fieldName: 'OID Server Name',
                  controller: oidServerNameController,
                  tooltip: 'Tooltip for OID Server Name',
                ),
                _buildFieldWithTooltip(
                  fieldName: 'OID Base',
                  controller: oidBaseController,
                  tooltip: 'Tooltip for OID Base',
                ),
                _buildFieldWithTooltip(
                  fieldName: 'OID Admin User',
                  controller: oidAdminUserController,
                  tooltip: 'Tooltip for OID Admin User',
                ),
                _buildFieldWithTooltip(
                  fieldName: 'OID Server Port',
                  controller: oidServerPortController,
                  tooltip: 'Tooltip for OID Server Port',
                ),
                _buildFieldWithTooltip(
                  fieldName: 'User Default Group',
                  controller: userDefaultGroupController,
                  tooltip: 'Tooltip for User Default Group',
                ),
                _buildFieldWithTooltip(
                  fieldName: 'Default Department',
                  controller: defaultDepartmentController,
                  tooltip: 'Tooltip for Default Department',
                ),
                _buildFieldWithTooltip(
                  fieldName: 'Default Position',
                  controller: defaultPositionController,
                  tooltip: 'Tooltip for Default Position',
                ),
                _buildFieldWithTooltip(
                  fieldName: 'Single Charge',
                  controller: singleChargeController,
                  tooltip: 'Tooltip for Single Charge',
                ),
                _buildFieldWithTooltip(
                  fieldName: 'First Day of The Week',
                  controller: firstDayOfWeekController,
                  tooltip: 'Tooltip for First Day of The Week',
                ),
                _buildFieldWithTooltip(
                  fieldName: 'Hour per Shift',
                  controller: hourPerShiftController,
                  tooltip: 'Tooltip for Hour per Shift',
                ),
                _buildFieldWithTooltip(
                  fieldName: 'CN Billing Frequency',
                  controller: cnBillingFrequencyController,
                  tooltip: 'Tooltip for CN Billing Frequency',
                ),
                _buildFieldWithTooltip(
                  fieldName: 'Billing Department Code',
                  controller: billingDepartmentCodeController,
                  tooltip: 'Tooltip for Billing Department Code',
                ),
                _buildFieldWithTooltip(
                  fieldName: 'Base Price List',
                  controller: basePriceListController,
                  tooltip: 'Tooltip for Base Price List',
                ),
                _buildFieldWithTooltip(
                  fieldName:
                      'Non-Container Service Order Auto-Approval Department Code',
                  controller: nonContainerServiceController,
                  tooltip:
                      'Tooltip for Non-Container Service Order Auto-Approval Department Code',
                ),
                _buildFieldWithTooltip(
                  fieldName: 'EDI MAE Scheduler ON/OFF',
                  controller: ediMaeSchedulerController,
                  tooltip: 'Tooltip for EDI MAE Scheduler ON/OFF',
                ),
                _buildFieldWithTooltip(
                  fieldName: 'EDI Scheduler ON/OFF',
                  controller: ediSchedulerController,
                  tooltip: 'Tooltip for EDI Scheduler ON/OFF',
                ),
                _buildFieldWithTooltip(
                  fieldName: 'Company Name',
                  controller: companynameController,
                  tooltip: 'Company Name',
                ),

                ElevatedButton(
                  onPressed: () {
                    _uploadImageFile();
                  },
                  child: _imageBytes == null
                      ? Text('Pick a Company Logo')
                      : Text('Company Logo uploaded Successful'),
                  style: ButtonStyle(
                    backgroundColor: _imageBytes == null
                        ? MaterialStateProperty.all<Color>(Colors.red)
                        : MaterialStateProperty.all<Color>(
                            Colors.green), // Change to the desired color
                  ),
                ),

                Tooltip(
                  message: 'Allow customer code for MSC taulia CSV generation',
                  child: TextFormField(
                    controller: lastController,
                    decoration: InputDecoration(
                      labelText: 'i',
                    ),
                  ),
                ),

                // Save button
                ElevatedButton(
                  onPressed: () async {
                    formData['schedulerTime'] = schedulerTimerController.text;
                    formData['leaseTaxCode'] = leaseTaxCodeController.text;
                    formData['vesselConfProcessLimit'] =
                        vesselConfirmationController.text;
                    formData['rowToDisplay'] = rowToDisplayController.text;
                    formData['linkToDisplay'] = linkToDisplayController.text;
                    formData['rowToAdd'] = rowToAddController.text;
                    formData['lovRowToDisplay'] =
                        lovRowToDisplayController.text;
                    formData['lovLinkToDisplay'] =
                        lovLinkToDisplayController.text;
                    formData['oidserverName'] = oidServerNameController.text;
                    formData['oidBase'] = oidBaseController.text;
                    formData['oidAdminUser'] = oidAdminUserController.text;
                    formData['oidServerPort'] = oidServerPortController.text;
                    formData['userDefaultGroup'] =
                        userDefaultGroupController.text;
                    formData['defaultDepartment'] =
                        defaultDepartmentController.text;
                    formData['defaultPosition'] =
                        defaultPositionController.text;
                    formData['singleCharge'] = singleChargeController.text;
                    formData['firstDayOftheWeek'] =
                        firstDayOfWeekController.text;
                    formData['hourPerShift'] = hourPerShiftController.text;
                    formData['cnBillingFrequency'] =
                        cnBillingFrequencyController.text;
                    formData['billingDepartmentCode'] =
                        billingDepartmentCodeController.text;
                    formData['basePriceList'] = basePriceListController.text;
                    formData['nonContainerServiceOrder'] =
                        nonContainerServiceController.text;
                    formData['ediMaeSchedulerONOFF'] =
                        ediMaeSchedulerController.text;
                    formData['ediSchedulerONOFF'] = ediSchedulerController.text;
                    //formData['']=lastController.text;
                    formData['upload_Logo_name'] = logoname;
                    formData['upload_Logo_path'] = logopath;
                    formData['company_Display_Name'] =
                        companynameController.text;
                    final token = await TokenManager.getToken();

                    try {
                      print("token is : $token");
                      print(formData);

                      if (formData != null) {
                        // Create new project
                        apiService.updateParameter(
                            token!, widget.sysparameter, formData);
                      }
                      Navigator.pop(context);
                      // Add navigation or any other logic after successful create/update
                    } catch (e) {
                      print('error is $e');
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: Text(
                                'Failed to ${widget.sysparameter == null ? 'create' : 'update'} project: $e'),
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
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        )));
  }

  Widget _buildFieldWithTooltip({
    required String fieldName,
    required TextEditingController controller,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: fieldName,
        ),
      ),
    );
  }
}
