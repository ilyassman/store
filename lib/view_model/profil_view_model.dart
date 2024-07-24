import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:store/helper/LocalStorage.dart';
import 'package:store/model/user_model.dart';

class ProfilViewModel extends GetxController {
  LocalStorageData localStorageData = Get.find();
  UserModel get userModel => _userModel;
  late UserModel _userModel;
  bool _isloading = true;
  bool get isloading => _isloading;
  @override
  void onInit() async {
    await getCurrentUser();
    super.onInit();
  }

  Future<void> singOut() async {
    GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    localStorageData.deletUser();
  }

  Future<void> getCurrentUser() async {
    _isloading = true;
    await localStorageData.getUser.then((value) {
      print("hawa hana ${value}");
      _userModel = value!;
    });
    _isloading = false;
    update();
  }
}
