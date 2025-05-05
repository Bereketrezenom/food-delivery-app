// lib/services/notification_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/notificationmodel.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user's email
  String? get currentUserEmail => _auth.currentUser?.email;

  // Stream of notifications for current user
  Stream<List<NotificationModel>> getNotificationsStream() {
    // If we have a current user, get their notifications
    if (currentUserEmail != null) {
      return _firestore
          .collection('notifications')
          .where('recipient', isEqualTo: currentUserEmail)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => NotificationModel.fromFirestore(doc))
              .toList());
    }

    // Otherwise, return an empty stream
    return Stream.value([]);
  }

  // Get count of unread notifications
  Stream<int> getUnreadNotificationCount() {
    if (currentUserEmail != null) {
      return _firestore
          .collection('notifications')
          .where('recipient', isEqualTo: currentUserEmail)
          .where('read', isEqualTo: false)
          .snapshots()
          .map((snapshot) => snapshot.docs.length);
    }

    return Stream.value(0);
  }

  // Mark a notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _firestore
          .collection('notifications')
          .doc(notificationId)
          .update({'read': true});
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    if (currentUserEmail == null) return;

    try {
      final batch = _firestore.batch();

      final QuerySnapshot unreadNotifications = await _firestore
          .collection('notifications')
          .where('recipient', isEqualTo: currentUserEmail)
          .where('read', isEqualTo: false)
          .get();

      for (var doc in unreadNotifications.docs) {
        batch.update(doc.reference, {'read': true});
      }

      await batch.commit();
    } catch (e) {
      print('Error marking all notifications as read: $e');
    }
  }

  // For demo purposes: Get demo notifications
  List<NotificationModel> getDemoNotifications() {
    return demoNotifications;
  }
}
