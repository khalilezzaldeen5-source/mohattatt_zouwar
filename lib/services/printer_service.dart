import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class PrinterService {
  static Future<bool> checkBluetoothPermission() async {
    try {
      bool isConnected = await PrintBluetoothThermal.connectionStatus;
      return isConnected;
    } catch (e) {
      print('خطأ في الاتصال بالطابعة: $e');
      return false;
    }
  }

  static Future<void> printReceipt(String content) async {
    try {
      bool isConnected = await PrintBluetoothThermal.connectionStatus;
      
      if (isConnected) {
        await PrintBluetoothThermal.writeText(content);
        await PrintBluetoothThermal.printNewLine();
        print('✅ تمت الطباعة بنجاح');
      } else {
        print('❌ الطابعة غير متصلة');
      }
    } catch (e) {
      print('❌ خطأ في الطباعة: $e');
    }
  }

  static Future<void> connectPrinter(String printerAddress) async {
    try {
      await PrintBluetoothThermal.connect(printerAddress);
      print('✅ تم الاتصال بالطابعة');
    } catch (e) {
      print('❌ خطأ في الاتصال: $e');
    }
  }

  static Future<void> disconnectPrinter() async {
    try {
      await PrintBluetoothThermal.disconnect();
      print('✅ تم قطع الاتصال بالطابعة');
    } catch (e) {
      print('❌ خطأ في قطع الاتصال: $e');
    }
  }
}