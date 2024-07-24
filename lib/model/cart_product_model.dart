class CartProductModel {
  late String name, price, image, productId;

  late int quantity;
  CartProductModel({
    required this.name,
    required this.image,
    required this.quantity,
    required this.price,
    required this.productId,
  });

  CartProductModel.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }

    name = map['name'] ?? '';
    image = map['image'] ?? '';
    quantity = map['quantity'] ?? '';
    price = map['price'] ?? '';
    productId = map['productId'] ?? '';
  }

  toJson() {
    return {
      'name': name,
      'image': image,
      'quantity': quantity,
      'price': price,
      'productId':productId,
    };
  }
}
