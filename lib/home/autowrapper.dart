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
          return _buildLoadingScreen();
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
              return _buildLoadingScreen();
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

  Widget _buildLoadingScreen() {
    return const Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: BikeWithSmokeAnimation(),
          ),
        ],
      ),
    );
  }
}

class BikeWithSmokeAnimation extends StatefulWidget {
  const BikeWithSmokeAnimation({super.key});

  @override
  _BikeWithSmokeAnimationState createState() => _BikeWithSmokeAnimationState();
}

class _BikeWithSmokeAnimationState extends State<BikeWithSmokeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bikeAnimation;
  final List<SmokeParticle> _particles = [];
  final double _bikeWidth = 150;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _bikeAnimation = Tween<double>(
      begin: -1.5,
      end: 2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _controller.addListener(() {
      // Add new smoke particles
      final screenWidth = MediaQuery.of(context).size.width;
      final bikePosition = screenWidth / 2 + _bikeAnimation.value * screenWidth;
      _particles.add(SmokeParticle(
        x: bikePosition - _bikeWidth / 2, // Emit from back of bike
        y: MediaQuery.of(context).size.height / 2 +
            50, // Adjust for bike height
        opacity: 1.0,
      ));

      // Update existing particles
      _particles.removeWhere((particle) => particle.opacity <= 0);
      for (final particle in _particles) {
        particle.y -= 1; // Move upward
        particle.opacity -= 0.01; // Fade out
        particle.size += 0.2; // Expand
      }

      // Trigger repaint
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bikeLeft =
        screenWidth / 2 + _bikeAnimation.value * screenWidth - _bikeWidth / 2;

    return Stack(
      children: [
        // Smoke particles
        CustomPaint(
          painter: SmokePainter(_particles),
          size: Size.infinite,
        ),

        // Bike
        Positioned(
          left: bikeLeft,
          top: MediaQuery.of(context).size.height / 2 - 75,
          child: Image.asset(
            "assets/images/food-delivery.png",
            width: _bikeWidth,
            height: 150,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

class SmokeParticle {
  double x;
  double y;
  double opacity;
  double size;

  SmokeParticle({
    required this.x,
    required this.y,
    required this.opacity,
    this.size = 10.0,
  });
}

class SmokePainter extends CustomPainter {
  final List<SmokeParticle> particles;

  SmokePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = Colors.grey.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
