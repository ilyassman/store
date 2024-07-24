import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:store/model/categ_model.dart';
import 'package:store/view_model/categ_view_model.dart';

class CategpageView extends StatefulWidget {
  const CategpageView({super.key});

  @override
  State<CategpageView> createState() => _CategpageViewState();
}

class _CategpageViewState extends State<CategpageView> {
  void _showupdateCategoryDialog(BuildContext context, CategoryModel categ) {
    final _nameController = TextEditingController();
    String imageUrl = categ.image;
    _nameController.text = categ.nom;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<CategViewModel>(
          init: CategViewModel(),
          builder: (controller) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text('Update Categories',
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildTextField(
                    controller: _nameController,
                    label: 'Name of the categorie',
                    icon: Icons.category,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      ImagePicker imagePicker = ImagePicker();
                      XFile? image = await imagePicker.pickImage(
                          source: ImageSource.gallery);
                      if (image != null) {
                        Reference referenceroot =
                            FirebaseStorage.instance.ref();
                        Reference referenceDir =
                            referenceroot.child('categories');
                        Reference referenceImageUpload =
                            referenceDir.child(image.name);
                        try {
                          await referenceImageUpload.putFile(File(image.path));
                          imageUrl =
                              await referenceImageUpload.getDownloadURL();

                          controller.update();
                        } catch (e) {
                          print(
                              "Erreur lors du téléchargement de l'image : $e");
                        }
                      }
                    },
                    icon: Icon(Icons.add_photo_alternate, color: Colors.white),
                    label: Text(
                      "Sélectionner une image",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  SizedBox(height: 16),
                  if (imageUrl.isNotEmpty)
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Annuler', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: Text('Enregistrer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (_nameController.text.isNotEmpty && imageUrl.isNotEmpty) {
                    controller.updateCategory(
                        CategoryModel(
                          nom: _nameController.text,
                          image: imageUrl,
                          id: '',
                        ),
                        categ.id);
                    Navigator.of(context).pop();
                  } else {
                    // Afficher un message d'erreur si le nom ou l'image est manquant
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Veuillez remplir tous les champs')),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final _nameController = TextEditingController();
    String imageUrl = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<CategViewModel>(
          init: CategViewModel(),
          builder: (controller) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text('Ajouter une catégorie',
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildTextField(
                    controller: _nameController,
                    label: 'Nom de la catégorie',
                    icon: Icons.category,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      ImagePicker imagePicker = ImagePicker();
                      XFile? image = await imagePicker.pickImage(
                          source: ImageSource.gallery);
                      if (image != null) {
                        Reference referenceroot =
                            FirebaseStorage.instance.ref();
                        Reference referenceDir =
                            referenceroot.child('categories');
                        Reference referenceImageUpload =
                            referenceDir.child(image.name);
                        try {
                          await referenceImageUpload.putFile(File(image.path));
                          imageUrl =
                              await referenceImageUpload.getDownloadURL();

                          controller.update();
                        } catch (e) {
                          print(
                              "Erreur lors du téléchargement de l'image : $e");
                        }
                      }
                    },
                    icon: Icon(Icons.add_photo_alternate, color: Colors.white),
                    label: Text(
                      "Sélectionner une image",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  SizedBox(height: 16),
                  if (imageUrl.isNotEmpty)
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Annuler', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: Text('Enregistrer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (_nameController.text.isNotEmpty && imageUrl.isNotEmpty) {
                    controller.addCategory(CategoryModel(
                      nom: _nameController.text,
                      image: imageUrl,
                      id: '',
                    ));
                    Navigator.of(context).pop();
                  } else {
                    // Afficher un message d'erreur si le nom ou l'image est manquant
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Veuillez remplir tous les champs')),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      itemCount: 10, // Adjust the number of shimmer items as needed
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 16,
                          color: Colors.white,
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: 100,
                          height: 12,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: Icon(icon),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategViewModel>(
      init: CategViewModel(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text('Categories'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  controller.updateSearchQuery(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search categories...',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddCategoryDialog(context);
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 6.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        body: controller.isloading
            ? _buildLoadingShimmer()
            : ListView.separated(
                itemCount: controller.filteredcategs.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: Colors.grey[300],
                ),
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(controller.filteredcategs[index].id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      controller.deletcateg(controller.catgories[index].id);
                    },
                    background: Container(
                      color: Colors.red.shade400,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    child: Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: InkWell(
                        onLongPress: () {
                          _showupdateCategoryDialog(
                              context, controller.catgories[index]);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  controller.filteredcategs[index].image,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  controller.filteredcategs[index].nom,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.arrow_back_ios,
                                size: 18,
                                color: Colors.grey[400],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
