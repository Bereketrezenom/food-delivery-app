import 'package:auth_demo/models/dishmodel.dart';
import 'package:auth_demo/screens/cart/cart_summary.dart';
import 'package:auth_demo/screens/cart/cartfirestore.dart';
import 'package:auth_demo/screens/cart/cartitemcard.dart' show CartItemCard;
import 'package:auth_demo/screens/cart/cartservices.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService cartService = CartService();
  final FirestoreService firestoreService =
      FirestoreService(); // Initialize Firestore service
  double shippingFee = 4.00;

  @override
  Widget build(BuildContext context) {
    List<Dish> cartItems = cartService.cartItems;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title:
            const Text('Cart', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CartItemCard(
                        dish: cartItems[index],
                        onIncrementQuantity: () {
                          setState(() {
                            cartService.updateQuantity(index, true);
                          });
                        },
                        onDecrementQuantity: () {
                          setState(() {
                            cartService.updateQuantity(index, false);
                          });
                        },
                        onDelete: () {
                          setState(() {
                            cartService.removeItem(index);
                          });
                        },
                      ),
                    ),
                  ),
                ),
                CartSummary(
                  subtotal: cartService.calculateSubtotal(),
                  shippingFee: shippingFee,
                  total: cartService.calculateTotal(shippingFee),
                  cartItems: cartService.cartItems,
                  onCheckout: () async {
                    // Convert cart items to a list of maps for Firestore
                    List<Map<String, dynamic>> cartItemsData =
                        cartService.cartItems.map((dish) {
                      return {
                        'name': dish.name,
                        'price': dish.price,
                        'quantity': dish.quantity,
                      };
                    }).toList();

                    // Save cart data to Firestore
                    await firestoreService.saveCartData(
                      userId:
                          'bereketba49@gmail.com', // Replace with actual user ID
                      cartItems: cartItemsData,
                      subtotal: cartService.calculateSubtotal(),
                      shippingFee: shippingFee,
                      total: cartService.calculateTotal(shippingFee),
                    );

                    // Clear cart after checkout

                    // Show a success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Order placed successfully!')),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
