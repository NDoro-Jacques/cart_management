class Panier {
  int id;
  String title;
  double price;
  String description;
  String category;
  String image;
  int quantity;

  Panier({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.quantity
  });

  factory Panier.fromJson(Map<String, dynamic> jsonData) {
    return Panier(
        id: jsonData['id'],
        title: jsonData['title'],
        price: jsonData['price'],
        description: jsonData['description'],
        category: jsonData['category'],
        image: jsonData['image'],
        quantity: jsonData['quantity']
    );
  }

  Panier.fromMap(Map<dynamic, dynamic> jsonData)
      : id = jsonData['id'],
        title = jsonData['title'],
        price = jsonData['price'],
        description = jsonData['description'],
        category = jsonData['category'],
        image = jsonData['image'],
        quantity = jsonData['quantity']
  ;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'quantity': quantity
    };
  }
}
