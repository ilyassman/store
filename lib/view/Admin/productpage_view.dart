import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store/helper/extenstion.dart';

import 'package:store/model/categ_model.dart';
import 'package:store/model/product_model.dart';
import 'package:store/view_model/home_view_model.dart';
import 'package:store/view_model/product_view_model.dart';
import 'package:shimmer/shimmer.dart';

class ProductpageView extends StatefulWidget {
  @override
  State<ProductpageView> createState() => _ProductpageViewState();
}

class _ProductpageViewState extends State<ProductpageView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductViewModel>(
      init: ProductViewModel(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text('Products'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  controller.updateSearchQuery(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search products...',
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
            _showAddProductDialog(context);
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 6.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        body: GetBuilder<ProductViewModel>(
          init: ProductViewModel(),
          builder: (controller) => controller.isloading
              ? _buildShimmerEffect()
              : ListView.separated(
                  itemCount: controller.filteredProducts.length,
                  separatorBuilder: (context, index) => Divider(height: 1),
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(controller.filteredProducts[index].productId),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        controller.deletProduct(
                            controller.filteredProducts[index].productId);
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      child: InkWell(
                        onLongPress: () {
                          _showupdateProductDialog(
                              context,
                              controller.filteredProducts[index].productId,
                              controller);
                        },
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              controller.filteredProducts[index].image[0],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  controller.filteredProducts[index].name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '${controller.filteredProducts[index].price} DH',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(controller
                                  .filteredProducts[index].description),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    'Catégorie: ${controller.filteredProducts[index].categorie} | ',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    'Couleur: ',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: controller
                                          .filteredProducts[index].color,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                            ],
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final _nameController = TextEditingController();
    final _descriptionController = TextEditingController();
    final _priceController = TextEditingController();
    final _categoryController = TextEditingController();
    final _imageUrlController = TextEditingController();

    Color _selectedColor = Colors.white; // Couleur par défaut

    // Liste de couleurs personnalisée incluant le blanc
    List<String> imageUrls = [];
    final List<Color> _colors = [
      Colors.white,
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
      Colors.black,
    ];
    String imageul = '';
    String _selectedCategory = 'B4hQHsNXjpd8TgL3cafq'; // Catégorie par défaut

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<ProductViewModel>(
          init: ProductViewModel(),
          builder: (controllerProduct) => StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return GetBuilder<HomeViewModel>(
                init: HomeViewModel(),
                builder: (controller) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text('Add Product',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _buildTextField(
                          controller: _nameController,
                          label: 'Nom du produit',
                          icon: Icons.shopping_bag,
                        ),
                        SizedBox(height: 16),
                        _buildTextField(
                          controller: _descriptionController,
                          label: 'Description',
                          maxLines: 3,
                          icon: Icons.description,
                        ),
                        SizedBox(height: 16),
                        _buildTextField(
                          controller: _priceController,
                          label: 'Prix (DH)',
                          keyboardType: TextInputType.number,
                          icon: Icons.attach_money,
                        ),
                        SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: InputDecoration(
                            labelText: 'Catégorie',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            prefixIcon: Icon(Icons.category),
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCategory = newValue!;
                            });
                          },
                          items: controller.catgories
                              .map<DropdownMenuItem<String>>(
                                  (CategoryModel value) {
                            return DropdownMenuItem<String>(
                              value: value.id,
                              child: Text(value.nom),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () async {
                            ImagePicker imagePicker = ImagePicker();
                            List<XFile>? images =
                                await imagePicker.pickMultiImage();
                            if (images != null && images.isNotEmpty) {
                              for (XFile image in images) {
                                Reference referenceroot =
                                    FirebaseStorage.instance.ref();
                                Reference referenceDir =
                                    referenceroot.child('product');
                                Reference referenceImageUpload =
                                    referenceDir.child(image.name);
                                try {
                                  await referenceImageUpload
                                      .putFile(File(image.path));
                                  String imageUrl = await referenceImageUpload
                                      .getDownloadURL();
                                  setState(() {
                                    imageUrls.add(imageUrl);
                                  });
                                } catch (e) {
                                  print(
                                      "Erreur lors du téléchargement de l'image : $e");
                                }
                              }
                            }
                          },
                          icon: Icon(Icons.add_photo_alternate,
                              color: Colors.white),
                          label: Text(
                            "Sélectionner des images",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                        ),
                        SizedBox(height: 20),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: imageUrls.map((url) {
                            return Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 8),
                        if (imageul.isNotEmpty)
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
                                imageul,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        SizedBox(height: 16),
                        Text('Sélectionnez une couleur:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Container(
                          height: 150,
                          width: 300,
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: _colors.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedColor = _colors[index];
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _colors[index],
                                    border: Border.all(
                                      color: _selectedColor == _colors[index]
                                          ? Colors.blue
                                          : Colors.grey,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child:
                          Text('Annuler', style: TextStyle(color: Colors.red)),
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
                        controllerProduct.addPorudct(ProductModel(
                            name: _nameController.text,
                            image: imageUrls,
                            description: _descriptionController.text,
                            color: _selectedColor,
                            sized: "Xl",
                            productId: '',
                            price: _priceController.text,
                            categorie: _selectedCategory));
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: icon != null ? Icon(icon) : null,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 10, // Arbitrary number of shimmer items
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                color: Colors.white,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 12,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 100,
                      height: 12,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showupdateProductDialog(
      BuildContext context, String id, ProductViewModel controller) async {
    Map<String, dynamic>? product = await controller.getProduct(id);
    final _nameController = TextEditingController();
    _nameController.text = product!['name'];
    final _descriptionController = TextEditingController();
    _descriptionController.text = product!['description'];
    final _priceController = TextEditingController();
    _priceController.text = product!['price'];
    final _categoryController = TextEditingController();
    final _imageUrlController = TextEditingController();

    Color _selectedColor =
        HexColor.fromHex(product!['color']); // Couleur par défaut

    // Liste de couleurs personnalisée incluant le blanc
    List<String> imageUrls = [];
    final List<Color> _colors = [
      Colors.white,
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
      Colors.black,
    ];
    String imageul = '';
    String _selectedCategory = product!['categorie']; // Catégorie par défaut

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<ProductViewModel>(
          init: ProductViewModel(),
          builder: (controllerProduct) => StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return GetBuilder<HomeViewModel>(
                init: HomeViewModel(),
                builder: (controller) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text('Update Product',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _buildTextField(
                          controller: _nameController,
                          label: 'Nom du produit',
                          icon: Icons.shopping_bag,
                        ),
                        SizedBox(height: 16),
                        _buildTextField(
                          controller: _descriptionController,
                          label: 'Description',
                          maxLines: 3,
                          icon: Icons.description,
                        ),
                        SizedBox(height: 16),
                        _buildTextField(
                          controller: _priceController,
                          label: 'Prix (DH)',
                          keyboardType: TextInputType.number,
                          icon: Icons.attach_money,
                        ),
                        SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: InputDecoration(
                            labelText: 'Catégorie',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            prefixIcon: Icon(Icons.category),
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCategory = newValue!;
                            });
                          },
                          items: controller.catgories
                              .map<DropdownMenuItem<String>>(
                                  (CategoryModel value) {
                            return DropdownMenuItem<String>(
                              value: value.id,
                              child: Text(value.nom),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () async {
                            // ImagePicker imagePicker = ImagePicker();
                            // List<XFile>? images =
                            //     await imagePicker.pickMultiImage();
                            // if (images != null && images.isNotEmpty) {
                            //   for (XFile image in images) {
                            //     Reference referenceroot =
                            //         FirebaseStorage.instance.ref();
                            //     Reference referenceDir =
                            //         referenceroot.child('product');
                            //     Reference referenceImageUpload =
                            //         referenceDir.child(image.name);
                            //     try {
                            //       await referenceImageUpload
                            //           .putFile(File(image.path));
                            //       String imageUrl = await referenceImageUpload
                            //           .getDownloadURL();
                            //       setState(() {
                            //         imageUrls.add(imageUrl);
                            //       });
                            //     } catch (e) {
                            //       print(
                            //           "Erreur lors du téléchargement de l'image : $e");
                            //     }
                            //   }
                            // }
                          },
                          icon: Icon(Icons.add_photo_alternate,
                              color: Colors.white),
                          label: Text(
                            "Sélectionner des images",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                        ),
                        SizedBox(height: 20),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: imageUrls.map((url) {
                            return Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 8),
                        if (imageul.isNotEmpty)
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
                                imageul,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        SizedBox(height: 16),
                        Text('Sélectionnez une couleur:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Container(
                          height: 150,
                          width: 300,
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: _colors.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedColor = _colors[index];
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _colors[index],
                                    border: Border.all(
                                      color: _selectedColor == _colors[index]
                                          ? Colors.blue
                                          : Colors.grey,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child:
                          Text('Annuler', style: TextStyle(color: Colors.red)),
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
                      onPressed: () async {
                        Map<String, dynamic> produits = {
                          "id": id,
                          "name": _nameController.text,
                          "description": _descriptionController.text,
                          "color": _selectedColor,
                          "price": _priceController.text,
                          "categorie": _selectedCategory
                        };
                        controllerProduct.updateProcut(produits);
                        // controllerProduct.addPorudct(ProductModel(
                        //     name: _nameController.text,
                        //     image: imageUrls,
                        //     description: _descriptionController.text,
                        //     color: _selectedColor,
                        //     sized: "Xl",
                        //     productId: '',
                        //     price: _priceController.text,
                        //     categorie: _selectedCategory));
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
