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
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color.fromRGBO(255, 109, 12, 1),
        foregroundColor: Colors.white,
      ),
      drawer: AppDrawer(
        username: _userName,
        email: _userEmail,
        profilePicturePath: _savedImage?.path,
        profilePictureUrl: _userPhotoUrl,
        onLogout: _logout,
      ),
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
              : _buildProfileContent(),
    );
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile image
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                backgroundImage: _selectedImage != null
                    ? FileImage(_selectedImage!)
                    : _savedImage != null
                        ? FileImage(_savedImage!)
                        : _userPhotoUrl != null && _userPhotoUrl!.isNotEmpty
                            ? NetworkImage(_userPhotoUrl!)
                            : const AssetImage('assets/images/placeholder.png')
                                as ImageProvider<Object>,
                child: _selectedImage == null &&
                        _savedImage == null &&
                        (_userPhotoUrl == null || _userPhotoUrl!.isEmpty)
                    ? const Icon(Icons.person, size: 60, color: Colors.grey)
                    : null,
              ),
            ),

            const SizedBox(height: 8),

            // Edit profile picture text
            TextButton(
              onPressed: _pickImage,
              child: const Text(
                'Edit Profile Picture',
                style: TextStyle(
                  color: Color.fromRGBO(255, 109, 12, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            if (_selectedImage != null) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _saveImage,
                    child: const Text('Save'),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: _cancelImage,
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 24),

            // User name
            Text(
              _userName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // User email
            Text(
              _userEmail,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),

            if (_userPhoneNumber.isNotEmpty) ...[
              const SizedBox(height: 8),
              // Phone number
              Text(
                _userPhoneNumber,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Log out button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('Log Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(255, 109, 12, 1),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
