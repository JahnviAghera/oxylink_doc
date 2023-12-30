import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled1/widgets1/profile_avtar.dart';

class PatientDetailsPage extends StatefulWidget {
  final String patientId;
  final String recordedBy;

  PatientDetailsPage({
    required this.patientId,
    required this.recordedBy,
  });

  @override
  _PatientDetailsPageState createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  Map<String, dynamic> _patientDetails = {};
  double? _sliderValue;
  double? _qualitySliderValue;

  @override
  void initState() {
    super.initState();
    _fetchPatientDetails();
  }

  Future<void> _fetchPatientDetails() async {
    final apiUrl =
        'http://udhyog4.in/API/fetch_patient_detail.php?patient_id=${widget.patientId}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic>? responseData = json.decode(response.body);

        if (responseData != null && responseData['status'] == 'success') {
          final Map<String, dynamic>? patientData =
              responseData['patients'].first;

          if (patientData != null) {
            setState(() {
              _patientDetails = patientData;
              _sliderValue = double.parse(_patientDetails['oxygen_flow_rate']);
              _qualitySliderValue =
                  double.parse(_patientDetails['oxygen_quality_data']);
            });
          }
        }
      }
    } catch (error) {
      print('Error: $error');
    }
  }
  Future<void> _updateOxygenValues(double v1, double v2, String name) async {
    final apiUrl = 'http://udhyog4.in/API/update_oxygen_value.php';

    final Uri urlWithParams = Uri.parse(
        '$apiUrl?patient_id=${_patientDetails['patient_id']}&oxygen_flow_rate=${v1.toString()}&oxygen_quality_data=${v2.toString()}&recorded_by=${widget.recordedBy}&name=$name');

    try {
      final response = await http.post(
        urlWithParams,
        headers: {'Content-Type': 'application/json'},
      );

      // Log the response status code
      print('Response status code: ${response.statusCode}');

      // Log the response body
      print('Response body: ${response.body}');

      // Check if the update was successful
      if (response.statusCode == 200) {
        final Map<String, dynamic>? responseData = json.decode(response.body);

        if (responseData != null && responseData['status'] == 'success') {
          // If update was successful, fetch patient details again
          await _fetchPatientDetails();
        } else {
          // Handle failure response
          print('Failed to update oxygen values. Error: ${responseData?['message']}');
        }
      } else {
        // Handle HTTP error response
        print('Failed to update oxygen values. Error ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors, such as network issues
      print('Error: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _patientDetails.isNotEmpty
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  InkWell(
                    child: Icon(Icons.arrow_back_ios),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Patient Details',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Color(0xDBD9D9D9),
            ),
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatarWithName(
                      fullName: _patientDetails['patient_name'],
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _patientDetails['patient_name'],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '${_patientDetails['age']}, ${_patientDetails['gender']}',
                        style: TextStyle(
                          color: Color(0xFF787878),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Color(0xDBD9D9D9),
            ),
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Oxygen Concentrator Details',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Oxygen Flow Rate',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _patientDetails['oxygen_flow_rate'],
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFF3B82F6),
                          fontSize: 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _sliderValue ?? 0.0,
                    onChanged: (value) {
                      setState(() {
                        _sliderValue = value;
                        _updateOxygenValues(
                            _sliderValue!, _qualitySliderValue!, widget.recordedBy);
                      });
                    },
                    min: 0,
                    max: 100,
                    divisions: 10,
                    label: '$_sliderValue',
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Oxygen Quality Data',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _patientDetails['oxygen_quality_data'],
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xFF3B82F6),
                          fontSize: 24,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _qualitySliderValue ?? 0.0,
                    onChanged: (value) {
                      setState(() {
                        _qualitySliderValue = value;
                        _updateOxygenValues(
                            _sliderValue!, _qualitySliderValue!,widget.recordedBy);
                      });
                    },
                    min: 0,
                    max: 100,
                    divisions: 10,
                    label: '$_qualitySliderValue',
                  ),
                ],
              ),
            ),
          ],
        )
            : Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
