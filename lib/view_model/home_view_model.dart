import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:store/model/categ_model.dart';
import 'package:store/model/product_model.dart';
import 'package:store/service/home_services.dart';

class HomeViewModel extends GetxController {
  List<CategoryModel> _catgories = [];
  List<ProductModel> _products = [];
  Map<String, bool> _isloading = {'categ': true, 'bestsell': true};
  Map<String, bool> get isloading => _isloading;
  List<CategoryModel> get catgories => _catgories;
  List<ProductModel> get products => _products;
  final CollectionReference _categoryCollectionRef =
      FirebaseFirestore.instance.collection('Categories');
  HomeViewModel() {
    getCategory();
    getBestSellingProducts();
  }
  getCategory() async {
    _isloading['categ'] = true;
    // await Future.delayed(Duration(seconds: 2));
    await _categoryCollectionRef.get().then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        _catgories.add(CategoryModel.fromJson(
            value.docs[i].data() as Map<String, dynamic>, value.docs[i].id));
      }
      print("catge lenght:${_catgories.length}");
      _isloading['categ'] = false;
    });
    update();
  }

  getBestSellingProducts() async {
    _isloading['bestsell'] = true;

    await HomeService().getBestSelling().then((value) {
      for (int i = 0; i < value.length; i++) {
        _products.add(ProductModel.fromJson(
            value[i].data() as Map<String, dynamic>, value[i].id));
      }
      print("product length:${_products.length}");
      _isloading['bestsell'] = false;
    });

    update();
  }
}
