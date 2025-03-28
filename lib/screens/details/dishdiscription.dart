import 'package:auth_demo/models/dishmodel.dart';
import 'package:auth_demo/screens/cart/cart.dart';
import 'package:auth_demo/screens/cart/cartservices.dart';
import 'package:auth_demo/screens/details/additionaldetail.dart';
import 'package:auth_demo/screens/details/dishdiscription.dart';
import 'package:auth_demo/screens/details/dishimage.dart';
import 'package:auth_demo/screens/details/top_rounded_container.dart';
import 'package:flutter/material.dart';

class DishDescription extends StatelessWidget {
  const DishDescription({super.key, required this.dish});

  final Dish dish;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Price Row
          Row(
            children: [
              Text(
                dish.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              Text(
                '\$${dish.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Cooking Time, Restaurant Name, and Rating Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.red),
                  const SizedBox(width: 4),
                  Text(
                    dish.restaurantName,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  Text(
                    '${dish.rating}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Description Section with Expandable Text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Description",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              ExpandableText(
                text: dish.description,
                maxLines: 3,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Additional Details Section
          AdditionalDetails(
            kcal: dish.kcal,
            distance: dish.distance,
            cookingTime: dish.cookingTime,
          ),
        ],
      ),
    );
  }
}

// Expandable Text Widget
class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  const ExpandableText({
    Key? key,
    required this.text,
    this.maxLines = 3,
  }) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: _isExpanded ? null : widget.maxLines,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                height: 1.5,
              ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              _isExpanded ? 'Read Less' : 'Read More',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
