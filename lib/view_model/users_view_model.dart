import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:store/model/user_model.dart';
import 'package:store/service/firestore_user.dart';

class UsersViewModel extends GetxController {
  List<UserModel> _users = [];
  late UserModel _user;
  UserModel get user => _user;
  List<UserModel> filteredUsers = [];
  bool _isloading = true;
  bool get isloading => _isloading;
  UsersViewModel() {
    getUsers();
  }
  String searchQuery = '';

  void updateSearchQuery(String query) {
    searchQuery = query;
    filterUsers();
    update();
  }

  void filterUsers() {
    if (searchQuery.isEmpty) {
      filteredUsers = List.from(users);
    } else {
      filteredUsers = users
          .where((user) =>
              user.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
  }

  List<UserModel> get users => _users;
  final CollectionReference _usersCollectionRef =
      FirebaseFirestore.instance.collection('Users');
  getUsers() async {
    _users = [];
    _isloading = true;
    // await Future.delayed(Duration(seconds: 2));
    await _usersCollectionRef.where('type', isEqualTo: 1).get().then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        _users.add(
            UserModel.fromJson(value.docs[i].data() as Map<String, dynamic>));
      }
      filteredUsers = List.from(_users);
      print("users lenght:${_users.length}");
      _isloading = false;
    });
    update();
  }

  getUser(String id) async {
    await _usersCollectionRef
        .where('userId', isEqualTo: id)
        .get()
        .then((value) {
      _user =
          UserModel.fromJson(value.docs.first.data() as Map<String, dynamic>);
    });
    update();
  }

  updateUser(String id, String email, String name) async {
    _isloading = true;
    await _usersCollectionRef
        .where('userId', isEqualTo: id)
        .get()
        .then((value) {
      _usersCollectionRef.doc(value.docs.first.id).update({
        'name': name,
        'email': email,
        'pic': "https://ui-avatars.com/api/?background=random&name=${name}",
      }).then((value) {
        getUsers();
      });
    });
    update();
  }

  addUser(UserModel user, String password) async {
    _isloading = true;
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: user.email,
      password: password,
    )
        .then((userfire) async {
      FirebaseAuth.instance.currentUser!.sendEmailVerification();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "nadounettenadia@gmail.com", password: "admin123");
      await FireStoreUser().addUserToFireStore(UserModel(
        userId: userfire.user!.uid,
        email: user.email,
        name: user.name,
        pic: user.pic,
        type: 1,
      ));
      // _usersCollectionRef.add({
      //   'userId': userfire.user!.uid,
      //   'email': user.email,
      //   'name': user.name,
      //   'pic': user.pic,
      //   'type': 1,
      // });
      getUsers();
      update();
    });
  }

  deletUser(String id) async {
    await _usersCollectionRef
        .where('userId', isEqualTo: id)
        .get()
        .then((value) {
      _usersCollectionRef.doc(value.docs.first.id).delete().then((value) {
        _users.removeWhere((user) => user.userId == id);
        filteredUsers.removeWhere((user) => user.userId == id);
        update();
      });
    });
  }
}
