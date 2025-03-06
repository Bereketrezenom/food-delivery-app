import 'package:flutter/material.dart';

import '../auth/login.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key, required name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginPage()))),
      ),
      body: const Center(
        child: Text('Welcome to the Homepage'),
      ),
    );
  }
}
