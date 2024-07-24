import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:store/model/order_model.dart';

class OrderadminViewModel extends GetxController {
  List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;
  bool _isloading = true;
  bool get isloading => _isloading;

  final CollectionReference _ordersCollectionRef =
      FirebaseFirestore.instance.collection('Orders');
  OrderadminViewModel() {
    getOrders();
  }
  void updateOrderStatus(String orderIndex, int newStatus) async {
    await _ordersCollectionRef
        .doc(orderIndex)
        .update({'status': newStatus}).then((value) {
      getOrders();
    });
  }

  getOrders() async {
    _isloading = true;
    try {
      final querySnapshot = await _ordersCollectionRef.get();
      _orders.clear(); // Clear existing orders before adding new ones

      querySnapshot.docs.forEach((doc) {
        _orders.add(
            OrderModel.fromJson(doc.data() as Map<String, dynamic>, doc.id));
      });
      _isloading = false;

      print("Number of orders loaded: ${_orders.length}");
    } catch (e) {
      print("Error fetching orders: $e");
    }

    update();
  }
}
