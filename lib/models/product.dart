class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    this.quantity = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'imageUrl': imageUrl,
    'description': description,
    'quantity': quantity,
  };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: json['name'],
    price: json['price'],
    imageUrl: json['imageUrl'],
    description: json['description'],
    quantity: json['quantity'],
  );
}