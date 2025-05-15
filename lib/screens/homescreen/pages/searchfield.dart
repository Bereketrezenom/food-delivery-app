// screens/homescreen/pages/searchfield.dart
import 'package:auth_demo/screens/details/dishdetal.dart';
import 'package:auth_demo/search/searchprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, child) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      onChanged: (value) {
                        searchProvider.search(value, []);
                      },
                      decoration: InputDecoration(
                        filled: true,
                        hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0)),
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
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
                            backgroundColor: Color.fromARGB(255, 255, 255, 255),
                            child: Icon(Icons.search,
                                color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ),
                        suffixIcon: searchProvider.isSearching
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  searchProvider.clearSearch();
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune,
                        color: Color.fromARGB(255, 0, 0, 0)),
                    onPressed: () {
                      searchProvider.toggleFilters();
                    },
                  ),
                ),
              ],
            ),

            // Advanced Filters
            if (searchProvider.showFilters)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Price Range Filter
                    const Text(
                      'Price Range',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Min',
                              prefixText: '\$',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                searchProvider.setPriceRange(
                                  double.tryParse(value),
                                  searchProvider.maxPrice,
                                );
                              } else {
                                searchProvider.setPriceRange(
                                  null,
                                  searchProvider.maxPrice,
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('-'),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Max',
                              prefixText: '\$',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                searchProvider.setPriceRange(
                                  searchProvider.minPrice,
                                  double.tryParse(value),
                                );
                              } else {
                                searchProvider.setPriceRange(
                                  searchProvider.minPrice,
                                  null,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Category Filter
                    const Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      hint: const Text('Select Category'),
                      value: searchProvider.selectedCategory,
                      items: ['Burgers', 'Pizza', 'Burrito', 'Sandwich', 'BBQ']
                          .map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        searchProvider.setCategory(value);
                      },
                    ),

                    const SizedBox(height: 16),

                    // Rating Filter
                    const Text(
                      'Minimum Rating',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<double>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      hint: const Text('Select Rating'),
                      value: searchProvider.minRating,
                      items: [4.0, 4.2, 4.5, 4.7, 4.8].map((rating) {
                        return DropdownMenuItem(
                          value: rating,
                          child: Text('$rating ★'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        searchProvider.setMinRating(value);
                      },
                    ),

                    const SizedBox(height: 16),

                    // Reset Filters Button
                    ElevatedButton(
                      onPressed: () {
                        searchProvider.resetFilters();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Reset Filters'),
                    ),
                  ],
                ),
              ),

            // Search History
            if (!searchProvider.isSearching &&
                searchProvider.searchHistory.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Searches',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            searchProvider.clearSearchHistory();
                          },
                          child: const Text('Clear All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...searchProvider.searchHistory
                        .map((query) => ListTile(
                              leading: const Icon(Icons.history),
                              title: Text(query),
                              trailing: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  searchProvider.removeFromSearchHistory(query);
                                },
                              ),
                              onTap: () {
                                searchProvider.search(query, []);
                              },
                            ))
                        .toList(),
                  ],
                ),
              ),

            // Search Results
            if (searchProvider.isSearching &&
                searchProvider.searchResults.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  children: searchProvider.searchResults
                      .map((dish) => ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(dish.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(dish.name),
                            subtitle: Text(dish.restaurantName),
                            trailing:
                                Text('\$${dish.price.toStringAsFixed(2)}'),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                DishDetailsScreen.routeName,
                                arguments: dish,
                              );
                            },
                          ))
                      .toList(),
                ),
              ),
          ],
        );
      },
    );
  }
}
