import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:store/helper/constance.dart';
import 'package:store/view_model/cart_view_model.dart';
import 'package:store/view_model/checkout_view_model.dart';
import 'package:store/widgets/custom_text.dart';

class Summaryil extends StatelessWidget {
  const Summaryil({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GetBuilder<CartViewModel>(
        init: CartViewModel(),
        builder: (value) => Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: 350,
              padding: EdgeInsets.all(20),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Container(
                  child: Container(
                    width: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150,
                          height: 180,
                          child: Image.network(
                            value.model[index].image,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomText(
                          maxLine: 1,
                          overflow: TextOverflow.ellipsis,
                          text: value.model[index].name,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomText(
                          alignment: Alignment.bottomLeft,
                          text: 'quantity : ${value.model[index].quantity}',
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomText(
                          alignment: Alignment.bottomLeft,
                          color: primaryColor,
                          text: '${value.model[index].price} DH',
                        ),
                      ],
                    ),
                  ),
                ),
                itemCount: value.model.length,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: 15,
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: CustomText(
                text: "Shipping Adress",
                fontSize: 24,
              ),
            ),
            GetBuilder<CheckoutViewModel>(
                init: CheckoutViewModel(),
                builder: (controller) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomText(
                        fontSize: 24,
                        color: Colors.grey,
                        text:
                            '${controller.street1},${controller.street2},${controller.city},${controller.state},${controller.country}',
                      ),
                    ))
          ],
        ),
      ),
    );
  }
}
