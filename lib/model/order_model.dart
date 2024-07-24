class OrderModel {
  late String date;
  late String id;
  late double total;
  late int status;
  late String user;
  late String adresse;
  late String nomclient;
  late List<ProductModel1> products = [];

  OrderModel({
    required this.date,
    required this.total,
    required this.products,
    required this.id,
    required this.status,
  });

  OrderModel.fromJson(Map<String, dynamic> map, String id) {
    date = map['date'] ?? '';
    total = (map['total'] ?? 0).toDouble();
    status = map['status'] ?? 0;
    adresse = map['adress'] ?? '';
    user = map['userId'];
    nomclient = map['nomclient'];

    this.id = id;

    if (map['products'] != null) {
      if (map['products'] is List && map['products'].isNotEmpty) {
        products = List<ProductModel1>.from(map['products'].map((productMap) =>
            ProductModel1.fromJson(
                productMap))); // Utilisation de ProductModel.fromJson pour créer chaque produit
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'total': total,
      'products': products.map((product) => product.toJson()).toList(),
      'id': id,
      'status': status,
      'adress': adresse,
      'nomclient': nomclient,
      'user': user,
    };
  }
}

class ProductModel1 {
  late String image;
  late String name;
  late String price;
  late String productId;
  late int quantity;

  ProductModel1({
    required this.image,
    required this.name,
    required this.price,
    required this.productId,
    required this.quantity,
  });

  ProductModel1.fromJson(Map<String, dynamic> map) {
    image = map['image'] ?? '';
    name = map['name'] ?? '';
    price = map['price'] ?? '';
    productId = map['productId'] ?? '';
    quantity = map['quantity'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
      'price': price,
      'productId': productId,
      'quantity': quantity,
    };
  }
}
