import '../services/printer/mock_thermal_printer_service.dart';
import '../services/printer/printer_service.dart';

class AppServices {
  AppServices._();

  static final AppServices instance = AppServices._();

  final PrinterService printerService = MockThermalPrinterService();
}
