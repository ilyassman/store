import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:store/home_view.dart';
import 'package:store/model/order_model.dart';
import 'package:store/service/database/cart_database_helper.dart';
import 'package:store/view/checkout/add_address.dart';
import 'package:store/view/checkout/delevery_time.dart';
import 'package:store/view/checkout/summary.dart';
import 'package:store/view_model/cart_view_model.dart';
import 'package:store/view_model/checkout_view_model.dart';
import 'package:store/view_model/control_view_model.dart';
import 'package:store/view_model/profil_view_model.dart';
import 'package:store/widgets/custom_text.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CheckoutView(),
    );
  }
}

class CheckoutView extends StatefulWidget {
  @override
  _CheckoutViewState createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  int _activeStep = 0;

  void _nextStep() {
    setState(() {
      if (_activeStep < 2) {
        _activeStep++;
      }
    });
  }

  void _previousStep() {
    setState(() {
      if (_activeStep > 0) {
        _activeStep--;
      }
    });
  }

  Widget _getStepContent() {
    switch (_activeStep) {
      case 0:
        return DeliveryTime();
      case 1:
        return AddAddress();
      case 2:
        return Summaryil();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CheckOut'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: GetBuilder<CheckoutViewModel>(
        init: CheckoutViewModel(),
        builder: (controller) => GetBuilder<CartViewModel>(
          init: CartViewModel(),
          builder: (controller2) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Ligne horizontale
                    Container(
                      height: 2,
                      color: Colors.grey.shade300,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStepItem('Delivery', _activeStep >= 0),
                        _buildStepItem('Address', _activeStep >= 1),
                        _buildStepItem('Summary', _activeStep >= 2),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _getStepContent(),
              ),
              Row(
                children: [
                  _activeStep > 0
                      ? Container(
                          width:
                              150, // Réduire la largeur pour éviter le débordement
                          height: 60, // Hauteur fixe pour les deux boutons
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.grey,
                              padding:
                                  EdgeInsets.zero, // Enlever le padding interne
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: _previousStep,
                            child: Center(
                              child: CustomText(
                                alignment: Alignment.center,
                                text: "Back",
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: 200,
                        ),
                  GetBuilder<ProfilViewModel>(
                    init: ProfilViewModel(),
                    builder: (value) => Padding(
                      padding: const EdgeInsets.only(left: 70),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Flexible(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Color.fromRGBO(0, 197, 105, 1),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                minimumSize:
                                    Size(100, 50), // Taille minimale ajustée
                              ),
                              onPressed: () {
                                if (_activeStep == 2) {
                                  CollectionReference orders = FirebaseFirestore
                                      .instance
                                      .collection('Orders');

                                  List products = controller2.model
                                      .map((product) => product.toJson())
                                      .toList();
                                  print(controller.date);
                                  orders.add({
                                    'products': products,
                                    'adress':
                                        '${controller.street1},${controller.street2},${controller.city},${controller.state},${controller.country}',
                                    'userId':
                                        FirebaseAuth.instance.currentUser!.uid,
                                    'total': controller2.totale,
                                    'date': controller.date,
                                    'nomclient': value.userModel.name,
                                    'status': 0,
                                  }).then((value) => {print("order added")});
                                  var dbHelper = CartDatabaseHelper.db;
                                  dbHelper.deletcart();
                                  Get.find<ControlViewModel>()
                                      .changeSelectedValue(0);
                                  Get.back();
                                }
                                if (_activeStep == 1)
                                  controller.formState.currentState?.save();

                                _nextStep();
                              },
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: CustomText(
                                  alignment: Alignment.center,
                                  text: (_activeStep == 2) ? "Finish" : "Next",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepItem(String title, bool isActive) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.green : Colors.grey,
          ),
          child: isActive
              ? Icon(Icons.check, color: Colors.white, size: 16)
              : null,
        ),
        SizedBox(height: 4),
        Text(title,
            style: TextStyle(color: isActive ? Colors.green : Colors.grey)),
      ],
    );
  }
}
