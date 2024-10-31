import 'package:flutter/material.dart';
//import 'campaign_detail.dart';

class ScanQR extends StatefulWidget {
  final String documentId;
  final String organizationId;

  const ScanQR(
      {super.key, required this.documentId, required this.organizationId});

  @override
  _ScanQRState createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: const Color.fromARGB(255, 17, 72, 84),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Displaying the QR code image
            Container(
              padding: EdgeInsets.all(18),
              width: 300,
              height: 300,
              child: Image.asset(
                'images/qr_cah.jpg',
                height: 200,
                width: 200,
              ),
            ),
            const SizedBox(height: 16), // Adds space between the image and text
            // Text(
            //   "QR Code for Campaign ${widget.documentId} from Organization ${widget.organizationId}",
            //   style: const TextStyle(fontSize: 16),
            //   textAlign: TextAlign.center,
            // ),
          ],
        ),
      ),
    );
  }
}
