import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';

class CloseShiftScreen extends StatefulWidget {
  const CloseShiftScreen({super.key});

  @override
  State<CloseShiftScreen> createState() => _CloseShiftScreenState();
}

class _CloseShiftScreenState extends State<CloseShiftScreen> {
  Map<String, dynamic>? _activeShift;
  double _totalSales = 0;
  double _totalExpenses = 0;
  final _actualCashController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadShiftData();
  }

  void _loadShiftData() async {
    final shift = await DBHelper.instance.getActiveShift();
    if (shift != null) {
      double sales = await DBHelper.instance.getSalesTotalForShift(shift['id']);
      double expenses = await DBHelper.instance.getExpensesTotalForShift(shift['id']);
      setState(() {
        _activeShift = shift;
        _totalSales = sales;
        _totalExpenses = expenses;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_activeShift == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('إغلاق الوردية')),
        body: const Center(child: Text('لا توجد وردية مفتوحة')),
      );
    }

    double expectedCash = (_activeShift!['openingCash'] as num).toDouble() + _totalSales - _totalExpenses;

    return Scaffold(
      appBar: AppBar(title: const Text('تصفية الوردية')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('العهدة البدائية: ${_activeShift!['openingCash']} ريال'),
                    const SizedBox(height: 10),
                    Text('إجمالي المبيعات: $_totalSales ريال'),
                    const SizedBox(height: 10),
                    Text('إجمالي المصروفات: $_totalExpenses ريال'),
                    const Divider(),
                    Text(
                      'المبلغ المتوقع: $expectedCash ريال',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _actualCashController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'المبلغ الفعلي الموجود الآن'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                double actual = double.parse(_actualCashController.text);
                double diff = actual - expectedCash;

                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(diff == 0 ? '✅ مطابقة تامة' : '⚠️ فارق حسابي'),
                    content: Text('الفرق: $diff ريال'),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          await DBHelper.instance.closeShift(_activeShift!['id'], actual);
                          if (mounted) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم إغلاق الوردية بنجاح')),
                            );
                          }
                        },
                        child: const Text('تأكيد الإغلاق'),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('إغلاق الوردية'),
            ),
          ],
        ),
      ),
    );
  }
}