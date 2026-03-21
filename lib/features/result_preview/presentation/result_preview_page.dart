import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:screenshot/screenshot.dart';
import '../../../app/router/app_router.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'package:web/web.dart' as web;
import 'dart:js_interop';

class ResultPreviewPage extends StatefulWidget {
  final List<String> images;
  final double? captureAspectRatio;

  const ResultPreviewPage({
    super.key,
    required this.images,
    this.captureAspectRatio,
  });

  @override
  State<ResultPreviewPage> createState() => _ResultPreviewPageState();
}

class _ResultPreviewPageState extends State<ResultPreviewPage> {
  static const double _fixedPrintCropAspectRatio = 4 / 3;
  static const double _printHorizontalOffset = -12.0;
  static const double _minPrintCapturePixelRatio = 2.5;
  static const double _maxPrintCapturePixelRatio = 4.0;
  static const Duration _nextPageDelay = Duration(seconds: 6);

  final ScreenshotController screenshotController = ScreenshotController();
  bool isProcessing = false;
  bool _hasAutoTriggered = false;

  final TextEditingController _urlController = TextEditingController(
    text: 'https://karlee-unslatted-northeastwardly.ngrok-free.dev/print',
  );

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  double get _captureAspectRatio => _fixedPrintCropAspectRatio;

  double _resolvePrintCapturePixelRatio(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final targetRatio = kIsWeb ? 3.0 : devicePixelRatio * 2.0;
    return targetRatio
        .clamp(_minPrintCapturePixelRatio, _maxPrintCapturePixelRatio)
        .toDouble();
  }

  Widget _buildReceiptContent() {
    return Transform.translate(
      offset: const Offset(_printHorizontalOffset, 0),
      child: Container(
        width: 384,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(
                16.0,
                8.0,
                16.0,
                0.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TINY',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 46,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, right: 12.0),
                    child: Text(
                      'มาลองเต๊อะคราฟท์\n22/3/2026',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(
                16.0,
                0.0,
                16.0,
                0.0,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'PHOTOBOOTH',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 46,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(
                24.0,
                0,
                28.0,
                12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Receipt\nMemories\nHappiness',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '30.00 THB\n0.00 THB\n0.00 THB',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ...widget.images.map(_buildCroppedCapturedImage),
            const Padding(
              padding: EdgeInsets.fromLTRB(
                16.0,
                0.0,
                16.0,
                8,
              ),
              child: Text(
                '********************************',
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
            const SizedBox(height: 54),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCroppedCapturedImage(String imagePath) {
    final imageWidget = kIsWeb
        ? Image.network(
            imagePath,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          )
        : Image.file(
            File(imagePath),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          );

    return ColorFiltered(
      colorFilter: const ColorFilter.matrix([
        0.2126, 0.7152, 0.0722, 0,
        0, 0.2126, 0.7152,
        0.0722,
        0,
        0,
        0.2126,
        0.7152,
        0.0722,0,0,0,0,0,1,0,
      ]),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: SizedBox(
          width: 352,
          child: AspectRatio(
            aspectRatio: _captureAspectRatio,
            child: ClipRect(child: imageWidget),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _hasAutoTriggered) {
        return;
      }
      _hasAutoTriggered = true;
      _captureAndProceed();
    });
  }

  Future<void> _captureAndProceed() async {
    setState(() => isProcessing = true);
    try {
      final capturePixelRatio = _resolvePrintCapturePixelRatio(context);
      final Uint8List imageBytes = await screenshotController.captureFromLongWidget(
        Material(
          color: Colors.transparent,
          child: _buildReceiptContent(),
        ),
        context: context,
        delay: const Duration(milliseconds: 200),
        pixelRatio: capturePixelRatio,
      );

      if (!mounted) {
        return;
      }

      final String base64Image = base64Encode(imageBytes);
      final String serverUrl = _urlController.text.trim();

      final xhr = web.XMLHttpRequest();
      xhr.open('POST', serverUrl);
      xhr.setRequestHeader('Content-Type', 'application/json');
      xhr.setRequestHeader('ngrok-skip-browser-warning', 'true');
      xhr.setRequestHeader('x-pinggy-no-screen', 'true');

      final completer = Completer<int>();
      xhr.onload = (() => completer.complete(xhr.status)).toJS;
      xhr.onerror = (() => completer.completeError('XHR failed')).toJS;

      // Build serverBaseUrl correctly from the print URL
      final String serverBaseUrl = serverUrl.replaceAll('/print', '');
      xhr.send(jsonEncode({
      'image': base64Image,
      'serverUrl': serverBaseUrl,
      }).toJS);
      final status = await completer.future;

      if (!mounted) {
        return;
      }

      if (status != 200) {
  throw Exception('Server Error: $status');
}

// ✅ Read downloadUrl from server response
    final Map<String, dynamic> responseJson =
        jsonDecode(xhr.responseText) as Map<String, dynamic>;
    final String downloadUrl = (responseJson['downloadUrl'] as String?) ?? '';

    await Future<void>.delayed(_nextPageDelay);
    if (!mounted) return;

    context.goNamed(
      AppRoutes.resultDownloadQr,
      extra: {'downloadUrl': downloadUrl},
    );
    } catch (e) {
      debugPrint('Error while processing print flow: $e');
    } finally {
      if (mounted) {
        setState(() => isProcessing = false);
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
                clipBehavior: Clip.none,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.scale(
                      alignment: Alignment.center,
                      scale: 1,
                      child: Screenshot(
                        controller: screenshotController,
                        child: _buildReceiptContent(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (isProcessing)
              Container(
                color: Colors.black87,
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 24),
                      Text(
                        'Printing your photo...\nPlease wait',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
