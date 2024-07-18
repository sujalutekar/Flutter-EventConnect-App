import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodePage extends StatelessWidget {
  final String orgId;
  final String eId;
  final String eventName;

  const QRCodePage({
    super.key,
    required this.orgId,
    required this.eId,
    required this.eventName,
  });

  @override
  Widget build(BuildContext context) {
    String organizationId = orgId;
    String eventId = eId;

    String qrData = '$organizationId|$eventId';

    return Scaffold(
      appBar: AppBar(
        title: Text('$eventName QR'),
      ),
      body: Center(
        child: QrImageView(
          data: qrData,
          version: QrVersions.auto,
          size: 300,
          // ignore: deprecated_member_use
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
