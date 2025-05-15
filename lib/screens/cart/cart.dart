// screens/cart/cart.dart
import 'package:auth_demo/models/dishmodel.dart';
import 'package:auth_demo/providers/cart_provider.dart';
import 'package:auth_demo/screens/cart/cart_summary.dart';
import 'package:auth_demo/screens/cart/cartfirestore.dart';
import 'package:auth_demo/screens/cart/cartitemcard.dart' show CartItemCard;
import 'package:auth_demo/screens/homescreen/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final FirestoreService firestoreService = FirestoreService();
  double shippingFee = 4.00;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        List<Dish> cartItems = cartProvider.cartItems;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text('Cart',
                style: TextStyle(fontWeight: FontWeight.bold)),
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
                              cartProvider.incrementQuantity(index);
                            },
                            onDecrementQuantity: () {
                              cartProvider.decrementQuantity(index);
                            },
                            onDelete: () {
                              cartProvider.removeItem(index);
                            },
                          ),
                        ),
                      ),
                    ),
                    CartSummary(
                      subtotal: cartProvider.calculateSubtotal(),
                      shippingFee: shippingFee,
                      total: cartProvider.calculateTotal(),
                      cartItems: cartProvider.cartItems,
                      onCheckout: () async {
                        // Convert cart items to a list of maps for Firestore
                        List<Map<String, dynamic>> cartItemsData =
                            cartProvider.cartItems.map((dish) {
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
                          subtotal: cartProvider.calculateSubtotal(),
                          shippingFee: shippingFee,
                          total: cartProvider.calculateTotal(),
                        );

                        // Clear the cart
                        cartProvider.clearCart();

                        // Show a success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Order placed successfully!')),
                        );

                        // Navigate to home page
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FoodDeliveryHomePage(
                              name: '',
                              greeting: '',
                              initialTabIndex: 1, // Order tab index
                            ),
                          ),
                          (route) => false, // Remove all previous routes
                        );
                      },
                    ),
                  ],
                ),
        );
      },
    );
  }
}
