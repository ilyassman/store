import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store/view_model/profil_view_model.dart';

class DashboradView extends StatefulWidget {
  const DashboradView({super.key});

  @override
  State<DashboradView> createState() => _DashboradViewState();
}

class DashboardItem {
  final IconData icon;
  final Color color;
  final String title;
  final int count;

  DashboardItem(this.icon, this.color, this.title, this.count);
}

class _DashboradViewState extends State<DashboradView> {
  final List<DashboardItem> items = [];
  Color _generateRandomColor(Random random) {
    // Générer des composants de couleur avec une luminosité contrôlée
    final int minBrightness = 50;
    final int maxBrightness = 200;
    final int red =
        minBrightness + random.nextInt(maxBrightness - minBrightness);
    final int green =
        minBrightness + random.nextInt(maxBrightness - minBrightness);
    final int blue =
        minBrightness + random.nextInt(maxBrightness - minBrightness);

    return Color.fromRGBO(red, green, blue, 1);
  }

  List<PieChartSectionData> sections = [];
  bool _isloading = true;
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    _isloading = true;
    await countProductsPerCategory();
    _isloading = false;
    // Ensure setState is called after async operation completes
    if (mounted) {
      setState(() {
        // Update state variables here if needed
      });
    }
  }

  List<int> count = [];

  final random = Random();
  Future<void> countProductsPerCategory() async {
    final categoriesSnapshot =
        await FirebaseFirestore.instance.collection('Categories').get();
    final products =
        await FirebaseFirestore.instance.collection('Products').get();
    final users = await FirebaseFirestore.instance.collection('Users').get();
    final orders = await FirebaseFirestore.instance.collection('Orders').get();
    count.add(categoriesSnapshot.docs.length);
    items.add(
        DashboardItem(Icons.checkroom, Colors.green, 'Categories', count[0]));
    count.add(products.docs.length);
    items.add(DashboardItem(Icons.inventory, Colors.red, 'Products', count[1]));
    count.add(users.docs.length);

    items
        .add(DashboardItem(Icons.people, Colors.orange, 'Customers', count[2]));
    count.add(orders.docs.length);
    items.add(
        DashboardItem(Icons.shopping_cart, Colors.pink, 'Orders', count[3]));
    for (var categoryDoc in categoriesSnapshot.docs) {
      final randomColor = _generateRandomColor(random);
      final categoryId = categoryDoc.id;
      final productsSnapshot = await FirebaseFirestore.instance
          .collection('Products')
          .where('categorie', isEqualTo: categoryId)
          .get();

      final productCount = productsSnapshot.size;
      sections.add(PieChartSectionData(
        value: productCount.toDouble(), // Utilisez productCount ici
        title: '${categoryDoc['nom']} \n Qt: $productCount',
        titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        showTitle: true,
        radius: 70,
        color: randomColor,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isloading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade50, Colors.white],
              ),
            ),
            child: SafeArea(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      AspectRatio(
                        aspectRatio: 1,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return GridView.count(
                              crossAxisCount: 2,
                              padding: const EdgeInsets.all(0),
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: items
                                  .map((item) => _buildDashboardItem(item.icon,
                                      item.color, item.title, item.count))
                                  .toList(),
                            );
                          },
                        ),
                      ),
                      Text(
                        "Product Distribution by Category",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      AspectRatio(
                        aspectRatio: 2,
                        child: PieChart(
                          PieChartData(
                            sections: sections,
                            sectionsSpace: 0,
                            centerSpaceRadius: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget _buildDashboardItem(
      IconData icon, Color color, String title, int count) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.1), Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: color.withOpacity(0.2),
                child: Icon(icon, color: color, size: 30),
              ),
              SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
