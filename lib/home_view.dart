import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:shimmer/shimmer.dart';
import 'package:store/view/AllProduct_view.dart';
import 'package:store/view_model/control_view_model.dart';
import 'package:store/view_model/home_view_model.dart';
import 'package:store/widgets/custom_text.dart';
import 'package:store/view/daetilas_view.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeViewModel>(
      init: HomeViewModel(),
      builder: (value) => Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 100, left: 20, right: 20),
            child: Column(children: [
              _searchTextFormField(),
              SizedBox(
                height: 30,
              ),
              CustomText(
                text: "Categories",
              ),
              SizedBox(
                height: 30,
              ),
              _listViewCategory(),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Best Selling",
                    fontSize: 18,
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(
                        
                        AllProductView(),
                        arguments: "0",
                      );
                    },
                    child: CustomText(
                      text: "See all",
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              _listViewProducts(),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _searchTextFormField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade200,
      ),
      child: TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _listViewCategory() {
    return GetBuilder<HomeViewModel>(
      init: HomeViewModel(),
      builder: (value) => value.isloading['categ']!
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 100,
                child: ListView.separated(
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey.shade100,
                          ),
                          height: 60,
                          width: 60,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 60,
                          height: 10,
                          color: Colors.grey[300],
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    width: 20,
                  ),
                ),
              ),
            )
          : Container(
              height: 100,
              child: ListView.separated(
                itemCount: value.catgories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(
                            AllProductView(),
                            arguments: value.catgories[index].id,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey.shade100,
                          ),
                          height: 60,
                          width: 60,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(value.catgories[index].image),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomText(
                        text: value.catgories[index].nom,
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) => SizedBox(
                  width: 20,
                ),
              ),
            ),
    );
  }

  Widget _listViewProducts() {
    return GetBuilder<HomeViewModel>(
      init: HomeViewModel(),
      builder: (value) => value.isloading['bestsell']!
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 350,
                child: ListView.separated(
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: Container(
                        width: MediaQuery.of(context).size.width * .4,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.grey.shade100,
                              ),
                              child: Container(
                                  height: 220,
                                  width: MediaQuery.of(context).size.width * .4,
                                  child: Container(
                                    color: Colors.grey[300],
                                  )),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: 100,
                              height: 10,
                              color: Colors.grey[300],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 200,
                              height: 10,
                              color: Colors.grey[300],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    width: 20,
                  ),
                ),
              ),
            )
          : Container(
              height: 350,
              child: ListView.separated(
                itemCount: value.products.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(DetailsView(model: value.products[index]));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * .4,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey.shade100,
                            ),
                            child: Container(
                                height: 220,
                                width: MediaQuery.of(context).size.width * .4,
                                child: Image.network(
                                  value.products[index].image[0],
                                  fit: BoxFit.fill,
                                )),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomText(
                            text: value.products[index].name,
                            alignment: Alignment.bottomLeft,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: CustomText(
                              text: value.products[index].description,
                              color: Colors.grey,
                              alignment: Alignment.bottomLeft,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomText(
                            text: "${value.products[index].price} DH",
                            color: Colors.green,
                            alignment: Alignment.bottomLeft,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(
                  width: 20,
                ),
              ),
            ),
    );
  }
}
