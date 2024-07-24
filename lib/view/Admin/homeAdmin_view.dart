import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:store/view/Admin/categpage_view.dart';
import 'package:store/view/Admin/dashborad_view.dart';
import 'package:store/view/Admin/orderspage_view.dart';
import 'package:store/view/Admin/productpage_view.dart';
import 'package:store/view/Admin/profiladmin_view.dart';
import 'package:store/view/Admin/userpage_view.dart';


class HomeadminView extends StatefulWidget {
  const HomeadminView({super.key});

  @override
  State<HomeadminView> createState() => _HomeadminViewState();
}

class _HomeadminViewState extends State<HomeadminView> {
  var _page = 0;
  final pages = [
    DashboradView(),
    UserpageView(),
    ProductpageView(),
    CategpageView(),
    OrderspageView(),
    ProfileAdminView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA), // Fond gris très clair
      bottomNavigationBar: CurvedNavigationBar(
        color: Color(0xFFFFFFFF), // Blanc pour la barre de navigation
        index: 0,
        buttonBackgroundColor:
            Color(0xFF3498DB), // Bleu clair pour le bouton actif
        backgroundColor:
            Color(0xFFF5F7FA), // Même couleur que le fond de l'écran
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 400),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        items: <Widget>[
          Icon(Icons.dashboard,
              size: 30, color: Color(0xFF34495E)), // Gris foncé pour les icônes
          Icon(Icons.people, size: 30, color: Color(0xFF34495E)),
          Icon(Icons.inventory, size: 30, color: Color(0xFF34495E)),
          Icon(Icons.checkroom, size: 30, color: Color(0xFF34495E)),
          Icon(Icons.shopping_cart, size: 30, color: Color(0xFF34495E)),
          Icon(Icons.people_alt_outlined, size: 30, color: Color(0xFF34495E)),
        ],
      ),
      body: pages[_page],
    );
  }
}
