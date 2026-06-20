import 'package:flutter/material.dart';
import 'add_sale_screen.dart';
import 'reports_screen.dart';
import 'start_shift_screen.dart';
import 'close_shift_screen.dart';
import 'tank_management_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('محطة الزوار للمشتقات النفطية'),
        centerTitle: true,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildButton(
              context,
              'بدء وردية جديدة',
              Icons.play_circle_filled,
              Colors.green,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StartShiftScreen()),
              ),
            ),
            _buildButton(
              context,
              'تسجيل مبيعات',
              Icons.shopping_cart,
              Colors.blue,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddSaleScreen()),
              ),
            ),
            _buildButton(
              context,
              'إدارة الخزانات',
              Icons.water_drop,
              Colors.orange,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TankManagementScreen()),
              ),
            ),
            _buildButton(
              context,
              'التقارير والرسوم البيانية',
              Icons.bar_chart,
              Colors.purple,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportsScreen()),
              ),
            ),
            _buildButton(
              context,
              'إغلاق الوردية',
              Icons.stop_circle_outlined,
              Colors.red,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CloseShiftScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 10)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}