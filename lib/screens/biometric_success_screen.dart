import 'package:flutter/material.dart';

class BiometricSuccessScreen extends StatefulWidget {
  const BiometricSuccessScreen({super.key});

  @override
  State<BiometricSuccessScreen> createState() => _BiometricSuccessScreenState();
}

class _BiometricSuccessScreenState extends State<BiometricSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Success'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 64, color: Color(0xFFFF5542)),
            const SizedBox(height: 24),
            const Text(
              'Biometric Added Successfully',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5542),
              ),
              child: const Text('Continue', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
