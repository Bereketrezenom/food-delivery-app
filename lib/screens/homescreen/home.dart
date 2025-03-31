import 'package:auth_demo/screens/drawer/appdrawer.dart';
import 'package:auth_demo/screens/homescreen/pages/banner.dart';
import 'package:auth_demo/screens/homescreen/pages/dishcard.dart';
import 'package:auth_demo/screens/homescreen/pages/foodcatagories.dart';
import 'package:auth_demo/screens/homescreen/pages/foodheader.dart';

import 'package:auth_demo/screens/order/order.dart';
import 'package:auth_demo/screens/profile/profile.dart';

import 'package:flutter/material.dart';

class FoodDeliveryHomePage extends StatefulWidget {
  final String name;
  final String greeting;
  final int initialTabIndex;

  const FoodDeliveryHomePage({
    Key? key,
    required this.name,
    required this.greeting,
    this.initialTabIndex = 0,
  }) : super(key: key);

  @override
  _FoodDeliveryHomePageState createState() => _FoodDeliveryHomePageState();
}

class _FoodDeliveryHomePageState extends State<FoodDeliveryHomePage> {
  late int _selectedIndex;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  void _handleLogout() {
    // Implement logout functionality here
    // For example:
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Implement actual logout logic here
              // For example, clear session, token, etc.
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(
        username: widget.name,
        email:
            'user@example.com', // Replace with actual user email when available
        onLogout: _handleLogout,
      ),
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
            Colors.orange, // Set the selected item color to orange
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
  const HomePageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        FoodHeader(
          username: 'User', // Replace with actual username when implemented
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
    Key? key,
    required this.title,
    required this.press,
  }) : super(key: key);

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

// Navigation helper extension
extension NavigationHelper on BuildContext {
  void navigateToPage(Widget page) {
    Navigator.push(
      this,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
