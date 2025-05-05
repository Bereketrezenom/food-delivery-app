// lib/screens/homescreen/pages/food_header.dart

import 'package:auth_demo/notifications/notificationwidget.dart';
import 'package:auth_demo/screens/homescreen/pages/searchfield.dart';
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

    // Use a default name if username is null or empty
    String displayName =
        (username != null && username!.isNotEmpty) ? username! : "User";

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
              // Replace the static notification icon with the interactive NotificationWidget
              const NotificationWidget(),
            ],
          ),

          const SizedBox(height: 30),

          // Updated Welcome Message with Username and Greeting
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black87,
                  ),
              children: [
                TextSpan(
                  text: 'Hello ${capitalize(displayName)}, ',
                  style: const TextStyle(fontWeight: FontWeight.w400),
                ),
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

String capitalize(String name) {
  if (name.isEmpty) return name;
  return name[0].toUpperCase() + name.substring(1);
}
