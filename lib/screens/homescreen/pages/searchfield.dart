import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50, // Equal height for the search field and button
            child: TextFormField(
              onChanged: (value) {},
              decoration: InputDecoration(
                filled: true,
                hintStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                fillColor: const Color.fromARGB(255, 255, 255, 255),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), // More rounded
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                hintText: "Search dishes or restaurants",
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Color.fromARGB(
                        255, 255, 255, 255), // Circular button background
                    child:
                        Icon(Icons.search, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8), // Space between search field and button
        Container(
          height: 50, // Same height as the search field
          decoration: BoxDecoration(
            color: const Color.fromARGB(
                255, 255, 255, 255), // Square button background
            borderRadius: BorderRadius.circular(8), // Square edges
          ),
          child: IconButton(
            icon: const Icon(Icons.tune,
                color: Color.fromARGB(255, 0, 0, 0)), // Mixer/tune icon
            onPressed: () {
              // Add functionality for the button here (filter/toggle etc.)
            },
          ),
        ),
      ],
    );
  }
}
