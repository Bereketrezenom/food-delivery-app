import 'package:flutter/material.dart';

class FoodCategories extends StatefulWidget {
  const FoodCategories({super.key});

  @override
  _FoodCategoriesState createState() => _FoodCategoriesState();
}

class _FoodCategoriesState extends State<FoodCategories> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CategoryCard(
                  imageUrl:
                      'https://t4.ftcdn.net/jpg/03/21/32/45/360_F_321324549_3utrdpZOFdsyUElymaPhm5LXRyTpnteh.jpg',
                  text: "Burgers",
                  isSelected: _selectedIndex == 0,
                  press: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                ),
                const SizedBox(width: 20), // Space between cards
                CategoryCard(
                  imageUrl:
                      'https://thumbs.dreamstime.com/b/fresh-tasty-pizza-white-background-clipping-path-included-85746388.jpg',
                  text: "Pizza",
                  isSelected: _selectedIndex == 1,
                  press: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                ),
                const SizedBox(width: 20), // Space between cards
                CategoryCard(
                  imageUrl:
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTRXxMDpOMlJaBEOqgTq0-Fenh6-4lTwGgAmQ&s',
                  text: "Burrito",
                  isSelected: _selectedIndex == 2,
                  press: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                ),
                const SizedBox(width: 20), // Space between cards
                CategoryCard(
                  imageUrl:
                      'https://media.istockphoto.com/id/490653943/photo/sandwich.jpg?s=612x612&w=0&k=20&c=Y-olXF7vNJQ4b0bXZxa5XNVko64NyQ1YXGzcJWW2mW0=',
                  text: "Sandwich",
                  isSelected: _selectedIndex == 3,
                  press: () {
                    setState(() {
                      _selectedIndex = 3;
                    });
                  },
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.imageUrl,
    required this.text,
    required this.press,
    required this.isSelected,
  });

  final String imageUrl;
  final String text;
  final GestureTapCallback press;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            height: 50, // Increased height to fill the space
            width: 180, // Adjusted width for better spacing
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color.fromARGB(255, 242, 35, 35)
                  : const Color.fromARGB(255, 255, 255, 255), 
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Space between image and text
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis, // Ensure text fits well
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
