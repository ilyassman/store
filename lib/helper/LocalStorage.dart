import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store/model/user_model.dart';

class LocalStorageData extends GetxController {
  Future<UserModel?> get getUser async {
    try {
      UserModel user = await _getUserData();
      if (user == null)
        return null;
      else
        return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getString('user');
    return UserModel.fromJson(json.decode(value!));
  }

  setUser(UserModel user) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs
          .setString('user', json.encode(user.toJson()))
          .then((value) => {print('done login')});
    } catch (e) {
      print("ereru ilyass");
      print(e.toString());
    }
  }

  void deletUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear().then((value) => {print("done")});
  }
}
