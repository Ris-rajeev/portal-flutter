class Product {
  int id;
  String name;
  String address;
  String description;

  Product(
      {required this.id,
      required this.name,
      required this.address,
      required this.description});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'description': description,
    };
  }

  int get productId => id;
}
