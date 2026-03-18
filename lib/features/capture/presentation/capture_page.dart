import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router/app_router.dart';
import '../../../core/models/template_model.dart';
import '../../../core/services/camera/camera_session_service.dart';

class CapturePage extends StatefulWidget {
  final String? selectedFrame;
  const CapturePage({super.key, this.selectedFrame});

  @override
  State<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends State<CapturePage> {
  final CameraSessionService _cameraSessionService = CameraSessionService.instance;
  CameraController? _cameraController;
  int _countdown = 5;
  Timer? _timer;
  bool _isCapturing = false;
  bool _showFlash = false;
  
  int _totalCaptures = 0;
  int _currentCaptureCount = 0;
  final List<String> _capturedImages = [];

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
    
    // Using the template model to automatically find how many pictures this frame requires!
    try {
      final template = appTemplates.firstWhere((t) => widget.selectedFrame!.contains(t.id));
      _totalCaptures = template.requiredPhotos;
    } catch (e) {
      _totalCaptures = 1; // Fallback
    }
  }

  Future<void> _initCamera() async {
    final controller = await _cameraSessionService.getOrCreateController();
    if (controller == null) {
      debugPrint('No available camera to initialize');
      return;
    }

    _cameraController = controller;
    if (_cameraController!.value.isPreviewPaused) {
      await _cameraController!.resumePreview();
    }

    if (mounted) {
      setState(() {});
      _startCountdown();
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
      _showFlash = true;
    });

    // Briefly flash the screen
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() {
          _showFlash = false;
        });
      }
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
        // ALL PHOTOS TAKEN: Navigate to Result Preview
        if (mounted) {
          // Temporarily paused auto-navigation to check UI
          context.goNamed(
            AppRoutes.resultPreview,
            extra: {
              'images': _capturedImages,
              'frame': widget.selectedFrame,
              'captureAspectRatio': _cameraController!.value.aspectRatio,
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
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      unawaited(_cameraController!.pausePreview());
    }
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
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.PNG'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Camera Feed
          Positioned(
            child: SizedBox(
              width: 450, // Set your desired width here; height will automatically adjust to prevent cropping!
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16), // Optional: rounds the corners of the smaller feed
                child: CameraPreview(_cameraController!),
              ),
            ),
          ),
          // Progress Text
          Align(
            alignment: Alignment.topCenter, 
            child: Padding(
              padding: const EdgeInsets.only(top: 280.0),
              child: Text(
                'กำลังถ่ายภาพ ${_currentCaptureCount + 1} / $_totalCaptures',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
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
            ),
            
          // Flash Overlay
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedOpacity(
                opacity: _showFlash ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: Container(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
