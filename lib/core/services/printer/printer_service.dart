abstract class PrinterService {
  Future<bool> connect();
  Future<void> printImage(String imagePath);
  Future<void> disconnect();
}
