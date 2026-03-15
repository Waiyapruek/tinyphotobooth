import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/app_router.dart';

class CapturePage extends StatefulWidget {
  final String? selectedFrame;
  const CapturePage({super.key, this.selectedFrame});

  @override
  State<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends State<CapturePage> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  int _countdown = 5;
  Timer? _timer;
  bool _isCapturing = false;
  
  int _totalCaptures = 0;
  int _currentCaptureCount = 0;
  List<String> _capturedImages = [];

  @override
  void initState() {
    super.initState();
    _determineCaptureCount();
    _initCamera();
  }
  
  void _determineCaptureCount() {
    if (widget.selectedFrame == null) {
      _totalCaptures = 1;
      return;
    }
    
    if (widget.selectedFrame!.contains('frame1')) {
      _totalCaptures = 2;
    } else if (widget.selectedFrame!.contains('frame2')) {
      _totalCaptures = 3;
    } else if (widget.selectedFrame!.contains('frame3')) {
      _totalCaptures = 4;
    } else {
      _totalCaptures = 1;
    }
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      final selectedCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first,
      );
      
      _cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      try {
        await _cameraController!.initialize();
      } catch (e) {
        debugPrint('Error initializing camera: $e');
        return;
      }
      
      if (mounted) {
        setState(() {});
        _startCountdown();
      }
    }
  }

  void _startCountdown() {
    _countdown = 5; // Reset before each
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 1) {
        timer.cancel();
        _capturePhoto();
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized || _isCapturing) {
      return;
    }
    setState(() {
      _isCapturing = true;
      _countdown = 0;
    });

    try {
      final XFile image = await _cameraController!.takePicture();
      _capturedImages.add(image.path);
      _currentCaptureCount++;
      
      if (_currentCaptureCount < _totalCaptures) {
        // Wait briefly, then start next countdown
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          setState(() {
            _isCapturing = false;
            _countdown = 5;
          });
          _startCountdown();
        }
      } else {
        // All captures done
        if (mounted) {
          context.goNamed(
            AppRoutes.resultPreview,
            extra: {
              'images': _capturedImages,
              'frame': widget.selectedFrame,
            },
          );
        }
      }
    } catch (e) {
      debugPrint('Error capturing photo: $e');
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Scaffold(
        body: Container(
        padding: const EdgeInsets.all(16.0),
        width: 1668,
        height: 2388,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.PNG'),
            fit: BoxFit.contain,
            onError: (exception, stackTrace) {
              // Fallback if image not found
            },
          ),
        ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Camera Feed
          Positioned.fill(
             child: Center(child: CameraPreview(_cameraController!)),
          ),
          
          // Progress text top left
          Positioned(
            top: 40,
            left: 20,
            child: Text(
              'Capture ${_currentCaptureCount + 1} / $_totalCaptures',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Countdown Text
          if (_countdown > 0)
            Positioned(
              child: Text(
                '$_countdown',
                style: const TextStyle(
                  fontSize: 120,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 4),
                      blurRadius: 10.0,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ),

          if (_isCapturing && _currentCaptureCount < _totalCaptures)
            const Positioned(
               child: CircularProgressIndicator(color: Colors.white),
            )
        ],
      ),
    ),
    );
  }
}
