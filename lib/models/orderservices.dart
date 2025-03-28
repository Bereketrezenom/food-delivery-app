import 'dart:math';

import 'package:auth_demo/models/dishmodel.dart';
import 'package:auth_demo/models/ordermodel.dart';

class OrderService {
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;
  OrderService._internal();

  final List<Order> _orders = [];

  List<Order> get orders => _orders;

  String _generateOrderId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    final result = StringBuffer();
    for (var i = 0; i < 8; i++) {
      result.write(chars[random.nextInt(chars.length)]);
    }
    return '#${result.toString()}';
  }

  String _generateEstimatedDeliveryTime() {
    final now = DateTime.now();
    final deliveryTime = now.add(Duration(minutes: 30 + Random().nextInt(30)));
    return '${deliveryTime.hour}:${deliveryTime.minute.toString().padLeft(2, '0')}';
  }

  Order placeOrder({
    required List<Dish> items,
    required double subtotal,
    required double shippingFee,
    required double total,
    required String restaurantName,
    String deliveryAddress = '123 Main St, Anytown',
  }) {
    final order = Order(
      id: _generateOrderId(),
      items: List.from(items),
      orderDate: DateTime.now(),
      subtotal: subtotal,
      shippingFee: shippingFee,
      total: total,
      status: OrderStatus.pending,
      restaurantName: restaurantName,
      deliveryAddress: deliveryAddress,
      estimatedDeliveryTime: _generateEstimatedDeliveryTime(),
    );

    _orders.insert(0, order); // Add newest order at the beginning
    return order;
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      final updatedOrder = _orders[orderIndex].copyWith(status: status);
      _orders[orderIndex] = updatedOrder;
    }
  }

  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }

  // For demo purposes, simulate order status changes
  void simulateOrderProgress() {
    if (_orders.isNotEmpty) {
      final order = _orders.first;

      // Simulate order status progression
      switch (order.status) {
        case OrderStatus.pending:
          updateOrderStatus(order.id, OrderStatus.processing);
          break;
        case OrderStatus.processing:
          updateOrderStatus(order.id, OrderStatus.delivering);
          break;
        case OrderStatus.delivering:
          updateOrderStatus(order.id, OrderStatus.delivered);
          break;
        default:
          break;
      }
    }
  }
}
