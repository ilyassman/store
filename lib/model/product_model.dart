import 'package:flutter/cupertino.dart';
import 'package:store/helper/extenstion.dart';

class ProductModel {
  late String name, description, sized, price, productId, categorie;
  late List<String> image = [];

  late Color color;
  
  ProductModel(
      {required this.name,
      required this.image,
      required this.description,
      required this.color,
      required this.sized,
      required this.price,
      required this.categorie, required  this.productId});

  ProductModel.fromJson(Map<String, dynamic> map, String documentId) {
    name = map['name'] ?? '';
    for (int i = 0; i < map['image'].length; i++) {
      image.add(map['image'][i]);
    }
    description = map['description'] ?? '';
    color = HexColor.fromHex(map['color']);
    sized = map['sized'] ?? '';
    price = map['price'] ?? '';
    categorie = map['categorie'] ?? '';
    productId = documentId;
  }

  toJson() {
    return {
      'name': name,
      'image': image,
      'description': description,
      'color': color,
      'sized': sized,
      'price': price,
      'productId': productId,
      'categorie': categorie,
    };
  }
  toJson2() {
    return {
      'name': name,
      'image': image,
      'description': description,
      'color': HexColor.colorToHex(color),
      'sized': sized,
      'price': price,
      'categorie': categorie,
    };
  }
}
