import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:store/model/categ_model.dart';

class CategViewModel extends GetxController {
  List<CategoryModel> _catgories = [];
  bool _isloading = true;
  bool get isloading => _isloading;
  List<CategoryModel> get catgories => _catgories;
  List<CategoryModel> filteredcategs = [];
  final CollectionReference _categoryCollectionRef =
      FirebaseFirestore.instance.collection('Categories');
  String searchQuery = '';

  void updateSearchQuery(String query) {
    searchQuery = query;
    filterUsers();
    update();
  }

  void filterUsers() {
    if (searchQuery.isEmpty) {
      filteredcategs = List.from(_catgories);
    } else {
      filteredcategs = _catgories
          .where((categ) =>
              categ.nom.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
  }

  CategViewModel() {
    getCategorys();
  }
  getCategorys() async {
    _isloading = true;
    _catgories = [];
    // await Future.delayed(Duration(seconds: 2));
    await _categoryCollectionRef.get().then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        _catgories.add(CategoryModel.fromJson(
            value.docs[i].data() as Map<String, dynamic>, value.docs[i].id));
      }
      filteredcategs = List.from(_catgories);
      _isloading = false;
      print("catge lenght:${_catgories.length}");
    });
    update();
  }

  addCategory(CategoryModel catge) {
    _categoryCollectionRef.add(catge.toJson2());
    getCategorys();
  }

  updateCategory(CategoryModel catge, String id) {
    _categoryCollectionRef.doc(id).update(catge.toJson2());
    getCategorys();
  }

  deletcateg(String id) {
    _categoryCollectionRef.doc(id).delete();
  }
}
