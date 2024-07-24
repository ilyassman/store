import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:store/home_view.dart';
import 'package:store/view/cart_view.dart';
import 'package:store/view/profile_view.dart';

class ControlViewModel extends GetxController {
  int _navigatorValue = 0;
  Widget _currentscreen = HomeView();
  get currentscree => _currentscreen;

  get navigatorValue => _navigatorValue;
  void changeSelectedValue(int selectedValue) {
    _navigatorValue = selectedValue;
    if (selectedValue == 0)
      _currentscreen = HomeView();
    else if (selectedValue == 1)
      _currentscreen = CartView();
    else
      _currentscreen = ProfileView();
    update();
  }
}
