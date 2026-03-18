import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class CameraSessionService {
  CameraSessionService._();

  static final CameraSessionService instance = CameraSessionService._();

  CameraController? _controller;
  Future<CameraController?>? _initializingController;
  List<CameraDescription>? _cachedCameras;

  Future<CameraController?> getOrCreateController() async {
    final controller = _controller;
    if (controller != null && controller.value.isInitialized) {
      return controller;
    }

    if (_initializingController != null) {
      return _initializingController!;
    }

    _initializingController = _initializeController();
    final initializedController = await _initializingController;
    _initializingController = null;
    return initializedController;
  }

  Future<CameraController?> _initializeController() async {
    try {
      _cachedCameras ??= await availableCameras();
      if (_cachedCameras == null || _cachedCameras!.isEmpty) {
        return null;
      }

      final selectedCamera = _cachedCameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cachedCameras!.first,
      );

      final controller = CameraController(
        selectedCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller.initialize();
      _controller = controller;
      return controller;
    } catch (e) {
      debugPrint('Error creating camera session: $e');
      return null;
    }
  }

  Future<void> disposeController() async {
    final controller = _controller;
    _controller = null;
    _cachedCameras = null;
    if (controller != null) {
      await controller.dispose();
    }
  }
}
