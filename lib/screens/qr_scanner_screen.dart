import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _ScannerOverlayPainter extends CustomPainter {
  final double scanAreaSize;
  final double borderRadius;

  _ScannerOverlayPainter({
    required this.scanAreaSize,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double left = (size.width - scanAreaSize) / 2;
    final double top = (size.height - scanAreaSize) / 2;
    final double right = left + scanAreaSize;
    final double bottom = top + scanAreaSize;

    // Create the overlay paint
    final Paint overlayPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Create the scan area rounded rectangle
    final RRect scanArea = RRect.fromLTRBR(
      left,
      top,
      right,
      bottom,
      Radius.circular(borderRadius),
    );

    // Create path for the overlay with cutout
    final Path overlayPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(scanArea)
      ..fillType = PathFillType.evenOdd;

    // Draw the overlay
    canvas.drawPath(overlayPath, overlayPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool isScanning = true;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleQRCode(String qrData) {
    if (!isScanning) return;

    setState(() {
      isScanning = false;
    });

    try {
      final data = jsonDecode(qrData);

      // Validate QR code type
      if (data['type'] != 'face_enrollment') {
        _showError('Invalid QR code. Please scan a face enrollment QR code.');
        return;
      }

      // Extract face enrollment data
      final String faceId = data['faceId'];
      final String merchantId = data['merchantId'];
      final String sessionToken = data['sessionToken'];
      final String timestamp = data['timestamp'];

      // Return the face enrollment data to the previous screen
      Navigator.pop(context, {
        'faceId': faceId,
        'merchantId': merchantId,
        'sessionToken': sessionToken,
        'timestamp': timestamp,
      });
    } catch (e) {
      _showError('Invalid QR code format. Please try again.');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                isScanning = true;
              });
            },
            child: const Text('Try Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close scanner
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // QR Scanner View
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  _handleQRCode(barcode.rawValue!);
                  break;
                }
              }
            },
          ),

          // Scanner overlay with CustomPaint
          CustomPaint(
            painter: _ScannerOverlayPainter(
              scanAreaSize: MediaQuery.of(context).size.width * 0.75,
              borderRadius: 16,
            ),
            child: Container(),
          ),

          // Scan area border
          Center(
            child: Container(
              margin: const EdgeInsets.all(40),
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.width * 0.75,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFFF5542), width: 3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  // Corner decorations
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Color(0xFFFF5542), width: 6),
                          left: BorderSide(color: Color(0xFFFF5542), width: 6),
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Color(0xFFFF5542), width: 6),
                          right: BorderSide(color: Color(0xFFFF5542), width: 6),
                        ),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFFF5542),
                            width: 6,
                          ),
                          left: BorderSide(color: Color(0xFFFF5542), width: 6),
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFFF5542),
                            width: 6,
                          ),
                          right: BorderSide(color: Color(0xFFFF5542), width: 6),
                        ),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Top bar with back button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Scan QR Code',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Instructions at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.9),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.qr_code_scanner,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Position the QR code within the frame',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The QR code will be scanned automatically',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
