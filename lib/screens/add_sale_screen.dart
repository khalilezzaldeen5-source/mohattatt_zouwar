import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';

class AddSaleScreen extends StatefulWidget {
  const AddSaleScreen({super.key});

  @override
  State<AddSaleScreen> createState() => _AddSaleScreenState();
}

class _AddSaleScreenState extends State<AddSaleScreen> {
  final _amountController = TextEditingController();
  String _selectedType = 'بنزين';
  String _selectedPump = '1';
  int? _activeShiftId;

  final List<String> _types = ['بنزين', 'ديزل', 'بقالة'];
  final List<String> _pumps = ['1', '2'];

  @override
  void initState() {
    super.initState();
    _loadActiveShift();
  }

  void _loadActiveShift() async {
    final shift = await DBHelper.instance.getActiveShift();
    if (shift != null) {
      setState(() => _activeShiftId = shift['id']);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا توجد وردية مفتوحة! ابدأ وردية أولاً')),
      );
    }
  }

  void _saveSale() async {
    if (_amountController.text.isEmpty || _activeShiftId == null) return;

    Map<String, dynamic> row = {
      'shiftId': _activeShiftId,
      'type': _selectedType,
      'pumpNumber': int.parse(_selectedPump),
      'amount': double.parse(_amountController.text),
      'createdAt': DateTime.now().toString(),
    };

    await DBHelper.instance.insertSale(row);
    
    if (_selectedType != 'بقالة') {
      int tankId = (_selectedType == 'بنزين' ? 1 : 3) + int.parse(_selectedPump) - 1;
      double liters = double.parse(_amountController.text) / 600;
      await DBHelper.instance.updateTankLevel(tankId, liters);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ البيع بنجاح!')),
    );
    _amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل المبيعات')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField(
              value: _selectedType,
              items: _types.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
              onChanged: (val) => setState(() => _selectedType = val.toString()),
              decoration: const InputDecoration(labelText: 'نوع المنتج'),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField(
              value: _selectedPump,
              items: _pumps.map((p) => DropdownMenuItem(value: p, child: Text('مضخة $p'))).toList(),
              onChanged: (val) => setState(() => _selectedPump = val.toString()),
              decoration: const InputDecoration(labelText: 'رقم المضخة'),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'المبلغ (ريال يمني)'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveSale,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('حفظ العملية'),
            ),
          ],
        ),
      ),
    );
  }
}