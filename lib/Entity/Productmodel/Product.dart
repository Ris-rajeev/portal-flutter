class Product {
  int id;
  String name;
  String address;
  String description;
  String pincode;
  String mobno;
  String email;

  Product(
      {required this.id,
      required this.name,
      required this.address,
      required this.description,
      required this.email,
      required this.mobno,
      required this.pincode});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'No name provided',
      address: json['address'] ?? 'No address provided',
      description: json['description'] ?? 'No description provided',
      email: json['email'] ?? 'No email provided',
      mobno: json['mobno'] ?? 'No mobno provided',
      pincode: json['pincode'] ?? 'No pincode provided',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'description': description,
      'email': email,
      'mobno': mobno,
      'pincode': pincode,
    };
  }

  int get productId => id;
}
