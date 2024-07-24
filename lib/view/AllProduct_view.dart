import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:store/model/product_model.dart';
import 'package:store/view/daetilas_view.dart';

import 'package:store/view_model/home_view_model.dart';
import 'package:store/widgets/custom_text.dart';

class AllProductView extends StatefulWidget {
  const AllProductView({Key? key}) : super(key: key);

  @override
  _AllProductViewState createState() => _AllProductViewState();
}

class _AllProductViewState extends State<AllProductView> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String categoryId = Get.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text('All Products'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
            child: _searchTextFormField(),
          ),
          Expanded(
            child: _listViewProducts(categoryId),
          ),
        ],
      ),
    );
  }

  Widget _listViewProducts(String categid) {
    return GetBuilder<HomeViewModel>(
      init: HomeViewModel(),
      builder: (value) => value.isloading['bestsell'] ?? true
          ? _buildShimmerLoading()
          : _buildProductList(value, categid),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                _buildShimmerProductContainer(context),
                SizedBox(width: 20),
                _buildShimmerProductContainer(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerProductContainer(BuildContext context) {
    return Expanded(
      child: Container(
        height: 350,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade100,
              ),
              height: 220,
              width: double.infinity,
              child: Container(
                color: Colors.grey[300],
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 100,
              height: 10,
              color: Colors.grey[300],
            ),
            SizedBox(height: 10),
            Container(
              width: 200,
              height: 10,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList(HomeViewModel value, String categid) {
    // Filtrer les produits en fonction du texte de recherche
    List<ProductModel> filteredProducts = value.products.where((product) {
      String productName = product.name.toLowerCase();
      String searchTerm = _searchController.text.toLowerCase();
      bool matchesCategory = categid == '0' || product.categorie == categid;
      bool matchesSearch = productName.contains(searchTerm);
      return matchesCategory && matchesSearch;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
        itemCount: (filteredProducts.length / 2).ceil(),
        itemBuilder: (context, index) {
          final int firstIndex = index * 2;
          final int secondIndex = firstIndex + 1;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                if (firstIndex < filteredProducts.length)
                  _buildProductContainer(context, filteredProducts[firstIndex]),
                SizedBox(width: 20),
                if (secondIndex < filteredProducts.length)
                  _buildProductContainer(
                      context, filteredProducts[secondIndex]),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _searchTextFormField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade200,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {}); // Mettre à jour l'affichage lorsque le texte change
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black,
          ),
          hintText: 'Find by name...',
        ),
      ),
    );
  }

  Widget _buildProductContainer(BuildContext context, ProductModel product) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Get.to(DetailsView(model: product));
        },
        child: Container(
          height: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey.shade100,
                ),
                height: 220,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    product.image[0],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              CustomText(
                text: product.name,
                alignment: Alignment.bottomLeft,
              ),
              SizedBox(height: 10),
              Expanded(
                child: CustomText(
                  text: product.description,
                  color: Colors.grey,
                  maxLine: 2,
                  overflow: TextOverflow.ellipsis,
                  alignment: Alignment.topLeft,
                ),
              ),
              SizedBox(height: 10),
              CustomText(
                text: "${product.price} DH",
                color: Colors.green,
                alignment: Alignment.bottomLeft,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
