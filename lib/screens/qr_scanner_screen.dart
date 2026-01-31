import 'package:flutter/material.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.qr_code_2, size: 64, color: Color(0xFFFF5542)),
            const SizedBox(height: 24),
            const Text(
              'QR Scanner',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, {
                'faceId': 'mock_face_id_123',
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5542),
              ),
              child: const Text('Scan', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
