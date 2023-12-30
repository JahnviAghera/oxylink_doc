import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets1/profile_avtar.dart';

class UserInfoPage extends StatefulWidget {
  final String userId;

  UserInfoPage({required this.userId});

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  List<Map<String, dynamic>> _userData = [];
  bool _isLoading = true; // Add a loading indicator

  @override
  void initState() {
    super.initState();
    _fetchUserData();
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
            _isLoading = false; // Set loading to false when data is loaded
          });
          print(_userData);
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

  Future<void> _refresh() async {
    setState(() {
      _isLoading = true; // Set loading to true when refreshing
    });
    await _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loader
          : RefreshIndicator(
        onRefresh: _refresh,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                  EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            child: Icon(Icons.arrow_back_ios),
                            onTap: () {
                              // Implement navigation to the previous screen
                              Navigator.of(context).pop();
                            },
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Edit Doctor Information',
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
                      // Text(
                      //   'Edit',
                      //   style: TextStyle(
                      //     color: Color(0xFF397AD1),
                      //     fontSize: 16,
                      //     fontFamily: 'Inter',
                      //     fontWeight: FontWeight.w400,
                      //     height: 0,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Container(
                  width: 390,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0xDBD9D9D9),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        child: CircleAvatarWithName(
                          fullName: _userData.isNotEmpty
                              ? _userData[0]['full_name'] ?? 'Unknown'
                              : 'Unknown',
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _userData[0]['full_name'],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            _userData[0]['specialization'],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 390,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0xDBD9D9D9),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contact Information',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _userData[0]['email'],
                        style: TextStyle(
                          color: Color(0xFF070707),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _userData[0]['phone_number'],
                        style: TextStyle(
                          color: Color(0xFF070707),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                      InkWell(
                        child: Row(
                          children: [
                            Icon(Icons.arrow_back_outlined,
                                color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 3,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
