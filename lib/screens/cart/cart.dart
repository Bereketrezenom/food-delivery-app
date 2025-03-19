import 'package:auth_demo/screens/cart/cart_summary.dart';
import 'package:auth_demo/screens/cart/cartitemcard.dart';
import 'package:flutter/material.dart';
import 'package:auth_demo/models/dishmodel.dart';

class CartScreen extends StatefulWidget {
  final Dish dish;

  const CartScreen({Key? key, required this.dish, required List cartItems})
      : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<Dish> cartItems;
  double shippingFee = 4.00;

  @override
  void initState() {
    super.initState();
    cartItems = [widget.dish];
  }

  void updateQuantity(int index, bool increment) {
    setState(() {
      if (increment) {
        cartItems[index].quantity++;
      } else if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
      }
    });
  }

  double calculateSubtotal() {
    return cartItems.fold(
        0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  double calculateTotal() {
    return calculateSubtotal() + shippingFee;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartItems.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CartItemCard(
                  dish: cartItems[index],
                  onIncrementQuantity: () => updateQuantity(index, true),
                  onDecrementQuantity: () => updateQuantity(index, false),
                  onDelete: () {},
                ),
              ),
            ),
          ),
          CartSummary(
            subtotal: calculateSubtotal(),
            shippingFee: shippingFee,
            total: calculateTotal(),
            onCheckout: () {
              // Implement checkout logic
            },
          ),
        ],
      ),
    );
  }
}
