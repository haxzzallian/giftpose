class ProductReview {
  final int rating;
  final String comment;
  final String date;
  final String reviewerName;

  ProductReview({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      date: json['date'] ?? '',
      reviewerName: json['reviewerName'] ?? '',
    );
  }
}

class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String? brand;
  final String sku;
  final String availabilityStatus;
  final List<String> images;
  final String thumbnail;
  // Detail fields
  final String? warrantyInformation;
  final String? shippingInformation;
  final String? returnPolicy;
  final int? minimumOrderQuantity;
  final List<ProductReview> reviews;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    this.brand,
    required this.sku,
    required this.availabilityStatus,
    required this.images,
    required this.thumbnail,
    this.warrantyInformation,
    this.shippingInformation,
    this.returnPolicy,
    this.minimumOrderQuantity,
    this.reviews = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      stock: json['stock'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      brand: json['brand'],
      sku: json['sku'] ?? '',
      availabilityStatus: json['availabilityStatus'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      thumbnail: json['thumbnail'] ?? '',
      warrantyInformation: json['warrantyInformation'],
      shippingInformation: json['shippingInformation'],
      returnPolicy: json['returnPolicy'],
      minimumOrderQuantity: json['minimumOrderQuantity'],
      reviews: (json['reviews'] as List<dynamic>? ?? [])
          .map((r) => ProductReview.fromJson(r))
          .toList(),
    );
  }

  double get discountedPrice => price - (price * discountPercentage / 100);
}
