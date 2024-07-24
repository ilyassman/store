import 'package:get/get.dart';
import 'package:store/helper/LocalStorage.dart';
import 'package:store/view_model/cart_view_model.dart';
import 'package:store/view_model/control_view_model.dart';
import 'package:store/view_model/home_view_model.dart';
import 'package:store/view_model/profil_view_model.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ControlViewModel());
    Get.lazyPut(() => HomeViewModel());
    Get.lazyPut(() => CartViewModel());
    Get.lazyPut(() => ProfilViewModel());
    Get.put<LocalStorageData>(LocalStorageData());
  }
}
