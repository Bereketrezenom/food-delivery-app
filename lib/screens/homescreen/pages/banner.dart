import 'package:flutter/material.dart';

class FoodDiscountBanner extends StatelessWidget {
  const FoodDiscountBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text.rich(
                  TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Deals for Days\n",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            "Get \$0 delivery fee on your first order over \$10!\n",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add your action here
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text("Learn more"),
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 20),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(8), // Adjust the radius here
                child: Image.network(
                  'https://images.unsplash.com/photo-1571091718767-18b5b1457add?ixid=M3wzNjM5Nzd8MHwxfHNlYXJjaHwxfHxiaXVyZ2VyfGVufDB8fHx8MTcxNzcyNDM2N3ww&ixlib=rb-4.0.3&w=400',
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              )),
        ],
      ),
    );
  }
}
