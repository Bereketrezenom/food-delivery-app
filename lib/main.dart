import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'constants/theme.dart';
import 'providers/cart_provider.dart';
import 'home/autowrapper.dart';
import 'screens/details/dishdetal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCTBPbnwIMUFlPHhQq4HIO_ZFKVdL8Fxqk",
      authDomain: "foodapp-8db9c.firebaseapp.com",
      projectId: "foodapp-8db9c",
      storageBucket: "foodapp-8db9c.appspot.com",
      messagingSenderId: "191730222733",
      appId: "1:191730222733:web:409faed19b867e53e704c4",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Auth Demo',
        debugShowCheckedModeBanner: false,
        theme: appTheme(),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthWrapper(),
          DishDetailsScreen.routeName: (context) => const DishDetailsScreen(),
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: Center(
                child: Text('Page not found!'),
              ),
            ),
          );
        },
      ),
    );
  }
}
