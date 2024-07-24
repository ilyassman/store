import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:store/view/checkout/checkout_view.dart';
import 'package:store/view_model/cart_view_model.dart';
import 'package:store/widgets/custom_text.dart';

class CartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: GetBuilder<CartViewModel>(
                init: CartViewModel(),
                builder: (value) => value.isloading
                    ? Container(
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 140,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 140,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: 24,
                                              color: Colors.white,
                                            ),
                                            SizedBox(height: 10),
                                            Container(
                                              width: 100,
                                              height: 20,
                                              color: Colors.white,
                                            ),
                                            SizedBox(height: 20),
                                            Container(
                                              width: 140,
                                              height: 40,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: 3,
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 15,
                            );
                          },
                        ),
                      )
                    : value.model.isEmpty
                        ? Center(
                            child: Image(
                                image: AssetImage('images/empty_cart.png')),
                          )
                        : Container(
                            child: ListView.separated(
                              itemBuilder: (context, index) {
                                return Dismissible(
                                  key: Key(value.model[index].productId),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    value.deletProduct(
                                        value.model[index].productId);
                                  },
                                  background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: Container(
                                    height: 140,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 140,
                                          child: Image.network(
                                            value.model[index].image,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 30),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  text: value.model[index].name,
                                                  fontSize: 24,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLine: 1,
                                                ),
                                                SizedBox(height: 10),
                                                CustomText(
                                                    color: Color.fromRGBO(
                                                        0, 197, 105, 1),
                                                    text:
                                                        "${value.model[index].price.toString()} DH"),
                                                SizedBox(height: 20),
                                                Container(
                                                  width: 140,
                                                  color: Colors.grey[200],
                                                  height: 40,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          value.addtotal(index);
                                                        },
                                                        child: Icon(
                                                          Icons.add,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      SizedBox(width: 20),
                                                      CustomText(
                                                        alignment:
                                                            Alignment.center,
                                                        fontSize: 20,
                                                        color: Colors.black,
                                                        text: value.model[index]
                                                            .quantity
                                                            .toString(),
                                                      ),
                                                      SizedBox(width: 20),
                                                      InkWell(
                                                        onTap: () {
                                                          value.dectotal(index);
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 20),
                                                          child: Icon(
                                                            Icons.minimize,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: value.model.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(height: 15);
                              },
                            ),
                          ),
              ),
            ),
          ),
          GetBuilder<CartViewModel>(
            init: CartViewModel(),
            builder: (value) => value.model.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(left: 30, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            CustomText(
                              text: "TOTAL",
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 15),
                            CustomText(
                              text: '${value.totale.toString()} DH',
                              color: Color.fromRGBO(0, 197, 105, 1),
                              fontSize: 18,
                            ),
                          ],
                        ),
                        Container(
                          height: 100,
                          width: 180,
                          padding: EdgeInsets.all(20),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Color.fromRGBO(0, 197, 105, 1),
                              padding: EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () {
                              Get.to(CheckoutView());
                            },
                            child: CustomText(
                              alignment: Alignment.center,
                              text: "CHECKOUT",
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
