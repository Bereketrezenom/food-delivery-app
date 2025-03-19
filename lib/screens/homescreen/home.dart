import 'package:auth_demo/screens/cart/cart.dart';
import 'package:auth_demo/screens/homescreen/pages/banner.dart';
import 'package:auth_demo/screens/homescreen/pages/dishcard.dart';
import 'package:auth_demo/screens/homescreen/pages/foodcatagories.dart';
import 'package:auth_demo/screens/homescreen/pages/foodheader.dart';
import 'package:auth_demo/screens/profile/profile.dart';
import 'package:auth_demo/screens/order/order.dart'; // New OrderPage import
import 'package:flutter/material.dart';

class FoodDeliveryHomePage extends StatefulWidget {
  const FoodDeliveryHomePage({
    super.key,
    required String name,
    required String greeting,
  });

  @override
  _FoodDeliveryHomePageState createState() => _FoodDeliveryHomePageState();
}

class _FoodDeliveryHomePageState extends State<FoodDeliveryHomePage> {
  int _selectedIndex = 0;

  // List of pages for each tab (home, cart, profile, order)
  final List<Widget> _pages = [
    const HomePageContent(), // Home tab content
    const EmptyCartScreen(), // Placeholder for Cart tab content
    const ProfilePage(), // Profile tab content
    const OrderPage(), // Order tab content (new page)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected tab index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: _pages[_selectedIndex], // Display selected page
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor:
            Colors.orange, // Set the selected item color to orange
        unselectedItemColor:
            Colors.grey, // Set the unselected item color to grey
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Placeholder for Cart tab content when no dish is selected
class EmptyCartScreen extends StatelessWidget {
  const EmptyCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Your cart is empty",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        FoodHeader(),
        FoodCategories(),
        FoodDiscountBanner(),
        SizedBox(height: 20),
        FeaturedDishes(),
        SizedBox(height: 20),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    required this.press,
  });

  final String title;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        TextButton(
          onPressed: press,
          style: TextButton.styleFrom(foregroundColor: Colors.orange),
          child: const Text("See more"),
        ),
      ],
    );
  }
}
