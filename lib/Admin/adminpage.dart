import 'package:auth_demo/Admin/viewproduct/adminorderscreen.dart';
import 'package:auth_demo/auth/login.dart' show LoginPage;
import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color.fromRGBO(255, 109, 12, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.admin_panel_settings,
                size: 100, color: Colors.orange),
            const SizedBox(height: 20),
            const Text(
              'Welcome to the Admin Panel',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _buildAdminOption(
              context,
              icon: Icons.shopping_cart,
              label: 'View & Manage Orders',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminOrdersScreen()),
                );
              },
            ),
            const SizedBox(height: 10),
            _buildAdminOption(
              context,
              icon: Icons.inventory,
              label: 'Add, Edit, Delete Products',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductsPage()),
                );
              },
            ),
            const SizedBox(height: 10),
            _buildAdminOption(
              context,
              icon: Icons.people,
              label: 'Manage Users & Roles',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UsersPage()),
                );
              },
            ),
            const SizedBox(height: 10),
            _buildAdminOption(
              context,
              icon: Icons.bar_chart,
              label: 'View Reports & Analytics',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReportsPage()),
                );
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(255, 109, 12, 1),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.orange),
        title: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onTap: onTap,
      ),
    );
  }
}

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: const Color.fromRGBO(255, 109, 12, 1),
      ),
      body: const Center(
        child: Text('Products Page Content'),
      ),
    );
  }
}

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users & Roles'),
        backgroundColor: const Color.fromRGBO(255, 109, 12, 1),
      ),
      body: const Center(
        child: Text('Users & Roles Page Content'),
      ),
    );
  }
}

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        backgroundColor: const Color.fromRGBO(255, 109, 12, 1),
      ),
      body: const Center(
        child: Text('Reports & Analytics Page Content'),
      ),
    );
  }
}
