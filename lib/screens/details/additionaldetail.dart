import 'package:flutter/material.dart';

class AdditionalDetails extends StatelessWidget {
  final int kcal;
  final String distance;
  final int cookingTime;

  const AdditionalDetails({
    Key? key,
    required this.kcal,
    required this.distance,
    required this.cookingTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> ingredientImages = [
      "assets/images/crisps.png",
      "assets/images/cheese.png",
      "assets/images/meat.png",
      "assets/images/tomato.png",
      "assets/images/soy-sauce.png",
      "assets/images/boiled-egg.png",
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetricItem(Icons.location_on, Colors.red, "$distance km"),
                const Text('|',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                _buildMetricItem(
                    Icons.local_fire_department, Colors.orange, "$kcal kcal"),
                const Text('|',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                _buildMetricItem(
                    Icons.access_time, Colors.grey, "$cookingTime min"),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Ingredients",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12, // Space between items horizontally
                  runSpacing: 12, // Space between items vertically
                  children: ingredientImages
                      .map((image) => _buildIngredientCard(image))
                      .toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(IconData icon, Color color, String text) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientCard(String imagePath) {
    return Column(
      children: [
        Container(
          width: 30, // Smaller size
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: const Icon(Icons.image_not_supported, size: 24),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}
