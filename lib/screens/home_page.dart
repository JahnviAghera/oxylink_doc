import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled1/screens/email_verification_page.dart';
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
  @override
  void initState() {
    super.initState();
    _userData = [];
    _fetchUserData();
    _fetchPatientData();
  }
  Future<void> _fetchPatientData() async {
    final apiUrl = 'http://udhyog4.in/API/fetch_patient.php?doctorUserId=${widget.userId}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);

        setState(() {
          patients = responseData
              .map((patient) => Map<String, dynamic>.from(patient))
              .toList();
        });
        print(patients);
      } else {
        // Handle errors
        print('Failed to fetch patient data. Error ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors
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
        // Handle the error response
        // print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors
      print('Error: $error');
    }
  }

  Future<void> _refreshData() async {
    await _fetchUserData();
    await _fetchPatientData();
  }
var email;
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
            email=userData['email'];
            if(userData['email_verified']!=1){

            }
            if (userData['deleted'] != 0 && userData['email_verified']!=1) {
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
                              CircleAvatarWithName(fullName: userData['full_name']),
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
                            child: Icon(Icons.qr_code_scanner, size: 25,),
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
                              buildStatContainer('Patients', 20, Color(0xFFEFF6FF), Color(0xFF3B82F6), Icons.person),
                              Container(
                                child: Tooltip(
                                  message: 'Pending Prescription',
                                  child: buildStatContainer('Pending Prescript', 20, Color(0xFFFEF9C3), Color(0xFFFACC15), Icons.access_time),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          buildStatContainer('Critical Alerts', 2, Color(0xFFFEE2E2), Color(0xFFEF4444), Icons.person),
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
                      SizedBox(height: 12),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            DynamicPatientCard(name: 'Jhone Doe', age: 20, gender: 'Male', oxygenFlow: 16, oxygenQuality: 90, heartRate: 112),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: Text(
                    "User has been disabled"
                ),
              );
            }
          },
        ),
      ),
    );
  }
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                _navigateToEmailVerificationScreen(context,email);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToEmailVerificationScreen(BuildContext context, String email) {
    // Navigate to the email verification screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmailVerificationPage(email: email)),
    );
  }

}
