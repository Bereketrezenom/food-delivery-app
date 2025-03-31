import 'package:auth_demo/screens/drawer/menu/menu_catagories.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Title
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Food Categories',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Menu Categories Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                MenuCategoryCard(
                  icon: Icons.local_pizza,
                  title: 'Pizza',
                  itemCount: 12,
                  color: Colors.red,
                  onTap: () => _navigateToCategoryDetail(context, 'Pizza'),
                ),
                MenuCategoryCard(
                  icon: Icons.fastfood,
                  title: 'Burgers',
                  itemCount: 8,
                  color: Colors.amber,
                  onTap: () => _navigateToCategoryDetail(context, 'Burgers'),
                ),
                MenuCategoryCard(
                  icon: Icons.kebab_dining,
                  title: 'BBQ',
                  itemCount: 6,
                  color: Colors.brown,
                  onTap: () => _navigateToCategoryDetail(context, 'BBQ'),
                ),
                MenuCategoryCard(
                  icon: Icons.bakery_dining,
                  title: 'Desserts',
                  itemCount: 10,
                  color: Colors.pink,
                  onTap: () => _navigateToCategoryDetail(context, 'Desserts'),
                ),
                MenuCategoryCard(
                  icon: Icons.local_bar,
                  title: 'Drinks',
                  itemCount: 14,
                  color: Colors.blue,
                  onTap: () => _navigateToCategoryDetail(context, 'Drinks'),
                ),
                MenuCategoryCard(
                  icon: Icons.soup_kitchen,
                  title: 'Soups',
                  itemCount: 5,
                  color: Colors.green,
                  onTap: () => _navigateToCategoryDetail(context, 'Soups'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Popular Items Section
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Popular Items',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Popular Menu Items List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final items = [
                  {'name': 'Special Pizza', 'price': '12.99', 'rating': '4.8'},
                  {'name': 'Beef Burger', 'price': '8.99', 'rating': '4.5'},
                  {
                    'name': 'Chicken Biryani',
                    'price': '14.99',
                    'rating': '4.7'
                  },
                  {
                    'name': 'Pasta Carbonara',
                    'price': '10.99',
                    'rating': '4.6'
                  },
                  {'name': 'Caesar Salad', 'price': '7.99', 'rating': '4.3'},
                ];
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCategoryDetail(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryDetailPage(category: category),
      ),
    );
  }

  void _navigateToItemDetail(BuildContext context, String itemName) {
    // This would eventually navigate to a detailed item page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You selected $itemName')),
    );
  }
}

class MenuCategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int itemCount;
  final Color color;
  final VoidCallback onTap;
  const MenuCategoryCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.itemCount,
    required this.color,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$itemCount items',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
