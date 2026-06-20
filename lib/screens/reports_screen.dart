import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../helpers/db_helper.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<Map<String, dynamic>> _summary = [];
  List<Map<String, dynamic>> _monthlySales = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final summary = await DBHelper.instance.getSalesSummary();
    final monthly = await DBHelper.instance.getMonthlySales();
    setState(() {
      _summary = summary;
      _monthlySales = monthly;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التقارير والإحصائيات')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('ملخص المبيعات الحالي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildSummaryCards(),
              const SizedBox(height: 30),
              const Text('الرسم البياني الشهري', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return _summary.isEmpty
        ? const Center(child: Text('لا توجد مبيعات بعد'))
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _summary.length,
            itemBuilder: (context, index) {
              final item = _summary[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(item['type'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: Text('${item['total']} ريال', style: const TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold)),
                ),
              );
            },
          );
  }

  Widget _buildChart() {
    if (_monthlySales.isEmpty) {
      return const Center(child: Text('لا توجد بيانات شهرية'));
    }

    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < _monthlySales.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: (_monthlySales[i]['total'] as num).toDouble(),
              color: Colors.blue,
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(_monthlySales[value.toInt()]['month'] ?? ''),
              ),
            ),
          ),
        ),
      ),
    );
  }
}