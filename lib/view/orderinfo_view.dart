import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:order_tracker/order_tracker.dart';
import 'package:store/model/order_model.dart';

class OrderinfoView extends StatelessWidget {
  final OrderModel order;

  OrderinfoView({required this.order});
  List<TextDto> orderList = [
    TextDto("Your order has been placed", null),
  ];

  List<TextDto> shippedList = [
    TextDto("Your order has been shipped", null),
  ];

  List<TextDto> outOfDeliveryList = [
    TextDto("Your order is out for delivery", null),
  ];

  List<TextDto> deliveredList = [
    TextDto("Your order has been delivered", null),
  ];

  List<TextDto> getOrderList(int status) {
    switch (status) {
      case 3:
        return deliveredList;
      case 2:
        return outOfDeliveryList;
      case 1:
        return shippedList;
      default:
        return orderList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Tracker"),
      ),
      body: SingleChildScrollView(
        // Ajoutez ceci
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                width: 300,
                child: Image.asset('images/ordertrack1.png')),
            Padding(
              padding: const EdgeInsets.all(20),
              child: OrderTracker(
                status: Status.values[order.status],
                activeColor: Colors.green,
                inActiveColor: Colors.grey[300],
                orderTitleAndDateList: getOrderList(order.status),
                shippedTitleAndDateList: order.status >= 1 ? shippedList : [],
                outOfDeliveryTitleAndDateList:
                    order.status >= 2 ? outOfDeliveryList : [],
                deliveredTitleAndDateList:
                    order.status >= 3 ? deliveredList : [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
