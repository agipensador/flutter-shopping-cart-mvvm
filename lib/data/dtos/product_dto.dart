import '../../domain/models/product.dart';

class ProductDto {
  ProductDto({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    this.description,
    this.category,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
      description: json['description'] as String?,
      category: json['category'] as String?,
    );
  }

  final int id;
  final String title;
  final double price;
  final String image;
  final String? description;
  final String? category;

  Product toEntity() {
    return Product(
      id: id,
      title: title,
      price: price,
      imageUrl: image,
      description: description,
      category: category,
    );
  }
}
