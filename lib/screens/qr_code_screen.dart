import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';

class QRCodeScreen extends StatelessWidget {
  final String userId;

  QRCodeScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BarcodeWidget(
              barcode: Barcode.qrCode(),
              data: userId,
              width: 200,
              height: 200,
              color: Colors.black,
              margin: EdgeInsets.all(10),
            ),
            SizedBox(height: 20),
            // Text(
            //   'User ID: $userId',
            //   style: TextStyle(fontSize: 18),
            // ),
          ],
        ),
      ),
    );
  }
}
