import 'package:auth_demo/auth/login.dart';
import 'package:auth_demo/screens/homescreen/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Something went wrong!')),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          return const LoginPage();
        }

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('login')
              .doc(user.uid)
              .get(),
          builder: (context, docSnapshot) {
            if (docSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (docSnapshot.hasError) {
              return const Scaffold(
                body: Center(child: Text('Failed to fetch user data!')),
              );
            }

            if (!docSnapshot.hasData || !(docSnapshot.data?.exists ?? false)) {
              FirebaseAuth.instance.signOut();
              return const LoginPage();
            }

            final name = docSnapshot.data!['name'] as String? ?? 'Guest';
            return FoodDeliveryHomePage(
              name: name,
              greeting: 'Welcome back!',
            );
          },
        );
      },
    );
  }
}
