import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ErrorPage extends StatelessWidget {
  final QRViewController controller;

  const ErrorPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Invalid QR code'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();

                controller.resumeCamera();
              },
              child: const Text('Scan Again'),
            ),
          ],
        ),
      ),
    );
  }
}
