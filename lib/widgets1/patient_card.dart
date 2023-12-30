import 'package:flutter/material.dart';

class DynamicPatientCard extends StatelessWidget {
  final String name;
  final int age;
  final String gender;
  final double oxygenFlow;
  final double oxygenQuality;
  final String room_number;
  final VoidCallback? onTap;

  DynamicPatientCard({
    required this.name,
    required this.age,
    required this.gender,
    required this.oxygenFlow,
    required this.oxygenQuality,
    required this.room_number,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: 350,
          height: 160,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 0.88, color: Color(0xFFEAECF0)),
              borderRadius: BorderRadius.circular(8.79),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 61,
                  child: Container(
                    width: 350,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFFDFDFDF),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 175,
                  top: 61,
                  child: Transform(
                    transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(1.57),
                    child: Container(
                      width: 106,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: Color(0xFFDFDFDF),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 55,
                  top: 79,
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '$oxygenFlow%',
                          style: TextStyle(
                            color: Color(0xFFFB923C),
                            fontSize: 30,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Oxygen Flow',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 220,
                  top: 80,
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '$oxygenQuality%',
                          style: TextStyle(
                            color: Color(0xFF10B981),
                            fontSize: 30,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Oxygen Quality',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 22,
                  top: 7,
                  child: Text(
                    name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
                Positioned(
                  left: 22,
                  top: 35,
                  child: Text(
                    '$age, $gender',
                    style: TextStyle(
                      color: Color(0xFF787878),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
                Positioned(
                  left: 286,
                  top: 18,
                  child: Text(
                    '$room_number',
                    style: TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 22,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}
