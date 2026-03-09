class Product {
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.description,
    this.category,
  });

  final int id;
  final String title;
  final double price;
  final String imageUrl;
  final String? description;
  final String? category;
}
