// lib/widgets/notification_widget.dart

import 'package:flutter/material.dart';

import '../models/notificationmodel.dart';
import 'notificaon_services.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({Key? key}) : super(key: key);

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  final NotificationService _notificationService = NotificationService();
  bool _showNotifications = false;

  // Format timestamp
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} min ago';
      }
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  // Handle notification tap
  void _handleNotificationTap(NotificationModel notification) {
    // Mark notification as read
    _notificationService.markAsRead(notification.id);

    // Close notification panel
    setState(() {
      _showNotifications = false;
    });

    // Handle different notification types
    switch (notification.type) {
      case 'order':
        // Navigate to order details
        print('Navigate to order: ${notification.referenceId}');
        break;
      case 'promotion':
        // Navigate to promotion details
        print('Navigate to promotion');
        break;
      default:
        // Default action
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // For Firebase integration:
    return StreamBuilder<int>(
      stream: _notificationService.getUnreadNotificationCount(),
      builder: (context, snapshot) {
        bool hasUnreadNotifications = false;

        if (snapshot.hasData && snapshot.data != null && snapshot.data! > 0) {
          hasUnreadNotifications = true;
        }

        // Uncomment below line and comment the StreamBuilder for demo purposes:
        // bool hasUnreadNotifications = _notificationService.getDemoNotifications().any((n) => !n.isRead);

        return Stack(
          children: [
            // Notification Bell
            GestureDetector(
              onTap: () {
                setState(() {
                  _showNotifications = !_showNotifications;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade200,
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  size: 24,
                  color: Colors.black,
                ),
              ),
            ),

            // Red indicator dot
            if (hasUnreadNotifications)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                ),
              ),

            // Notification Panel
            if (_showNotifications)
              Positioned(
                top: 45,
                right: -5,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(8),
                  child: NotificationPanel(
                    onMarkAllAsRead: () {
                      _notificationService.markAllAsRead();
                    },
                    onNotificationTap: _handleNotificationTap,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class NotificationPanel extends StatelessWidget {
  final VoidCallback onMarkAllAsRead;
  final Function(NotificationModel) onNotificationTap;

  const NotificationPanel({
    Key? key,
    required this.onMarkAllAsRead,
    required this.onNotificationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NotificationService notificationService = NotificationService();

    // Use this for Firebase integration:
    return StreamBuilder<List<NotificationModel>>(
      stream: notificationService.getNotificationsStream(),
      builder: (context, snapshot) {
        List<NotificationModel> notifications = [];
        bool hasUnreadNotifications = false;

        if (snapshot.hasData) {
          notifications = snapshot.data!;
          hasUnreadNotifications = notifications.any((n) => !n.isRead);
        }

        // Uncomment below line and comment the StreamBuilder for demo purposes:
        // List<NotificationModel> notifications = notificationService.getDemoNotifications();
        // bool hasUnreadNotifications = notifications.any((n) => !n.isRead);

        return Container(
          width: 280,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (hasUnreadNotifications)
                      TextButton(
                        onPressed: onMarkAllAsRead,
                        child: const Text(
                          'Mark all as read',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),

              // Notification List
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: notifications.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            'No notifications',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notification = notifications[index];
                          return _NotificationItem(
                            notification: notification,
                            onTap: () => onNotificationTap(notification),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationItem({
    Key? key,
    required this.notification,
    required this.onTap,
  }) : super(key: key);

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} min ago';
      }
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : Colors.grey.shade100,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification icon based on type
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getNotificationColor(notification.type),
              ),
              child: Center(
                child: Icon(
                  _getNotificationIcon(notification.type),
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: notification.isRead
                          ? FontWeight.normal
                          : FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: const TextStyle(fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTimestamp(notification.timestamp),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'order':
        return Icons.shopping_bag;
      case 'promotion':
        return Icons.discount;
      case 'delivery':
        return Icons.delivery_dining;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'order':
        return Colors.blue;
      case 'promotion':
        return Colors.orange;
      case 'delivery':
        return Colors.green;
      default:
        return Colors.red;
    }
  }
}
