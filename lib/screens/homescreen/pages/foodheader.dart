// screens/homescreen/pages/foodheader.dart

import 'package:auth_demo/notifications/notificationwidget.dart';
import 'package:auth_demo/screens/homescreen/pages/searchfield.dart';
import 'package:auth_demo/services/locations/locationpicker.dart';
import 'package:auth_demo/services/locations/locationservies.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
// adjust path

class FoodHeader extends StatefulWidget {
  final String? username;
  const FoodHeader({super.key, this.username});

  @override
  State<FoodHeader> createState() => _FoodHeaderState();
}

class _FoodHeaderState extends State<FoodHeader> {
  String? _deliveryAddress;

  @override
  void initState() {
    super.initState();
    _loadDeliveryAddress();
  }

  Future<void> _loadDeliveryAddress() async {
    final address = await LocationService().getSavedDeliveryAddress();
    if (mounted) {
      setState(() {
        _deliveryAddress = address;
      });
    }
  }

  void _showLocationPicker() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LocationPickerMap()),
    );
    if (result != null && result is String) {
      setState(() {
        _deliveryAddress = result;
      });
    }
  }

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
        (widget.username != null && widget.username!.isNotEmpty)
            ? widget.username!
            : "User";

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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Delivered to',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      InkWell(
                        onTap: _showLocationPicker,
                        child: Row(
                          children: [
                            Text(
                              _deliveryAddress ?? 'Select Location',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down, size: 20),
                          ],
                        ),
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
