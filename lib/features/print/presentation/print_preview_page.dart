import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/di/service_locator.dart';

class PrintPreviewPage extends StatefulWidget {
  const PrintPreviewPage({super.key, required this.imagePath});

  final String? imagePath;

  @override
  State<PrintPreviewPage> createState() => _PrintPreviewPageState();
}

class _PrintPreviewPageState extends State<PrintPreviewPage> {
  bool _printing = false;

  Future<void> _print() async {
    final imagePath = widget.imagePath;
    if (imagePath == null) {
      return;
    }

    setState(() => _printing = true);

    final printer = AppServices.instance.printerService;
    try {
      final connected = await printer.connect();
      if (!connected) {
        throw StateError('Printer connection failed');
      }

      await printer.printImage(imagePath);

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sent to thermal printer.')),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Printing failed.')),
      );
    } finally {
      await printer.disconnect();
      if (mounted) {
        setState(() => _printing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = widget.imagePath;
    final hasImage = imagePath != null && imagePath.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Print Preview')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                alignment: Alignment.center,
                child: hasImage
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(imagePath),
                          fit: BoxFit.contain,
                        ),
                      )
                    : const Text('No image found. Please capture again.'),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: hasImage && !_printing ? _print : null,
              icon: const Icon(Icons.print_outlined),
              label: Text(_printing ? 'Printing...' : 'Print Receipt Photo'),
            ),
          ],
        ),
      ),
    );
  }
}
