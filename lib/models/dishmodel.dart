class Dish {
  final int id;
  final String name;
  final String description;
  final String image;
  final List<String> images; // For image carousel
  final double price;
  final double rating;
  final int cookingTime; // For cooking time display
  bool isFavorite;

  final int kcal;
  final String restaurantName;
  final String distance;
  final String size;
  int quantity;

  Dish({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.images,
    required this.price,
    required this.cookingTime,
    this.rating = 4.8,
    this.isFavorite = false,
    required this.kcal,
    required this.restaurantName,
    required this.distance,
    required this.size,
    this.quantity = 1,
  });

  Dish copyWith({int? quantity}) {
    return Dish(
      id: id,
      name: name,
      description: description,
      image: image,
      images: images,
      price: price,
      cookingTime: cookingTime,
      rating: rating,
      isFavorite: isFavorite,
      kcal: kcal,
      restaurantName: restaurantName,
      distance: distance,
      size: size,
      quantity: quantity ?? this.quantity,
    );
  }
}

List<Dish> demoDishes = [
  Dish(
    id: 1,
    name: "Hamburger",
    description:
        "This classic Hamburger is a timeless favorite that never goes out of style. It features a perfectly baked crust topped with marinara sauce, generous slices of pepperoni, and gooey mozzarella cheese. Each bite delivers a savory blend of flavors, making it a crowd-pleaser for pizza lovers of all ages. Whether you're enjoying it as a quick meal or serving it at a party, this pizza never disappoints. Pair it with a side of garlic bread and a refreshing drink for the ultimate experience. The combination of crispy crust, tangy sauce, spicy pepperoni, and melted cheese creates a symphony of flavors that will leave you craving more. Perfect for any occasion, this Pepperoni Pizza is sure to satisfy your hunger and delight your taste buds.",
    image:
        "https://ifoodreal.com/wp-content/uploads/2023/06/fg-grilled-chicken-burger.jpg",
    images: [
      "https://ifoodreal.com/wp-content/uploads/2023/06/fg-grilled-chicken-burger.jpg",
      "https://www.foodandwine.com/thmb/Wd4lBRZz3X_8qBr69UOu2m7I2iw=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/classic-cheese-pizza-FT-RECIPE0422-31a2c938fc2546c9a07b7011658cfd05.jpg",
      "https://www.simplyrecipes.com/thmb/8caxM88NgxZjz-T2aeRW3xjhzBg=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__simply_recipes__uploads__2019__09__easy-pepperoni-pizza-lead-3-8f256746d649404baa36a44d271329bc.jpg"
    ],
    price: 12.49,
    cookingTime: 25,
    rating: 4.8,
    isFavorite: true,
    kcal: 554,
    restaurantName: 'Rose Garden Kitchen',
    distance: '4 km',
    size: '',
  ),
  Dish(
    id: 2,
    name: "Cheeseburger",
    description:
        "This juicy Cheeseburger is crafted with a perfectly seasoned beef patty, topped with melted cheddar cheese, crispy onions, fresh lettuce, ripe tomatoes, and a dollop of tangy mayonnaise. The combination of flavors and textures creates a mouthwatering experience that satisfies every craving. Served on a toasted brioche bun, this burger is a classic choice for any occasion. Whether you're grabbing a quick lunch or hosting a backyard barbecue, this Cheeseburger is sure to impress. Pair it with golden fries and a cold beverage for the ultimate indulgence. The rich, savory flavor of the beef patty, combined with the creamy melted cheese and crunchy onions, makes every bite a delightful experience. Perfectly balanced and packed with flavor, this Cheeseburger is a must-try for burger enthusiasts.",
    image:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZuHTiGWB-2IMLv4VAejR5Ts6KZI59xcNmMQ&s",
    images: [
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZuHTiGWB-2IMLv4VAejR5Ts6KZI59xcNmMQ&s",
      "https://www.allrecipes.com/thmb/9jIX2qXjfzN-M5nzwDEW0UtprhQ=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/25473-the-perfect-basic-burger-DDMFS-4x3-550e3c5381d64b4c9aa97f6c01e787ca.jpg",
      "https://assets.epicurious.com/photos/5c745a108918ee7ab68daf79/16:9/w_2993,h_1683,c_limit/Smashburger-recipe-120219.jpg"
    ],
    price: 8.99,
    cookingTime: 15,
    rating: 4.5,
    kcal: 450,
    restaurantName: 'Rose Garden Kitchen',
    distance: '3 km',
    size: '',
  ),
];
List<Dish> cartItems = [];
