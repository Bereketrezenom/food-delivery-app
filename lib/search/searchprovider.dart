// search/searchprovider.dart
import 'package:auth_demo/models/dishmodel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// // Sample Dish Model

// // Search Provider to Manage State
class SearchProvider extends ChangeNotifier {
  List<Dish> _searchResults = [];
  String _query = '';
  bool _isSearching = false;
  List<String> _searchHistory = [];
  double? _minPrice;
  double? _maxPrice;
  String? _selectedCategory;
  double? _minRating;
  bool _showFilters = false;

  List<Dish> get searchResults => _searchResults;
  String get query => _query;
  bool get isSearching => _isSearching;
  List<String> get searchHistory => _searchHistory;
  double? get minPrice => _minPrice;
  double? get maxPrice => _maxPrice;
  String? get selectedCategory => _selectedCategory;
  double? get minRating => _minRating;
  bool get showFilters => _showFilters;

  SearchProvider() {
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _searchHistory = prefs.getStringList('searchHistory') ?? [];
      notifyListeners();
    } catch (e) {
      print('Error loading search history: $e');
    }
  }

  Future<void> _saveSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('searchHistory', _searchHistory);
    } catch (e) {
      print('Error saving search history: $e');
    }
  }

  void addToSearchHistory(String query) {
    if (query.isNotEmpty && !_searchHistory.contains(query)) {
      _searchHistory.insert(0, query);
      if (_searchHistory.length > 10) {
        _searchHistory.removeLast();
      }
      _saveSearchHistory();
      notifyListeners();
    }
  }

  void removeFromSearchHistory(String query) {
    _searchHistory.remove(query);
    _saveSearchHistory();
    notifyListeners();
  }

  void clearSearchHistory() {
    _searchHistory.clear();
    _saveSearchHistory();
    notifyListeners();
  }

  void toggleFilters() {
    _showFilters = !_showFilters;
    notifyListeners();
  }

  void setPriceRange(double? min, double? max) {
    _minPrice = min;
    _maxPrice = max;
    notifyListeners();
  }

  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setMinRating(double? rating) {
    _minRating = rating;
    notifyListeners();
  }

  void resetFilters() {
    _minPrice = null;
    _maxPrice = null;
    _selectedCategory = null;
    _minRating = null;
    notifyListeners();
  }

  // Get all available dishes from both sources
  List<Dish> _getAllDishes() {
    // Get dishes from demoDishes
    List<Dish> allDishes = List.from(demoDishes);

    // Get dishes from category items
    final categories = ['pizza', 'burgers', 'bbq'];
    for (final category in categories) {
      final categoryItems = _getCategoryItems(category);
      allDishes.addAll(categoryItems);
    }

    // Remove duplicates based on id and name
    final uniqueDishes = <Dish>[];
    final seenIds = <int>{};

    for (final dish in allDishes) {
      if (!seenIds.contains(dish.id)) {
        seenIds.add(dish.id);
        uniqueDishes.add(dish);
      }
    }

    return uniqueDishes;
  }

  // Helper method to get category items (copied from menu_catagories.dart)
  List<Dish> _getCategoryItems(String category) {
    switch (category.toLowerCase()) {
      case 'pizza':
        return [
          Dish(
            id: 101,
            name: 'Margherita Pizza',
            description: 'Classic Margherita Pizza with fresh basil.',
            image: 'https://example.com/margherita.jpg',
            images: ['https://example.com/margherita.jpg'],
            price: 9.99,
            cookingTime: 15,
            rating: 4.5,
            kcal: 300,
            restaurantName: 'Pizza Place',
            distance: '5 km',
            size: 'Medium',
            category: 'pizza',
          ),
          Dish(
            id: 102,
            name: 'Pepperoni Pizza',
            description: 'Classic pizza with pepperoni and cheese.',
            image: 'https://example.com/pepperoni.jpg',
            images: ['https://example.com/pepperoni.jpg'],
            price: 11.99,
            cookingTime: 15,
            rating: 4.7,
            kcal: 350,
            restaurantName: 'Pizza Place',
            distance: '5 km',
            size: 'Medium',
            category: 'pizza',
          ),
        ];
      case 'burgers':
        return [
          Dish(
            id: 201,
            name: 'Cheese Burger',
            description: 'Juicy cheese burger with all the classic toppings.',
            image: 'https://example.com/cheeseburger.jpg',
            images: ['https://example.com/cheeseburger.jpg'],
            price: 8.99,
            cookingTime: 10,
            rating: 4.8,
            kcal: 400,
            restaurantName: 'Burger Joint',
            distance: '2 km',
            size: 'Medium',
            category: 'burgers',
          ),
          Dish(
            id: 202,
            name: 'Double Bacon Burger',
            description: 'Double patty with bacon and special sauce.',
            image: 'https://example.com/baconburger.jpg',
            images: ['https://example.com/baconburger.jpg'],
            price: 12.99,
            cookingTime: 12,
            rating: 4.9,
            kcal: 650,
            restaurantName: 'Burger Joint',
            distance: '2 km',
            size: 'Large',
            category: 'burgers',
          ),
        ];
      case 'bbq':
        return [
          Dish(
            id: 301,
            name: 'BBQ Ribs',
            description: 'Tender BBQ ribs with smoky sauce.',
            image: 'https://example.com/bbqribs.jpg',
            images: ['https://example.com/bbqribs.jpg'],
            price: 15.99,
            cookingTime: 30,
            rating: 4.7,
            kcal: 600,
            restaurantName: 'BBQ Shack',
            distance: '10 km',
            size: 'Large',
            category: 'bbq',
          ),
          Dish(
            id: 302,
            name: 'BBQ Chicken',
            description: 'Grilled chicken with BBQ sauce.',
            image: 'https://example.com/bbqchicken.jpg',
            images: ['https://example.com/bbqchicken.jpg'],
            price: 13.99,
            cookingTime: 25,
            rating: 4.6,
            kcal: 450,
            restaurantName: 'BBQ Shack',
            distance: '10 km',
            size: 'Medium',
            category: 'bbq',
          ),
        ];
      default:
        return [];
    }
  }

  // Perform search based on query and filters
  void search(String query, List<Dish> allDishes) {
    _query = query.toLowerCase();
    _isSearching = query.isNotEmpty;

    if (_query.isEmpty) {
      _searchResults = []; // Clear results if query is empty
    } else {
      // Get all available dishes
      final allAvailableDishes = _getAllDishes();

      // Apply text search
      _searchResults = allAvailableDishes.where((dish) {
        return dish.name.toLowerCase().contains(_query) ||
            dish.description.toLowerCase().contains(_query) ||
            dish.restaurantName.toLowerCase().contains(_query) ||
            dish.category.toLowerCase().contains(_query);
      }).toList();

      // Apply price filter
      if (_minPrice != null) {
        _searchResults =
            _searchResults.where((dish) => dish.price >= _minPrice!).toList();
      }
      if (_maxPrice != null) {
        _searchResults =
            _searchResults.where((dish) => dish.price <= _maxPrice!).toList();
      }

      // Apply category filter
      if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
        _searchResults = _searchResults
            .where((dish) =>
                dish.category.toLowerCase() == _selectedCategory!.toLowerCase())
            .toList();
      }

      // Apply rating filter
      if (_minRating != null) {
        _searchResults =
            _searchResults.where((dish) => dish.rating >= _minRating!).toList();
      }
    }

    // Add to search history if not empty
    if (_query.isNotEmpty) {
      addToSearchHistory(_query);
    }

    notifyListeners();
  }

  void clearSearch() {
    _query = '';
    _searchResults = [];
    _isSearching = false;
    notifyListeners();
  }
}

// // Search Field Widget
