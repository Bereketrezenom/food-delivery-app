// // models/menu_item_model.dart
// class MenuItemModel {
//   final String id;
//   final String name;
//   final String price;
//   final String rating;

//   MenuItemModel({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.rating,
//   });

//   // Factory method to create a MenuItemModel from a map
//   factory MenuItemModel.fromMap(Map<String, dynamic> map, String categoryId) {
//     return MenuItemModel(
//       id: '${categoryId}_${map['name']}', // Unique ID based on category and name
//       name: map['name'],
//       price: map['price'],
//       rating: map['rating'],
//     );
//   }

//   // Convert MenuItemModel back to a map (optional)
//   Map<String, dynamic> toMap() {
//     return {
//       // 'id': id,
//       'name': name,
//       'price': price,
//       'rating': rating,
//     };
//   }
// }
