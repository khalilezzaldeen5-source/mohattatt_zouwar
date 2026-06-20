import 'package:flutter/material.dart';
import 'helpers/db_helper.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.instance.database;
  runApp(const ZouwarStationApp());
}

class ZouwarStationApp extends StatelessWidget {
  const ZouwarStationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'محطة الزوار للمشتقات النفطية',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}