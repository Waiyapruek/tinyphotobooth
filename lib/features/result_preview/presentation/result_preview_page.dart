import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import '../../../app/router/app_router.dart';

class ResultPreviewPage extends StatefulWidget {
  final List<String> images;
  final String? selectedFrame;

  const ResultPreviewPage({
    super.key,
    required this.images,
    this.selectedFrame,
  });

  @override
  State<ResultPreviewPage> createState() => _ResultPreviewPageState();
}

class _ResultPreviewPageState extends State<ResultPreviewPage> {
  final ScreenshotController screenshotController = ScreenshotController();
  bool isProcessing = false;

  Future<void> _captureAndProceed() async {
    setState(() {
      isProcessing = true;
    });

    try {
      final directory = await getTemporaryDirectory();
      final String fileName = 'thermal_print_.png';
      
      final String? path = await screenshotController.captureAndSave(
        directory.path,
        fileName: fileName,
        delay: const Duration(milliseconds: 100),
      );

      if (path != null && mounted) {
        // Send the captured combined image to print preview or next step
        context.goNamed(AppRoutes.printPreview, extra: path);
      }
    } catch (e) {
      debugPrint('Error capturing screenshot: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate print layout')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Result Preview'),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // This is the custom layout widget that will be captured
                  Screenshot(
                    controller: screenshotController,
                    child: Container(
                      width: 384, // Thermal printer typical width (80mm) approx
                      color: Colors.white,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header for thermal print
                          Text(
                            'RECEIPT BOOTH',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Display photos based on the amount
                          ...widget.images.map((imagePath) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Image.file(
                                File(imagePath),
                                width: 340,
                                fit: BoxFit.cover,
                                // Assuming grayscale for thermal printer
                                color: Colors.black,
                                colorBlendMode: BlendMode.saturation,
                              ),
                            );
                          }).toList(),

                          const SizedBox(height: 16),
                          // Footer
                          Text(
                            DateTime.now().toString().split('.')[0],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Thank you!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton.icon(
                    onPressed: isProcessing ? null : _captureAndProceed,
                    icon: const Icon(Icons.print),
                    label: const Text('Print Now'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
          if (isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
