//defines what a product is

class Product {
  final String id;
  final String name;
  final String? brand;
  final String? flavor;
  final String? nicotineLevel;
  final int score;
  final String? comment;

  Product({
    required this.id,
    required this.name,
    this.brand,
    this.flavor,
    this.nicotineLevel,
    this.score = 0,
    this.comment,
  });

  factory Product.fromFirestore(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      name: data['name'] ?? '',
      brand: data['brand'],
      flavor: data['flavor'],
      nicotineLevel: data['nicotine_level'],
      score: data['score'] ?? 0,
      comment: data['comment'],
    );
  }
}
