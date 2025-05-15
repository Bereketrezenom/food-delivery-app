// models/ordermodel.dart
import 'package:auth_demo/models/dishmodel.dart';
import 'package:path/path.dart' as p;

enum OrderStatus {
  pending,
  processing,
  delivering,
  delivered,
  cancelled,
}

class Order {
  final String id;
  final List<Dish> items;
  final DateTime orderDate;
  final double subtotal;
  final double shippingFee;
  final double total;
  final OrderStatus status;
  final String restaurantName;
  final String? deliveryAddress;
  final String estimatedDeliveryTime;

  Order({
    required this.id,
    required this.items,
    required this.orderDate,
    required this.subtotal,
    required this.shippingFee,
    required this.total,
    this.status = OrderStatus.pending,
    required this.restaurantName,
    this.deliveryAddress,
    required this.estimatedDeliveryTime,
  });

  Order copyWith({
    String? id,
    List<Dish>? items,
    DateTime? orderDate,
    double? subtotal,
    double? shippingFee,
    double? total,
    OrderStatus? status,
    String? restaurantName,
    String? deliveryAddress,
    String? estimatedDeliveryTime,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      orderDate: orderDate ?? this.orderDate,
      subtotal: subtotal ?? this.subtotal,
      shippingFee: shippingFee ?? this.shippingFee,
      total: total ?? this.total,
      status: status ?? this.status,
      restaurantName: restaurantName ?? this.restaurantName,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      estimatedDeliveryTime:
          estimatedDeliveryTime ?? this.estimatedDeliveryTime,
    );
  }

  String getStatusText() {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.delivering:
        return 'On the way';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  String getFormattedOrderDate() {
    return '${orderDate.day}/${orderDate.month}/${orderDate.year} ${orderDate.hour}:${orderDate.minute.toString().padLeft(2, '0')}';
  }
}
