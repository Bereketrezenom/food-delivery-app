import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://www.example.com/your_profile_image.jpg', // Replace with user's profile image URL
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Username', // Replace with actual user name
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'email@example.com', // Replace with user email
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            // Settings or other profile-related actions
            ElevatedButton(
              onPressed: () {
                // Handle logout or settings
              },
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
