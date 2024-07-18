// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import './event_qr_scanned_page.dart';
import './error_page.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              formatsAllowed: const [
                BarcodeFormat.qrcode,
              ],
              overlay: QrScannerOverlayShape(
                borderColor: Colors.deepOrange,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      // Handle the scanned result
      _navigateToEventDetails(scanData.code!);

      controller.pauseCamera();
    });
  }

  Future<bool> eventExists(String organizationId, String eventId) async {
    DocumentReference organizationRef = FirebaseFirestore.instance
        .collection('allOrganizations')
        .doc(organizationId)
        .collection('events')
        .doc(eventId);

    DocumentSnapshot snap = await organizationRef.get();

    return snap.exists;
  }

  void _navigateToEventDetails(String qrData) async {
    // Split the data to get organizationId and eventId
    final data = qrData.split('|');
    if (data.length == 2) {
      final String organizationId = data[0];
      final String eventId = data[1];

      // Check if the event exists
      bool isEventExists = await eventExists(organizationId, eventId);

      if (isEventExists) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => EventQRScannerPage(
              organizationId: organizationId,
              eventId: eventId,
            ),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ErrorPage(controller: controller!),
          ),
        );
      }
    } else {
      log('An error occurred while scanning the QR code',
          name: 'navigateToEventDetails');
    }
  }
}
