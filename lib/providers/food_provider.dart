import 'package:flutter/foundation.dart';

class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  final String category;
  final String restaurant;
  final int timeToDeliver;
  final double rating;
  final int reviews;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
    required this.category,
    required this.restaurant,
    required this.timeToDeliver,
    required this.rating,
    required this.reviews,
  });
}

class FoodProvider with ChangeNotifier {
  final List<FoodItem> _items = [
    FoodItem(
      id: 'b1',
      name: 'Classic Burger',
      description:
          'Our classic beef patty with fresh lettuce, tomatoes, onions, pickles, and secret sauce on a toasted sesame seed bun.',
      price: 9.99,
      imageUrl: 'assets/images/burger1.svg',
      category: 'Burgers',
      restaurant: 'Burger House',
      timeToDeliver: 25,
      rating: 4.7,
      reviews: 128,
    ),
    FoodItem(
      id: 'b2',
      name: 'Cheese Burger',
      description:
          'Our juicy beef patty topped with melted cheddar cheese, fresh lettuce, tomatoes, onions, and special sauce.',
      price: 11.99,
      imageUrl: 'assets/images/burger2.svg',
      category: 'Burgers',
      restaurant: 'Burger House',
      timeToDeliver: 20,
      rating: 4.5,
      reviews: 96,
    ),
    FoodItem(
      id: 'b3',
      name: 'Veggie Burger',
      description:
          'Plant-based patty with fresh vegetables, avocado spread, and spicy mayo on a whole grain bun.',
      price: 12.99,
      imageUrl: 'assets/images/burger3.svg',
      category: 'Burgers',
      restaurant: 'Green Bistro',
      timeToDeliver: 25,
      rating: 4.3,
      reviews: 85,
    ),
    FoodItem(
      id: 'b4',
      name: 'Chicken Burger',
      description:
          'Crispy fried chicken breast with lettuce, pickles, and house mayo on a buttered brioche bun.',
      price: 10.99,
      imageUrl: 'assets/images/burger4.svg',
      category: 'Burgers',
      restaurant: 'Crispy Bites',
      timeToDeliver: 20,
      rating: 4.6,
      reviews: 104,
    ),
    FoodItem(
      id: 'p1',
      name: 'Margherita Pizza',
      description:
          'Classic pizza with tomato sauce, fresh mozzarella, basil, and extra virgin olive oil.',
      price: 13.99,
      imageUrl: 'assets/images/pizza1.svg',
      category: 'Pizza',
      restaurant: 'Pizza Paradise',
      timeToDeliver: 30,
      rating: 4.8,
      reviews: 145,
    ),
    FoodItem(
      id: 'p2',
      name: 'Pepperoni Pizza',
      description:
          'Traditional pizza topped with tomato sauce, mozzarella cheese, and spicy pepperoni slices.',
      price: 14.99,
      imageUrl: 'assets/images/pizza2.svg',
      category: 'Pizza',
      restaurant: 'Pizza Paradise',
      timeToDeliver: 25,
      rating: 4.7,
      reviews: 132,
    ),
  ];

  // Get all food items
  List<FoodItem> get items {
    return [..._items];
  }

  // Get items by category
  List<FoodItem> getItemsByCategory(String category) {
    return _items.where((item) => item.category == category).toList();
  }

  // Get all categories
  List<String> get categories {
    return _items.map((item) => item.category).toSet().toList();
  }

  // Find item by ID
  FoodItem findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  // Toggle favorite status
  void toggleFavorite(String id) {
    final existingIndex = _items.indexWhere((item) => item.id == id);
    if (existingIndex >= 0) {
      _items[existingIndex].isFavorite = !_items[existingIndex].isFavorite;
      notifyListeners();
    }
  }

  // Check if an item is favorite
  bool isFavorite(String id) {
    final existingIndex = _items.indexWhere((item) => item.id == id);
    if (existingIndex >= 0) {
      return _items[existingIndex].isFavorite;
    }
    return false;
  }

  // Get favorite items
  List<FoodItem> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }
}
