import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        children: [
          _buildDashboardItem(
            context,
            icon: Icons.store,
            title: 'Products',
            count: '42',
            color: Colors.purple,
          ),
          _buildDashboardItem(
            context,
            icon: Icons.people,
            title: 'Users',
            count: '128',
            color: Colors.blue,
          ),
          _buildDashboardItem(
            context,
            icon: Icons.shopping_cart,
            title: 'Orders',
            count: '56',
            color: Colors.green,
          ),
          _buildDashboardItem(
            context,
            icon: Icons.attach_money,
            title: 'Revenue',
            count: '\$2,450',
            color: Colors.orange,
          ),
          _buildDashboardItem(
            context,
            icon: Icons.chat,
            title: 'Messages',
            count: '12',
            color: Colors.red,
          ),
          _buildDashboardItem(
            context,
            icon: Icons.settings,
            title: 'Settings',
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        String? count,
        required Color color,
      }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 30, color: color),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (count != null) ...[
                const SizedBox(height: 5),
                Text(
                  count,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}