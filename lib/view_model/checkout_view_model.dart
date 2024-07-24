import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CheckoutViewModel extends GetxController {
  late String street1, street2, city, state, country,date;
  GlobalKey<FormState> formState = GlobalKey();
}
