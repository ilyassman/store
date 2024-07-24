import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store/model/user_model.dart';

class FireStoreUser {
  final CollectionReference _userCollectionRef =
      FirebaseFirestore.instance.collection('Users');

  Future<void> addUserToFireStore(UserModel userModel) async {
    return await _userCollectionRef
        .doc(userModel.userId)
        .set(userModel.toJson())
        .then((value) => {print("user add")});
  }

  Future<void> updateUser(String nom) async {
    return await _userCollectionRef
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"name": nom});
  }

  Future<DocumentSnapshot> getCurrentUser(String id) async {
    return await _userCollectionRef.doc(id).get();
  }
}
