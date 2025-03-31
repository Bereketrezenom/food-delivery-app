import 'package:auth_demo/home/autowrapper.dart';
import 'package:auth_demo/providers/cart_provider.dart';
import 'package:auth_demo/screens/details/dishdetal.dart';
import 'package:auth_demo/screens/drawer/menu/menu.dart';
import 'package:auth_demo/screens/drawer/setting.dart';
import 'package:auth_demo/screens/homescreen/home.dart';
import 'package:auth_demo/screens/order/order.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  // Firebase Messaging setup
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request notification permissions
  final NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );

  print('Authorization status: ${settings.authorizationStatus}');

  // Get FCM token
  final String? token = await messaging.getToken();
  print('FCM Token: $token');

  // Foreground message handler
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message Notification Title: ${message.notification?.title}');
      print('Message Notification Body: ${message.notification?.body}');
    }
  });

  // Background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Handle initial message when app is opened from terminated state
  RemoteMessage? initialMessage = await messaging.getInitialMessage();
  if (initialMessage != null) {
    _handleMessage(initialMessage);
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

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  _handleMessage(message);
}

void _handleMessage(RemoteMessage message) {
  print('Handling message: ${message.messageId}');
  // Add your navigation logic here based on message data
  // Example:
  // if (message.data['type'] == 'order_update') {
  //   Navigator.push(context, MaterialPageRoute(...));
  // }
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
        '/home': (context) => const FoodDeliveryHomePage(
              name: 'User',
              greeting: 'Welcome back',
            ),
        '/menu': (context) => const MenuPage(),
        '/order': (context) => const OrderPage(),
        '/settings': (context) => const SettingsPage(),
        '/login': (context) =>
            const Scaffold(body: Center(child: Text('Login Page'))),
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
