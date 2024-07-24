import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store/Auth/login.dart';
import 'package:store/helper/LocalStorage.dart';
import 'package:store/model/user_model.dart';
import 'package:store/service/firestore_user.dart';
import 'package:store/view/orderhistory_view.dart';
import 'package:store/view_model/profil_view_model.dart';
import 'package:store/widgets/custom_text.dart';

class ProfileView extends StatelessWidget {
  void _showEditUserDialog(BuildContext context, ProfilViewModel controller) {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _oldpasswordController = TextEditingController();
    final _usernameController = TextEditingController();
    _emailController.text = controller.userModel.email;
    _usernameController.text = controller.userModel.name;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _oldpasswordController,
                decoration: InputDecoration(labelText: 'Old Password'),
                obscureText: true,
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                // Handle save logic here
                final email = _emailController.text;
                final oldpassword = _oldpasswordController.text;
                final password = _passwordController.text;
                final username = _usernameController.text;
                await FireStoreUser().updateUser(username);
                if (password.isNotEmpty && oldpassword.isNotEmpty) {
                  var cred = EmailAuthProvider.credential(
                      email: email, password: oldpassword);
                  await FirebaseAuth.instance.currentUser!
                      .reauthenticateWithCredential(cred)
                      .then((value) async {
                    await FirebaseAuth.instance.currentUser!
                        .updatePassword(password);
                  });
                }

                await FireStoreUser()
                    .getCurrentUser(FirebaseAuth.instance.currentUser!.uid)
                    .then((value) => {
                          localStorageData.setUser(UserModel(
                              userId: value['userId'],
                              email: value['email'],
                              name: value['name'],
                              pic: value['pic'],
                              type: value['type']))
                        });
                await controller.getCurrentUser();

                // TODO: Add your logic to update the user information

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  late final LocalStorageData localStorageData = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ProfilViewModel>(
        init: ProfilViewModel(),
        builder: (value) => value.isloading
            ? Center(child: CircularProgressIndicator())
            : Container(
                padding: EdgeInsets.only(top: 50),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: value.userModel == null
                                      ? AssetImage("images/profil.jpeg")
                                      : value.userModel.pic.isEmpty
                                          ? AssetImage("images/profil.jpeg")
                                          : NetworkImage(value.userModel.pic),
                                  fit: BoxFit.fill,
                                ),
                                color: Colors.red,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                              ),
                            ),
                            Column(
                              children: [
                                CustomText(
                                  text: value.userModel.name,
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                CustomText(
                                  text: value.userModel.email,
                                  fontSize: 15,
                                  color: Colors.black,
                                  overflow: TextOverflow.ellipsis,
                                  maxLine: 1,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      GetBuilder<ProfilViewModel>(
                        init: ProfilViewModel(),
                        builder: (controller) => Container(
                          child: TextButton(
                              onPressed: () async {
                                _showEditUserDialog(context, controller);
                              },
                              child: ListTile(
                                title: CustomText(
                                  text: "Edit Profile",
                                ),
                                leading: Icon(color: Colors.green, Icons.edit),
                                trailing: Icon(
                                    color: Colors.black,
                                    Icons.navigate_next_outlined),
                              )),
                        ),
                      ),
                      Container(
                        child: TextButton(
                            onPressed: () {},
                            child: ListTile(
                              title: CustomText(
                                text: "Shipping Address",
                              ),
                              leading:
                                  Icon(color: Colors.green, Icons.location_on),
                              trailing: Icon(
                                  color: Colors.black,
                                  Icons.navigate_next_outlined),
                            )),
                      ),
                      Container(
                        child: TextButton(
                            onPressed: () {
                              Get.to(OrdersPage());
                            },
                            child: ListTile(
                              title: CustomText(
                                text: "Order History",
                              ),
                              leading: Icon(
                                  color: Colors.green,
                                  Icons.timelapse_outlined),
                              trailing: Icon(
                                  color: Colors.black,
                                  Icons.navigate_next_outlined),
                            )),
                      ),
                      Container(
                        child: TextButton(
                            onPressed: () {
                              value.singOut();
                              Get.offAll(Login());
                            },
                            child: ListTile(
                              title: CustomText(
                                text: "Logout",
                              ),
                              leading: Icon(color: Colors.green, Icons.logout),
                              trailing: Icon(
                                  color: Colors.black,
                                  Icons.navigate_next_outlined),
                            )),
                      ),
                    ],
                  ),
                )),
      ),
    );
  }
}
