import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BackupService {
  static Future<void> exportDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'zouwar_station.db');
      final dbFile = File(path);

      if (await dbFile.exists()) {
        final appDocDir = await getApplicationDocumentsDirectory();
        final backupFile = await dbFile.copy(
          '${appDocDir.path}/zouwar_backup_${DateTime.now().millisecondsSinceEpoch}.db',
        );

        await Share.shareXFiles(
          [XFile(backupFile.path)],
          text: 'نسخة احتياطية من بيانات محطة الزوار - ${DateTime.now().toString()}',
          subject: 'Backup_Zouwar_Station',
        );

        print('✅ تم تصدير النسخة الاحتياطية بنجاح');
      } else {
        print('❌ قاعدة البيانات غير موجودة');
      }
    } catch (e) {
      print('❌ خطأ في التصدير: $e');
    }
  }

  static Future<void> importDatabase(File backupFile) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'zouwar_station.db');
      
      await deleteDatabase(path);
      await backupFile.copy(path);
      
      print('✅ تم استيراد النسخة الاحتياطية بنجاح');
    } catch (e) {
      print('❌ خطأ في الاستيراد: $e');
    }
  }
}