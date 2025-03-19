import 'package:flutter/material.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Your Orders',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Display order items (this could be a dynamic list)
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Replace with the actual order count
                itemBuilder: (context, index) {
                  return const OrderItemCard();
                },
              ),
            ),
            const SizedBox(height: 16),
            // Optionally add an action like canceling or reordering
          ],
        ),
      ),
    );
  }
}

class OrderItemCard extends StatelessWidget {
  const OrderItemCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.fastfood), // Replace with actual dish image
        title: Text('Dish Name'), // Replace with dish name
        subtitle: Text('Order Status: Delivered'), // Replace with actual status
        trailing: Text('\$20.00'), // Replace with dish price
      ),
    );
  }
}
