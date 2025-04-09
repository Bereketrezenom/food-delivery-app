import 'package:auth_demo/models/dishmodel.dart';
import 'package:auth_demo/screens/cart/cart.dart';
import 'package:auth_demo/screens/cart/cartservices.dart';
import 'package:auth_demo/screens/details/additionaldetail.dart';
import 'package:auth_demo/screens/details/dishdetal.dart';
import 'package:auth_demo/screens/details/dishdiscription.dart';
import 'package:auth_demo/screens/details/dishimage.dart';
import 'package:auth_demo/screens/details/top_rounded_container.dart';
import 'package:auth_demo/screens/homescreen/pages/banner.dart';
import 'package:auth_demo/screens/homescreen/pages/dishcard.dart';
import 'package:auth_demo/screens/homescreen/pages/foodcatagories.dart';
import 'package:auth_demo/screens/homescreen/pages/foodheader.dart';
import 'package:auth_demo/screens/order/order.dart';
import 'package:auth_demo/screens/profile/profile.dart';
import 'package:flutter/material.dart';

class FoodDeliveryHomePage extends StatefulWidget {
  final int initialTabIndex;

  const FoodDeliveryHomePage({
    super.key,
    required String name,
    required String greeting,
    this.initialTabIndex = 0,
  });

  @override
  _FoodDeliveryHomePageState createState() => _FoodDeliveryHomePageState();
}

class _FoodDeliveryHomePageState extends State<FoodDeliveryHomePage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    // Use the initialTabIndex if provided, otherwise default to 0 (home)
    _selectedIndex = widget.initialTabIndex;
  }

  // List of pages for each tab (home, order, profile)
  final List<Widget> _pages = [
    const HomePageContent(), // Home tab content
    const OrderPage(), // Order tab content
    const ProfilePage(), // Profile tab content
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
        child: _selectedIndex == 0
            ? SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: _pages[_selectedIndex], // Display home page with scroll
              )
            : _pages[
                _selectedIndex], // Display other pages without scroll wrapper
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor:
            const Color.fromARGB(255, 255, 0, 0), // Set the selected item color to orange
        unselectedItemColor:
            Colors.grey, // Set the unselected item color to grey
        type: BottomNavigationBarType
            .fixed, // Ensures all items are always visible
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
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

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        FoodHeader(
          username: '', // Replace with actual username when implemented
        ),
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
          style: TextButton.styleFrom(foregroundColor: const Color.fromARGB(255, 255, 0, 0)),
          child: const Text("See more"),
        ),
      ],
    );
  }
}
