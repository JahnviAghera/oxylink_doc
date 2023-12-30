import 'package:flutter/material.dart';

Widget buildStatContainer(String title, int count,Color bg, Color iconColor, IconData iconData) {
  return Container(
    width: 164,
    height: 63,
    clipBehavior: Clip.antiAlias,
    decoration: ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 0.88, color: Color(0xFFEAECF0)),
        borderRadius: BorderRadius.circular(8.79),
      ),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 35.16,
            height: 35.16,
            padding: const EdgeInsets.only(
              top: 5.93,
              left: 5.21,
              right: 5.96,
              bottom: 5.23,
            ),
            decoration: ShapeDecoration(
              color: bg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17.58),
              ),
            ),
            child: Icon(
              iconData,
              color: iconColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xFF667084),
                    fontSize: 10.55,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  count.toString(),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: iconColor,
                    fontSize: 21.10,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0.06,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
