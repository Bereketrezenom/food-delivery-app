import 'package:auth_demo/models/dishmodel.dart';
import 'package:flutter/material.dart';
import 'package:auth_demo/screens/drawer/menu/catagoriescard.dart';

class CategoryDetailPage extends StatelessWidget {
  final String category;

  const CategoryDetailPage({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate different menu items based on the category
    final List<Dish> items = _getCategoryItems(category);

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header banner for category
            Container(
              width: double.infinity,
              height: 150,
              color: _getCategoryColor(category),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getCategoryIcon(category),
                      size: 60,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${items.length} items available',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Item list with grid layout
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Available Options',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return CategoryItemCard(
                        name: items[index].name,
                        price: items[index].price.toString(),
                        rating: items[index].rating.toString(),
                        onTap: () {
                          // Show a snackbar when an item is tapped
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added ${items[index].name}'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to get the appropriate icon for the category
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'pizza':
        return Icons.local_pizza;
      case 'burgers':
        return Icons.fastfood;
      case 'bbq':
        return Icons.kebab_dining;
      case 'desserts':
        return Icons.bakery_dining;
      case 'drinks':
        return Icons.local_bar;
      case 'soups':
        return Icons.soup_kitchen;
      default:
        return Icons.restaurant_menu;
    }
  }

  // Helper method to get the appropriate color for the category
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'pizza':
        return Colors.red;
      case 'burgers':
        return Colors.amber;
      case 'bbq':
        return Colors.brown;
      case 'desserts':
        return Colors.pink;
      case 'drinks':
        return Colors.blue;
      case 'soups':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  // Helper method to generate different items based on the category
  List<Dish> _getCategoryItems(String category) {
    switch (category.toLowerCase()) {
      case 'pizza':
        return [
          Dish(
            id: 1,
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
            id: 2,
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
          // Add more pizza dishes...
        ];
      case 'burgers':
        return [
          Dish(
            id: 1,
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
          // Add more burger dishes...
        ];
      case 'bbq':
        return [
          Dish(
            id: 3,
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
          // Add more BBQ dishes...
        ];
      default:
        return [];
    }
  }
}
