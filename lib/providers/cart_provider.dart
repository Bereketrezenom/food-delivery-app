import 'package:auth_demo/models/dishmodel.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  final List<Dish> _cartItems = [];
  final double _shippingFee = 4.00;

  List<Dish> get cartItems => _cartItems;
  double get shippingFee => _shippingFee;

  void addToCart(Dish dish) {
    final existingIndex = _cartItems.indexWhere((item) => item.id == dish.id);
    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity++;
    } else {
      _cartItems.add(dish);
    }
    notifyListeners();
  }

  void incrementQuantity(int index) {
    _cartItems[index].quantity++;
    notifyListeners();
  }

  void decrementQuantity(int index) {
    if (_cartItems[index].quantity > 1) {
      _cartItems[index].quantity--;
    } else {
      _cartItems.removeAt(index);
    }
    notifyListeners();
  }

  void removeItem(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  double calculateSubtotal() {
    return _cartItems.fold(
        0, (sum, item) => sum + (item.price * item.quantity));
  }

  double calculateTotal() {
    return calculateSubtotal() + _shippingFee;
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
