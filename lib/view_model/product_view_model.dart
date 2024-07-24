import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:store/helper/extenstion.dart';
import 'package:store/model/product_model.dart';
import 'package:store/service/home_services.dart';

class ProductViewModel extends GetxController {
  List<ProductModel> _products = [];
  bool _isloading = true;
  bool get isloading => _isloading;
  final CollectionReference _ProductCollectionRef =
      FirebaseFirestore.instance.collection('Products');
  List<ProductModel> filteredProducts = [];
  List<ProductModel> get products => _products;
  String searchQuery = '';

  void updateSearchQuery(String query) {
    searchQuery = query;
    print(query);
    filterProducrs();
    update();
  }

  void filterProducrs() {
    if (searchQuery.isEmpty) {
      filteredProducts = List.from(_products);
    } else {
      filteredProducts = _products
          .where((user) =>
              user.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
  }

  ProductViewModel() {
    getProducts();
  }
  addPorudct(ProductModel product) async {
    _ProductCollectionRef.add(product.toJson2()).then((value) {
      _ProductCollectionRef.doc(value.id)
          .update({'productId': FieldValue.delete()});
    });
    getProducts();
  }

  Future<Map<String, dynamic>?> getProduct(String id) async {
    DocumentSnapshot document = await _ProductCollectionRef.doc(id).get();
    if (document.exists) {
      return document.data() as Map<String, dynamic>?;
    }
    return null;
  }

  updateProcut(Map<String, dynamic> product) async {
    await _ProductCollectionRef.doc(product['id']).update({
      "name": product['name'],
      "description": product['description'],
      "color": HexColor.colorToHex(product['color']),
      "price": product['price'],
      "categorie": product['categorie'],
    });
    getProducts();
  }

  getProducts() async {
    _products = [];
    _isloading = true;
    await HomeService().getBestSelling().then((value) async {
      for (int i = 0; i < value.length; i++) {
        var productData = value[i].data() as Map<String, dynamic>;
        await FirebaseFirestore.instance
            .collection('Categories')
            .doc(productData['categorie'])
            .get()
            .then((valueCateg) {
          var CategData = valueCateg.data() as Map<String, dynamic>;
          List<String> imageList =
              List<String>.from(productData['image'] as List<dynamic>);
          _products.add(ProductModel(
              name: productData['name'],
              image: imageList,
              description: productData['description'],
              color: HexColor.fromHex(productData['color']),
              sized: productData['sized'],
              price: productData['price'],
              productId: value[i].id,
              categorie: CategData['nom']));
        });
      }
      _isloading = false;
      filteredProducts = List.from(_products);
      print("product length:${filteredProducts.length}");
    });

    update();
  }

  deletProduct(String id) async {
    _ProductCollectionRef.doc(id).delete();
  }
}
