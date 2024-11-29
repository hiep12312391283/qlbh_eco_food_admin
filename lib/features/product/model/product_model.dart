class Product {
  String id;
  String name;
  String category;
  double price;
  String description;
  int stock;
  DateTime entryDate;
  DateTime expiryDate;
  String imageBase64;
  String? documentId; // Thêm thuộc tính này

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.stock,
    required this.entryDate,
    required this.expiryDate,
    required this.imageBase64,
    this.documentId, // Cho phép documentId là null
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'description': description,
      'stock': stock,
      'entryDate': entryDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'imageBase64': imageBase64,
    };
  }
}
