import 'package:auth_demo/home/autowrapper.dart';
import 'package:auth_demo/providers/cart_provider.dart';
import 'package:auth_demo/screens/details/dishdetal.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Add provider import
// Import your CartProvider

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      name: "foodapp-8db9c",
      options: const FirebaseOptions(
        apiKey: "AIzaSyCTBPbnwIMUFlPHhQq4HIO_ZFKVdL8Fxqk",
        authDomain: "foodapp-8db9c.firebaseapp.com",
        projectId: "foodapp-8db9c",
        storageBucket: "foodapp-8db9c.appspot.com",
        messagingSenderId: "191730222733",
        appId: "1:191730222733:web:409faed19b867e53e704c4",
      ),
    );
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      routes: {
        '/': (context) => const AuthWrapper(),
        DishDetailsScreen.routeName: (context) => const DishDetailsScreen(),
      },
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Page not found!'),
            ),
          ),
        );
      },
    );
  }
}
