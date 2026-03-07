import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraReady = false;
  bool _isTakingPicture = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(_cameras![0], ResolutionPreset.medium);
      await _controller!.initialize();
      setState(() {
        _isCameraReady = true;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _capturePhoto() async {
    if (_controller != null && !_isTakingPicture) {
      setState(() {
        _isTakingPicture = true;
      });
      final image = await _controller!.takePicture();
      setState(() {
        _isTakingPicture = false;
      });
      // You can process the image or navigate to the next screen here
      Navigator.pop(context, image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            _isCameraReady && _controller != null
                ? CameraPreview(_controller!)
                : const Center(child: CircularProgressIndicator()),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(24),
                    backgroundColor: Colors.white,
                  ),
                  onPressed: _isCameraReady && !_isTakingPicture
                      ? _capturePhoto
                      : null,
                  child: Icon(Icons.camera_alt, color: Colors.black, size: 32),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
