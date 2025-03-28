import 'package:auth_demo/models/dishmodel.dart';
import 'package:auth_demo/screens/cart/cart.dart';
import 'package:auth_demo/screens/cart/cartservices.dart';
import 'package:auth_demo/screens/details/additionaldetail.dart';
import 'package:auth_demo/screens/details/dishdetal.dart';
import 'package:auth_demo/screens/details/dishdiscription.dart';
import 'package:auth_demo/screens/details/dishimage.dart';
import 'package:auth_demo/screens/details/top_rounded_container.dart';
import 'package:auth_demo/screens/homescreen/pages/searchfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class FoodHeader extends StatelessWidget {
  final String? username;
  const FoodHeader({super.key, this.username});

  // Function to determine the greeting based on time
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 18) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  @override
  Widget build(BuildContext context) {
    String greeting = _getGreeting();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                      ),
                      child:
                          const Icon(Icons.menu, size: 24, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 28),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivered to',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Bole',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down, size: 20),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                    child: const Icon(Icons.notifications_outlined,
                        size: 24, color: Colors.black),
                  ),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Updated Welcome Message in ONE LINE with Bold Greeting
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black87,
                  ),
              children: [
                const TextSpan(text: 'Hello  '), // Username
                TextSpan(
                  text: greeting, // Bold Greeting
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          const SearchField()
        ],
      ),
    );
  }
}
