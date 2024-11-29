class Customer {
  String id;
  String name;
  String phone;
  String address;
  String email;
  String? documentId;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.email,
    this.documentId,
  });

  // Chuyển đổi từ Map (JSON) sang Customer
  factory Customer.fromJson(Map<String, dynamic> json, String documentId) {
    return Customer(
      id: documentId,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      email: json['email'] ?? '',
    );
  }

  // Chuyển đổi từ Customer sang Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'email': email,
    };
  }
}
