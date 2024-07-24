import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:store/helper/constance.dart';
import 'package:store/view_model/checkout_view_model.dart';
import 'package:store/widgets/custom_text.dart';

class DeliveryTime extends StatefulWidget {
  @override
  State<DeliveryTime> createState() => _DeliveryTimeState();
}

class _DeliveryTimeState extends State<DeliveryTime> {
  Delivery delivery = Delivery.StandardDelivery;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutViewModel>(
      init: CheckoutViewModel(),
      builder: (controller) => Expanded(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            RadioListTile<Delivery>(
              value: Delivery.StandardDelivery,
              groupValue: delivery,
              onChanged: (value) {
                controller.date = value.toString().split('.').last;
                setState(() {
                  delivery = value!;
                });
              },
              activeColor: Color.fromRGBO(0, 197, 105, 1),
              title: CustomText(
                text: "Standard Delivery",
                fontSize: 20,
              ),
              subtitle: CustomText(
                text: "\nOrder will be delivred between  3 - 5 business days",
              ),
            ),
            SizedBox(
              height: 40,
            ),
            RadioListTile<Delivery>(
              value: Delivery.NextDayDelivery,
              groupValue: delivery,
              onChanged: (value) {
                controller.date = value.toString().split('.').last;
                setState(() {
                  delivery = value!;
                });
              },
              activeColor: Color.fromRGBO(0, 197, 105, 1),
              title: CustomText(
                text: "Next Day Delivery",
                fontSize: 20,
              ),
              subtitle: CustomText(
                text:
                    "\nPlace your order before 6pm and your items will be delivered the next day",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
