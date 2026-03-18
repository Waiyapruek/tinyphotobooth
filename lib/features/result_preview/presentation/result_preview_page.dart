import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import '../../../app/router/app_router.dart';
import '../../../core/services/printer/thermal_printer_service.dart';

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
  final ThermalPrinterService _printerService = ThermalPrinterService();
  
  // Add these missing variables
  final ScreenshotController screenshotController = ScreenshotController();
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Temporarily disabled for layout calibration preview!
    /*
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Small delay to ensure the images and layout are fully rendered on the screen
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _captureAndProceed();
      });
    });
    */
  }

  Future<void> _captureAndProceed() async {
    setState(() {
      isProcessing = true;
    });

    try {
      final directory = await getTemporaryDirectory();
      final String fileName = 'thermal_print_${DateTime.now().millisecondsSinceEpoch}.png';
      
      final String? path = await screenshotController.captureAndSave(
        directory.path,
        fileName: fileName,
        pixelRatio: 1.0, // <-- Add this to enforce exact 384px width output
        delay: const Duration(milliseconds: 100),
      );

      if (path != null && mounted) {
        // 1. Check if printer is connected
        bool isConnected = await _printerService.connect();
        
        if (isConnected) {
          // 2. Send the saved screenshot path to the printer!
          await _printerService.printImage(path);
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Printing successful!')),
          );
          
          // 3. Go back to home to restart the booth
          context.goNamed(AppRoutes.home); 
        } else {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Printer not connected!')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to print')),
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.PNG'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.scale(
                    alignment: Alignment.center, // Ensure scaling is centered
                    scale: widget.selectedFrame == 'frame1' ? 0.75 : 0.5, // 70% for frame1, otherwise 50%
                    child: Screenshot(
                      controller: screenshotController,
                      child: Container(
                      width: 384,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(48.0, 48.0, 48.0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left Side Header
                                Text(
                                  'TINY',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 42,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                // Right Side Header
                                Padding(
                                  padding: EdgeInsets.only(top: 10.0), // Adds space above to push it lower
                                  child: Text(
                                    'มาลองเต๊อะคราฟท์\nHands on x Rim Clong\n22/3/2026',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(48.0, 0.0, 48.0, 8),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'PHOTOBOOTH',
                                style: TextStyle(
                                  color: Colors.black, // Thermal printers only print black
                                  fontSize: 38,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(48.0, 0.0, 48.0, 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Left Side Header
                                Text(
                                  'Receipt\nMemories\nHappiness',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                // Right Side Header
                                Text(
                                  '30.00 THB\n0.00 THB\n0.00 THB',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          ...widget.images.map((img) => 
                            ColorFiltered(
                            colorFilter: const ColorFilter.matrix([
                              0.2126, 0.7152, 0.0722, 0, 0,
                              0.2126, 0.7152, 0.0722, 0, 0,
                              0.2126, 0.7152, 0.0722, 0, 0,
                              0,      0,      0,      1, 0,
                            ]), // High contrast grayscale conversion
                            child: Padding(
                              padding: const EdgeInsets.only(left: 48.0, right: 48.0, bottom: 16.0),
                              child: kIsWeb 
                                  ? Image.network(img, width: 288, fit: BoxFit.contain) 
                                  : Image.file(File(img), width: 288, fit: BoxFit.contain),
                            ),
                          )
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(48.0, 0.0, 48.0, 8),
                          child: Text(
                            '******************************',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Image(
                            image: AssetImage('assets/images/PageQR.png'),
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 32), // Padding for the thermal printer to cut the paper
                        ],
                      ),
                    ),
                  ),
                ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 48),
          // Retry Print Button hovering at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100), // Matched layout_confirm_page padding
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isProcessing ? null : _captureAndProceed,
                  borderRadius: BorderRadius.circular(90),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 18,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: isProcessing ? Colors.grey : const Color(0xFFFEF2D5),
                      borderRadius: BorderRadius.circular(90),
                      border: Border.all(
                        color: Colors.black,
                        width: 4,
                      ),
                    ),
                    child: Text(
                          'Retry Print',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                        ),
                    ),
                  ),
                ),
              ),
            ),
          if (isProcessing)
            Container(
              color: Colors.black87,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 24),
                    Text(
                      'Printing your photo...\nPlease wait',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    )
    );
  }
}