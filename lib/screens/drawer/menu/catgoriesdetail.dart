import 'package:auth_demo/models/dishmodel.dart';

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<Dish> _cartItems = [];

  List<Dish> get cartItems => _cartItems;

  void addToCart(Dish dish) {
    int index = _cartItems.indexWhere((item) => item.id == dish.id);
    if (index != -1) {
      _cartItems[index].quantity += dish.quantity;
    } else {
      _cartItems.add(dish);
    }
  }

  void updateQuantity(int index, bool increment) {
    if (increment) {
      _cartItems[index].quantity++;
    } else if (_cartItems[index].quantity > 1) {
      _cartItems[index].quantity--;
    }
  }

  void removeItem(int index) {
    _cartItems.removeAt(index);
  }

  double calculateSubtotal() {
    return _cartItems.fold(
        0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  double calculateTotal(double shippingFee) {
    return calculateSubtotal() + shippingFee;
  }
}
