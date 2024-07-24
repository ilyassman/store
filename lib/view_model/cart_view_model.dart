import 'package:get/get.dart';
import 'package:store/model/cart_product_model.dart';

import 'package:store/service/database/cart_database_helper.dart';

class CartViewModel extends GetxController {
  bool _isloading = true;
  bool get isloading => _isloading;
  double _totale = 0.0;
  double get totale => _totale;
  List<CartProductModel> _model = [];
  List<CartProductModel> get model => _model;
  CartViewModel() {
    getAllProduct();
  }
  getAllProduct() async {
    _isloading = true;
    var dbHelper = CartDatabaseHelper.db;
    // await Future.delayed(Duration(seconds: 2));
    _model = await dbHelper.getAllProduct();
    print("length of cart ${_model.length}");
    _isloading = false;
    getTotalPric();
    update();
  }

  deletProduct(String productId) async {
    var dbHelper = CartDatabaseHelper.db;
    await dbHelper.deletProduct(productId);
    _totale = 0;
    await getAllProduct();
  }

  getTotalPric() {
    for (int i = 0; i < _model.length; i++) {
      _totale += double.parse(_model[i].price) * _model[i].quantity;
    }
    print("le totale=${_totale}");
    update();
  }

  Future<void> addProduct(CartProductModel model) async {
    for (int i = 0; i < _model.length; i++) {
      if (_model[i].productId == model.productId) return;
    }
    var dbHelper = CartDatabaseHelper.db;
    await dbHelper.insert(model);
    update();
  }

  addtotal(int index) async {
    var dbHelper = CartDatabaseHelper.db;
    _model[index].quantity++;
    _totale += double.parse(_model[index].price);
    await dbHelper.updateProduct(_model[index]);
    update();
  }

  dectotal(int index) async {
    var dbHelper = CartDatabaseHelper.db;

    if (_model[index].quantity != 1) {
      _model[index].quantity--;
      _totale -= double.parse(_model[index].price);
      await dbHelper.updateProduct(_model[index]);
      update();
    }
  }
}
