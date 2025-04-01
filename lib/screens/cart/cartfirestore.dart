import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Saves cart data to Firestore under the user's 'orders' subcollection
  Future<void> saveCartData({
    required String userId,
    required List<Map<String, dynamic>> cartItems,
    required double subtotal,
    required double shippingFee,
    required double total,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('orders')
          .add({
        'cartItems': cartItems,
        'subtotal': subtotal,
        'shippingFee': shippingFee,
        'total': total,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'pending',
      });
    } catch (e) {
      print('Error saving cart data: $e');
      rethrow;
    }
  }

  /// Fetches all orders for a specific user, sorted by timestamp (oldest first)
  Stream<QuerySnapshot> getAllOrders() {
    return _firestore
        .collectionGroup(
            'orders') // This queries across all 'orders' subcollections
        .orderBy('timestamp', descending: true) // Newest first
        .snapshots();
  }

  /// Fetches all orders for a specific user
  Stream<QuerySnapshot> getUserOrders(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('orders')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}

class OrderHistoryScreen extends StatelessWidget {
  final String userId;
  final FirestoreService firestoreService = FirestoreService();

  OrderHistoryScreen({required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getUserOrders(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No orders found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var order = snapshot.data!.docs[index];
              var data = order.data() as Map<String, dynamic>;
              var timestamp = data['timestamp'] as Timestamp;
              var date =
                  DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
              var formattedDate =
                  DateFormat('MMM dd, yyyy - hh:mm a').format(date);

              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.id.substring(0, 8)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Date: $formattedDate'),
                      Text('Status: ${data['status']}'),
                      Text('Total: \$${data['total'].toStringAsFixed(2)}'),
                      const SizedBox(height: 12),
                      const Text(
                        'Items:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...List<Widget>.from(
                        (data['cartItems'] as List).map((item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                '- ${item['name']} (x${item['quantity']}) - \$${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Example of how to use the OrderHistoryScreen
/*
MaterialApp(
  home: OrderHistoryScreen(userId: 'currentUserId'),
)
*/
