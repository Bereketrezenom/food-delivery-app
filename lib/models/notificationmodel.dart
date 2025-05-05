// lib/models/notification_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String type;
  final String? referenceId;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.isRead,
    required this.type,
    this.referenceId,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['read'] ?? false,
      type: data['type'] ?? 'general',
      referenceId: data['referenceId'],
    );
  }
}

// Demo notifications for testing
List<NotificationModel> demoNotifications = [
  NotificationModel(
    id: '1',
    title: 'New Discount!',
    message: 'Get 20% off on your next burger order',
    timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    isRead: false,
    type: 'promotion',
  ),
  NotificationModel(
    id: '2',
    title: 'Order Delivered',
    message: 'Your order #12345 has been delivered',
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
    isRead: true,
    type: 'order',
    referenceId: '12345',
  ),
  NotificationModel(
    id: '3',
    title: 'New Restaurant Added',
    message: 'Check out our newest restaurant partner - Spice Garden',
    timestamp: DateTime.now().subtract(const Duration(days: 2)),
    isRead: false,
    type: 'general',
  ),
];
