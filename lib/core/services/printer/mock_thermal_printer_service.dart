import 'dart:async';

import 'printer_service.dart';

class MockThermalPrinterService implements PrinterService {
  bool _connected = false;

  @override
  Future<bool> connect() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    _connected = true;
    return _connected;
  }

  @override
  Future<void> printImage(String imagePath) async {
    if (!_connected) {
      throw StateError('Printer is not connected');
    }

    // Simulate image rasterization + print transfer to a thermal device.
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> disconnect() async {
    _connected = false;
  }
}
