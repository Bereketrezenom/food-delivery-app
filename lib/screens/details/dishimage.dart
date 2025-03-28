import 'package:flutter/material.dart';
import 'package:auth_demo/models/dishmodel.dart';
import 'package:auth_demo/screens/cart/cart.dart';
import 'package:auth_demo/screens/cart/cartservices.dart';
import 'package:auth_demo/screens/details/additionaldetail.dart';
import 'package:auth_demo/screens/details/dishdiscription.dart';
import 'package:auth_demo/screens/details/dishimage.dart';
import 'package:auth_demo/screens/details/top_rounded_container.dart';

class DishImages extends StatefulWidget {
  const DishImages({super.key, required this.dish});

  final Dish dish;

  @override
  _DishImagesState createState() => _DishImagesState();
}

class _DishImagesState extends State<DishImages> {
  int selectedImage = 0;
  late List<String> imageList;

  @override
  void initState() {
    super.initState();
    imageList = [
      widget.dish.image,
      "https://img.lovepik.com/photo/48004/8609.jpg_wh860.jpg",
      "https://thumbs.dreamstime.com/b/flying-burger-white-background-165822607.jpg",
    ];
  }

  void _onSwipeLeft() {
    setState(() {
      if (selectedImage < imageList.length - 1) {
        selectedImage++;
      }
    });
  }

  void _onSwipeRight() {
    setState(() {
      if (selectedImage > 0) {
        selectedImage--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              _onSwipeLeft();
            } else if (details.primaryVelocity! > 0) {
              _onSwipeRight();
            }
          },
          child: SizedBox(
            width: 400,
            height: 300,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(218, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageList[selectedImage],
                    fit: BoxFit.cover,
                    key: ValueKey(selectedImage),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(
              imageList.length,
              (index) => SmallDishImage(
                isSelected: index == selectedImage,
                press: () => setState(() => selectedImage = index),
                image: imageList[index],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SmallDishImage extends StatelessWidget {
  const SmallDishImage({
    super.key,
    required this.isSelected,
    required this.press,
    required this.image,
  });

  final bool isSelected;
  final VoidCallback press;
  final String image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(8),
        height: 10,
        width: 10,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isSelected ? Colors.orange : Colors.transparent, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(image, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
