import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Eczane Paneli'),
        backgroundColor: const Color(0xFFF48FB1),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _DashboardCard(
                    icon: Icons.add_circle_outline,
                    title: 'İlaç Ekle',
                    color: Colors.blue.shade600,
                    onTap: () => Navigator.pushNamed(context, '/add_medicine'),
                  ),
                  _DashboardCard(
                    icon: Icons.inventory_2_outlined,
                    title: 'Stok Listesi',
                    color: Colors.orange.shade600,
                    onTap: () => Navigator.pushNamed(context, '/stock_list'),
                  ),
                  _DashboardCard(
                    icon: Icons.qr_code_scanner,
                    title: 'Barkod Oku',
                    color: Colors.purple.shade600,
                    onTap: () => Navigator.pushNamed(context, '/scan'),
                  ),
                  _DashboardCard(
                    icon: Icons.notifications_active_outlined,
                    title: 'Uyarılar', // Can link to filtered list
                    color: Colors.red.shade600,
                    onTap: () => Navigator.pushNamed(context, '/alerts'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
