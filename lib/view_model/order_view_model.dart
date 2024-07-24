import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:store/model/order_model.dart';

class OrderViewModel extends GetxController {
  List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;
  bool _isloading = true;
  bool get isloading => _isloading;

  OrderViewModel() {
    getOrder();
  }

  final CollectionReference _ordersCollectionRef =
      FirebaseFirestore.instance.collection('Orders');

  Future<void> getOrder() async {
    _isloading = true;
    try {
      final querySnapshot = await _ordersCollectionRef
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
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
