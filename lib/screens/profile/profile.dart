// screens/profile/profile.dart
import 'dart:io';
import 'package:auth_demo/auth/login.dart';
import 'package:auth_demo/screens/drawer/appdrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = true;
  String _errorMessage = '';

  // User data
  String _userName = '';
  String _userEmail = '';
  String? _userPhotoUrl; // Firestore photo URL
  String _userPhoneNumber = '';

  File? _selectedImage; // Temporary selected image file
  File? _savedImage; // Locally saved image file (persisted)

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final currentUser = _auth.currentUser;

      if (currentUser == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'No user is signed in.';
        });
        return;
      }

      // Set email from auth
      _userEmail = currentUser.email ?? 'No email available';

      // Fetch additional user data from Firestore
      final docSnapshot =
          await _firestore.collection('login').doc(currentUser.uid).get();

      if (docSnapshot.exists) {
        final userData = docSnapshot.data();
        setState(() {
          _userName = userData?['name'] ?? 'User';
          _userPhotoUrl = userData?['photoUrl'];
          _userPhoneNumber = userData?['phoneNumber'] ?? '';
          _isLoading = false;
        });
      } else {
        setState(() {
          _userName = 'User';
          _isLoading = false;
        });
      }

      // Load locally saved image if it exists
      final directory = await getApplicationDocumentsDirectory();
      final savedImagePath = '${directory.path}/profile_picture.png';
      if (await File(savedImagePath).exists()) {
        setState(() {
          _savedImage = File(savedImagePath);
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load user data: ${e.toString()}';
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // Update the temporary image
      });
    }
  }

  Future<void> _saveImage() async {
    if (_selectedImage == null) {
      return; // No image to save
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final savedImagePath = '${directory.path}/profile_picture.png';
      await _selectedImage!.copy(savedImagePath);

      setState(() {
        _savedImage = File(savedImagePath); // Update the saved image
        _selectedImage = null; // Clear the temporary image
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save image: ${e.toString()}')),
      );
    }
  }

  void _cancelImage() {
    setState(() {
      _selectedImage = null; // Discard the temporary image
    });
  }

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      if (mounted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadUserData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      // Profile image
                      Center(
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: _getProfileImageProvider(),
                            child: (_selectedImage == null &&
                                    _savedImage == null &&
                                    (_userPhotoUrl == null ||
                                        _userPhotoUrl!.isEmpty))
                                ? const Icon(Icons.person,
                                    size: 50, color: Colors.orange)
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _userName,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 32),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            _buildProfileTile(
                              icon: Icons.person_outline,
                              text: 'My Account',
                              onTap: () => _showAccountDialog(context),
                            ),
                            _buildProfileTile(
                              icon: Icons.notifications_none,
                              text: 'Notifications',
                              onTap: () {}, // Placeholder
                            ),
                            _buildProfileTile(
                              icon: Icons.settings_outlined,
                              text: 'Settings',
                              onTap: () {
                                Navigator.pushNamed(context, '/settings');
                              },
                            ),
                            _buildProfileTile(
                              icon: Icons.help_outline,
                              text: 'Help Center',
                              onTap: () {}, // Placeholder
                            ),
                            _buildProfileTile(
                              icon: Icons.logout,
                              text: 'Log Out',
                              onTap: _logout,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildProfileTile(
      {required IconData icon,
      required String text,
      required VoidCallback onTap,
      Color? color}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: color ?? Colors.orange),
        title: Text(
          text,
          style: TextStyle(
            color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.orange),
        onTap: onTap,
      ),
    );
  }

  void _showAccountDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text('Account',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Edit Profile'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to edit profile page
              },
            ),
            ListTile(
              leading: const Icon(Icons.password),
              title: const Text('Change Password'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to change password page
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Payment Methods'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to payment methods page
              },
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider<Object>? _getProfileImageProvider() {
    if (_selectedImage != null) {
      return FileImage(_selectedImage!);
    } else if (_savedImage != null) {
      return FileImage(_savedImage!);
    } else if (_userPhotoUrl != null && _userPhotoUrl!.isNotEmpty) {
      return NetworkImage(_userPhotoUrl!);
    }
    return null;
  }
}
