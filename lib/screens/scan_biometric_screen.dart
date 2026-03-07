import 'package:flutter/material.dart';
import 'biometric_success_screen.dart';
import 'qr_scanner_screen.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class ScanBiometricScreen extends StatelessWidget {
  const ScanBiometricScreen({super.key});

  Future<void> _linkFaceId(BuildContext context, String faceId) async {
    final auth = AuthService();
    final userService = UserService();

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Color(0xFFFF5542)),
        ),
      );

      final userId = await auth.getCurrentUserId();
      if (userId == null) {
        throw Exception('User not logged in');
      }

      final token = auth.getToken();
      if (token != null) {
        await userService.setAuthToken(token);
      }

      // Link face to user account
      await userService.linkFace(userId, faceId);

      // Close loading dialog
      if (context.mounted) {
        Navigator.pop(context);
      }

      // Navigate to success screen
      if (context.mounted) {
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BiometricSuccessScreen(),
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.pop(context);
      }

      // Show error
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to link face: ${e.toString()}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF0A1B5D),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              child: const Text(
                'Scan the QR Code to\nLink your Face',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Point your camera at the QR code to link this face.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QrScannerScreen(),
                  ),
                );

                if (result != null && result is Map<String, dynamic>) {
                  // Extract faceId from QR data
                  final faceId = result['faceId'] as String?;
                  if (faceId != null && context.mounted) {
                    await _linkFaceId(context, faceId);
                  }
                }
              },
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
                ),
                child: const Center(
                  child: Icon(
                    Icons.qr_code_scanner,
                    size: 80,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Make sure the code is inside the frame.',
              style: TextStyle(
                color: Color(0xFFFF5542),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5542),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Go back',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
