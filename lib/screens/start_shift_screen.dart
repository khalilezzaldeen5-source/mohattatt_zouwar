import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';

class StartShiftScreen extends StatefulWidget {
  const StartShiftScreen({super.key});

  @override
  State<StartShiftScreen> createState() => _StartShiftScreenState();
}

class _StartShiftScreenState extends State<StartShiftScreen> {
  final _cashController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('بدء وردية جديدة')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'أدخل العهدة (رصيد البداية)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _cashController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'المبلغ (ريال يمني)',
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () async {
                if (_cashController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('أدخل المبلغ أولاً')),
                  );
                  return;
                }
                double amount = double.parse(_cashController.text);
                await DBHelper.instance.startShift(amount);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم فتح الوردية بنجاح!')),
                  );
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.check_circle),
              label: const Text('فتح الوردية الآن'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}