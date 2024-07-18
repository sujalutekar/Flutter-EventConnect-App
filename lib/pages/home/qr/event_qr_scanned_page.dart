// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../method/get_current_user.dart';
import '../../../models/member.dart';

class EventQRScannerPage extends StatefulWidget {
  final String organizationId;
  final String eventId;

  const EventQRScannerPage({
    super.key,
    required this.organizationId,
    required this.eventId,
  });

  @override
  State<EventQRScannerPage> createState() => _EventQRScannerPageState();
}

class _EventQRScannerPageState extends State<EventQRScannerPage> {
  Future<void> scannedData({
    required String organizationId,
    required String eventId,
  }) async {
    try {
      Member currentUser = await getCurrentUserDetails();

      DocumentReference organizationRef = FirebaseFirestore.instance
          .collection('allOrganizations')
          .doc(organizationId)
          .collection('events')
          .doc(eventId);

      DocumentSnapshot snap = await organizationRef.get();

      List<dynamic> attendees = snap['attendees'];

      if (attendees.any((element) => element['uid'] == currentUser.uid)) {
        log('User already scanned');

        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have already scanned the QR code'),
          ),
        );
      } else {
        await organizationRef.update({
          'attendees': FieldValue.arrayUnion([currentUser.toMap()]),
        });
      }
    } catch (e) {
      log('Invalid Organization ID', name: 'scannedData');
      log(e.toString());
    }
  }

  @override
  void initState() {
    scannedData(
      organizationId: widget.organizationId,
      eventId: widget.eventId,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanned Data'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Organization ID: ${widget.organizationId}'),
            const SizedBox(height: 16),
            Text('Event ID: ${widget.eventId}'),
          ],
        ),
      ),
    );
  }
}
