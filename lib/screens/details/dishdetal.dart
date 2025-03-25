import 'package:auth_demo/screens/cart/cartservices.dart';
import 'package:flutter/material.dart';
import 'package:auth_demo/models/dishmodel.dart';
import 'package:auth_demo/screens/cart/cart.dart';

import 'package:auth_demo/screens/details/dishdiscription.dart';
import 'package:auth_demo/screens/details/dishimage.dart';
import 'package:auth_demo/screens/details/top_rounded_container.dart';

class DishDetailsScreen extends StatelessWidget {
  static const routeName = '/dish-details';

  const DishDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dish = ModalRoute.of(context)!.settings.arguments as Dish;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18,
              child: IconButton(
                icon: const Icon(
                  Icons.favorite,
                  color: Color.fromARGB(255, 255, 0, 0),
                  size: 18,
                ),
                onPressed: () {
                  // Add favorite action here
                },
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          DishImages(dish: dish),
          TopRoundedContainer(
            color: Colors.white,
            child: DishDescription(dish: dish),
          ),
        ],
      ),
      bottomNavigationBar: TopRoundedContainer(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              // ✅ Add dish to cart before navigating
              CartService().addToCart(dish);

              // ✅ Navigate to cart screen (NO EMPTY LIST!)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
            child: const Text(
              'Order now',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
