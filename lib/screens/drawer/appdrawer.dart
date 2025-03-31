import 'dart:io';
import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  final String? username;
  final String email;
  final String? profilePicturePath; // Path to locally saved image
  final String? profilePictureUrl; // URL of remote image
  final VoidCallback onLogout;

  const AppDrawer({
    Key? key,
    this.username,
    required this.email,
    this.profilePicturePath,
    this.profilePictureUrl,
    required this.onLogout,
  }) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          _buildDrawerItem(
            icon: Icons.home,
            text: 'Home',
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          _buildDrawerItem(
            icon: Icons.restaurant_menu,
            text: 'Menu',
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushNamed(context, '/menu');
            },
          ),
          _buildDrawerItem(
            icon: Icons.receipt_long,
            text: 'Order',
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushNamed(context, '/order');
            },
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            text: 'Settings',
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushNamed(context, '/settings');
            },
          ),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.logout,
            text: 'Logout',
            onTap: () {
              Navigator.pop(context); // Close the drawer before logout
              widget.onLogout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: const BoxDecoration(
        color: Colors.orange,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            backgroundImage: widget.profilePicturePath != null
                ? FileImage(File(widget.profilePicturePath!))
                    as ImageProvider<Object>?
                : widget.profilePictureUrl != null &&
                        widget.profilePictureUrl!.isNotEmpty
                    ? NetworkImage(widget.profilePictureUrl!)
                    : null,
            child: widget.profilePicturePath == null &&
                    (widget.profilePictureUrl == null ||
                        widget.profilePictureUrl!.isEmpty)
                ? const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.orange,
                  )
                : null,
          ),
          const SizedBox(height: 10),
          Text(
            widget.username ?? 'Welcome',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            widget.email,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.orange,
      ),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }
}
