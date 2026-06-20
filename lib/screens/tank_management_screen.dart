import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';

class TankManagementScreen extends StatefulWidget {
  const TankManagementScreen({super.key});

  @override
  State<TankManagementScreen> createState() => _TankManagementScreenState();
}

class _TankManagementScreenState extends State<TankManagementScreen> {
  List<Map<String, dynamic>> _tanks = [];
  final _nameController = TextEditingController();
  final _capacityController = TextEditingController();
  final _levelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTanks();
  }

  void _loadTanks() async {
    final tanks = await DBHelper.instance.getAllTanks();
    setState(() => _tanks = tanks);
  }

  void _addTank() async {
    if (_nameController.text.isEmpty || _capacityController.text.isEmpty) return;

    await DBHelper.instance.insertTank({
      'name': _nameController.text,
      'capacity': double.parse(_capacityController.text),
      'currentLevel': double.parse(_levelController.text),
    });

    _nameController.clear();
    _capacityController.clear();
    _levelController.clear();
    _loadTanks();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إضافة الخزان بنجاح')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة خزانات الوقود')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'اسم الخزان'),
                ),
                TextField(
                  controller: _capacityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'السعة الكلية (لتر)'),
                ),
                TextField(
                  controller: _levelController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'المستوى الحالي (لتر)'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addTank,
                  child: const Text('إضافة خزان'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tanks.length,
              itemBuilder: (context, index) {
                final tank = _tanks[index];
                double percentage = (tank['currentLevel'] / tank['capacity']) * 100;
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(tank['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('المستوى: ${tank['currentLevel']}/${tank['capacity']} لتر'),
                        LinearProgressIndicator(value: percentage / 100),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}