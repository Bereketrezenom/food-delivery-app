// screens/cart/cart_summary.dart
import 'package:auth_demo/models/dishmodel.dart';
import 'package:auth_demo/models/orderservices.dart';
import 'package:auth_demo/providers/cart_provider.dart';
import 'package:auth_demo/screens/homescreen/home.dart';
import 'package:auth_demo/services/locations/locationservies.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartSummary extends StatelessWidget {
  final double subtotal;
  final double shippingFee;
  final double total;
  final VoidCallback onCheckout;
  final List<Dish> cartItems;

  const CartSummary({
    Key? key,
    required this.subtotal,
    required this.shippingFee,
    required this.total,
    required this.onCheckout,
    required this.cartItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const FoodDeliveryHomePage(name: '', greeting: ''),
                    ));
              },
              style: ElevatedButton.styleFrom(
                elevation: 5, // Adjust the elevation height
                shadowColor: Colors.orange, // Change shadow color
                backgroundColor: const Color.fromARGB(
                    255, 255, 174, 0), // Change button background color
              ),
              child: const Icon(
                Icons.add,
                color: Color.fromARGB(255, 41, 41, 41),
              )),
          const SizedBox(
            height: 5,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter your promo code',
                hintStyle: TextStyle(color: Colors.grey[500]),
                suffixIcon: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildPriceRow('Subtotal', subtotal),
          const SizedBox(height: 10),
          _buildPriceRow('Shipping', shippingFee),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(),
          ),
          _buildPriceRow('Total amount', total, isTotal: true),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _processCheckout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 153, 0),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'CHECKOUT',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _processCheckout(BuildContext context) async {
    // Fetch the saved delivery address
    String? deliveryAddress = await LocationService().getSavedDeliveryAddress();
    print('Fetched delivery address: $deliveryAddress');

    // Prevent checkout if no address is saved
    if (deliveryAddress == null || deliveryAddress.trim().isEmpty) {
      Navigator.pop(context); // Close loading dialog if open
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a delivery address before checkout.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
                SizedBox(height: 20),
                Text('Processing your order...'),
              ],
            ),
          ),
        );
      },
    );

    // Create the restaurant name based on items
    String restaurantName = 'Food Delivery';
    if (cartItems.isNotEmpty) {
      restaurantName = cartItems.first.restaurantName;
    }

    // Process the order with a delay to simulate network request
    Future.delayed(const Duration(seconds: 1), () {
      final OrderService orderService = OrderService();

      // Place the order and get the order object
      final order = orderService.placeOrder(
        items: List.from(cartItems),
        subtotal: subtotal,
        shippingFee: shippingFee,
        total: total,
        restaurantName: restaurantName,
        deliveryAddress: deliveryAddress,
      );

      // Close the loading dialog
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order placed successfully! Order ID: \\${order.id}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      // Clear the cart using CartProvider
      Provider.of<CartProvider>(context, listen: false).clearCart();

      // Call the onCheckout callback
      onCheckout();

      // Navigate to order page (via home page with selectedIndex 2)
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
    });
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? Colors.black : Colors.grey[600],
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}', //
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
