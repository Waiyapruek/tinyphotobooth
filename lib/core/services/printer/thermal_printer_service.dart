import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'printer_service.dart';

class ThermalPrinterService implements PrinterService {
  @override
  Future<bool> connect() async {
    // Note: In a full app, you should scan for devices and let the user pick one.
    // This checks if we are already connected to a paired Bluetooth printer.
    try {
      final bool isConnected = await PrintBluetoothThermal.connectionStatus;
      return isConnected;
    } catch (e) {
      debugPrint("Bluetooth Connection Error: $e");
      return false;
    }
  }

  @override
  Future<void> printImage(String imagePath) async {
    try {
      // 1. Read the screenshot image file from the path
      final File imageFile = File(imagePath);
      final bytes = await imageFile.readAsBytes();
      
      // 2. Decode the image
      final img.Image? originalImage = img.decodeImage(bytes);
      if (originalImage == null) throw Exception("Could not decode image");

      // 3. Resize to fit 58mm printer (384 dots width)
      // The esc_pos_utils_plus package will automatically handle dithering!
      final img.Image resizedImage = img.copyResize(originalImage, width: 384);

      // 4. Generate ESC/POS commands
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm58, profile);
      
      List<int> printBytes = [];
      
      // Add the image, feed the paper a bit, and cut it
      printBytes += generator.image(resizedImage);
      printBytes += generator.feed(2);
      printBytes += generator.cut();

      // 5. Send to printer
      await PrintBluetoothThermal.writeBytes(printBytes);
      
    } catch (e) {
      debugPrint("Print Error: $e");
      throw Exception("Failed to print: $e");
    }
  }

  @override
  Future<void> disconnect() async {
    await PrintBluetoothThermal.disconnect;
  }
}