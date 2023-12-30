import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled1/screens/email_verification_page.dart';
import 'package:untitled1/screens/patient_detail_page.dart';
import 'package:untitled1/screens/qr_code_screen.dart';
import 'package:untitled1/screens/user_info.dart';
import 'package:untitled1/widgets1/dynamic_built_stat.dart';
import 'package:untitled1/widgets1/patient_card.dart';
import 'package:untitled1/widgets1/profile_avtar.dart';

class HomePage extends StatefulWidget {
  final String userId;

  const HomePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Map<String, dynamic>> _userData;
  List<Map<String, dynamic>> patients = [];
  var index;
  var email;

  @override
  void initState() {
    super.initState();
    _userData = [];
    _fetchUserData();
    _fetchPatientData();
    _fetchPatientData().then((_) {
      _calculateCriticalPatients();
      _calculateTotalPatients();
    });
  }

  Future<void> _fetchPatientData() async {
    final apiUrl =
        'http://udhyog4.in/API/fetch_patient.php?doctor_user_id=${widget.userId}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          final List<dynamic> patientList = responseData['patients'];

          if (patientList != null && patientList is List) {
            setState(() {
              patients = patientList
                  .map((patient) => Map<String, dynamic>.from(patient))
                  .toList();
              _calculateTotalPatients(); // Call _calculateTotalPatients after setting the patient list
            });
            print(patients.length);
            print('Response: $patients');
          } else {
            print('Invalid patient list in API response');
          }
        } else {
          print('Failed to fetch patient data. Error: ${responseData['message']}');
        }
      } else {
        print('Failed to fetch patient data. Error ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _fetchUserData() async {
    final apiUrl = 'http://udhyog4.in/API/fetch.php?userid=${widget.userId}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('Response: $data');

        if (data['status'] == 'success') {
          final List<Map<String, dynamic>> userDataList = [data['user']];
          setState(() {
            _userData = userDataList;
          });
        } else {
          print('Data fetch failed. Server message: ${data['message']}');
        }
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _refreshData() async {
    await _fetchUserData();
    await _fetchPatientData();
    _fetchPatientData().then((_) {
      _calculateCriticalPatients();
      _calculateTotalPatients();
    });
  }

  int _calculateCriticalPatients() {
    return patients.where((patient) {
      double oxygenFlow = (patient['oxygen_flow_rate'] is double)
          ? patient['oxygen_flow_rate']
          : double.tryParse(patient['oxygen_flow_rate'] ?? '0.0') ?? 0.0;

      double oxygenQuality = (patient['oxygen_quality_data'] is double)
          ? patient['oxygen_quality_data']
          : double.tryParse(patient['oxygen_quality_data'] ?? '0.0') ?? 0.0;

      // Your conditions to determine if a patient is critical
      return oxygenFlow < 50.0 || oxygenQuality < 50.0;
    }).length;
  }

  int _calculateTotalPatients() {
    return patients.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView.builder(
          itemCount: _userData.length,
          itemBuilder: (context, index) {
            final userData = _userData[index];
            email = userData['email'];
            if (userData['email_verified'] == 1) {
              // Use WidgetsBinding to schedule a callback after the frame is built
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                _showConfirmationDialog(context, email);
              });
            }
            if (userData['deleted'] != 0 && userData['email_verified'] != 1) {
              return SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                child: CircleAvatarWithName(
                                    fullName: userData['full_name']),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UserInfoPage(userId: userData['user_id']),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: 20),
                              Text(
                                userData['full_name'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            child: Icon(
                              Icons.qr_code_scanner,
                              size: 25,
                            ),
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QRCodeScreen(userId: userData['user_id']),
                                ),
                              );

                            },
                          )
                        ],
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: 390,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 0.5,
                              strokeAlign: BorderSide.strokeAlignCenter,
                              color: Color(0xDBD9D9D9),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildStatContainer('Patients', _calculateTotalPatients(), Color(0xFFEFF6FF),
                                  Color(0xFF3B82F6), Icons.person),
                              buildStatContainer('Critical Alerts', _calculateCriticalPatients(),
                                  Color(0xFFFEE2E2), Color(0xFFEF4444),
                                  Icons.person),
                              // Container(
                              //   child: Tooltip(
                              //     message: 'Pending Prescription',
                              //     child: buildStatContainer('Pending Prescript', 20,
                              //         Color(0xFFFEF9C3), Color(0xFFFACC15),
                              //         Icons.access_time),
                              //   ),
                              // ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: 390,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 0.5,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                  color: Color(0xDBD9D9D9),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          // Displaying patient data using ListView.builder
                          // Displaying patient data using ListView.builder
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: patients.length,
                            itemBuilder: (context, index) {
                              final patient = patients[index];
                              return Column(
                                children: [
                                  SizedBox(height: 8),
                                  DynamicPatientCard(
                                    name: patient['patient_name'] ?? 'Unknown',
                                    age: (patient['age'] is int)
                                        ? patient['age']
                                        : int.tryParse(patient['age'] ?? '0') ?? 0,
                                    gender: patient['gender'] ?? 'Unknown',
                                    oxygenFlow: (patient['oxygen_flow_rate'] is double)
                                        ? patient['oxygen_flow_rate']
                                        : double.tryParse(patient['oxygen_flow_rate'] ?? '0.0') ?? 0.0,
                                    oxygenQuality: (patient['oxygen_quality_data'] is double)
                                        ? patient['oxygen_quality_data']
                                        : double.tryParse(patient['oxygen_quality_data'] ?? '0.0') ?? 0.0,
                                    room_number: patient['room_number'] ?? '0',
                                    onTap: () {
                                      _openPatientDetailsPage(
                                          context, patient['patient_id'],userData['username']);
                                    },
                                  ),
                                  SizedBox(height: 8),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: Text("User has been disabled"),
              );
            }
          },
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, String email) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Email Confirmation'),
            content: Text('Please confirm your email address to proceed.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  _navigateToEmailVerificationScreen(context, email);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }

  void _navigateToEmailVerificationScreen(
      BuildContext context, String email) {
    // Navigate to the email verification screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmailVerificationPage(email: email),
      ),
    );
  }

  void _openPatientDetailsPage(BuildContext context, String patientId,String user_name) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientDetailsPage(patientId: patientId,recordedBy:user_name),
      ),
    );
  }
}
