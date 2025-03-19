import 'package:auth_demo/models/dishmodel.dart';
import 'package:flutter/foundation.dart';

class CartProvider extends ChangeNotifier {
  final List<Dish> _items = [];

  List<Dish> get items => _items;

  void addItem(Dish dish) {
    _items.add(dish);
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }
}
