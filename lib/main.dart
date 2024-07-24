import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:store/Auth/login.dart';
import 'package:store/Auth/signup.dart';
import 'package:store/helper/binding.dart';
import 'package:store/home_view.dart';
import 'package:store/service/firestore_user.dart';
import 'package:store/view/Admin/homeAdmin_view.dart';
import 'package:store/view_model/control_view_model.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAXNfjJTMSQlUNpp_AanV7YQFOTD5D2VaM",
      appId: "1:58596082211:android:07c4d373291e7b8f062796",
      messagingSenderId: "58596082211",
      projectId: "mystore-29d89",
      storageBucket: "mystore-29d89.appspot.com"
    ),
  );
  
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget bottomNavigationBar() {
    return GetBuilder<ControlViewModel>(
      init: ControlViewModel(),
      builder: (value) => BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            activeIcon: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Text("Explore"),
            ),
            label: '',
            icon: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Image.asset(
                'images/arrow.png',
                fit: BoxFit.contain,
                width: 20,
              ),
            ),
          ),
          BottomNavigationBarItem(
            activeIcon: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Text("Cart"),
            ),
            label: '',
            icon: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Image.asset(
                'images/shopping-cart.png',
                fit: BoxFit.contain,
                width: 20,
              ),
            ),
          ),
          BottomNavigationBarItem(
            activeIcon: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Text("Account"),
            ),
            label: '',
            icon: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Image.asset(
                'images/user.png',
                fit: BoxFit.contain,
                width: 20,
              ),
            ),
          ),
        ],
        currentIndex: value.navigatorValue,
        onTap: (index) => value.changeSelectedValue(index),
        elevation: 0,
        selectedItemColor: Colors.black,
        backgroundColor: Colors.grey.shade50,
      ),
    );
  }

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[50],
          titleTextStyle: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialBinding: Binding(),
      home: FirebaseAuth.instance.currentUser == null
          ? Login() // Si l'utilisateur n'est pas connecté, affiche l'écran de connexion
          : FutureBuilder<DocumentSnapshot>(
              future: FireStoreUser()
                  .getCurrentUser(FirebaseAuth.instance.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Pendant le chargement, affiche un indicateur de chargement par exemple
                  return CircularProgressIndicator();
                } else {
                  if (snapshot.hasError) {
                    // Gestion des erreurs si nécessaire
                    return Text('Une erreur s\'est produite');
                  } else {
                    // L'utilisateur est connecté et les données sont chargées
                    var userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    if (userData['type'] == 1) {
                      // Si le type d'utilisateur est 1, affiche l'écran HomeView
                      return GetBuilder<ControlViewModel>(
                        init: ControlViewModel(),
                        builder: (value) => Scaffold(
                          bottomNavigationBar: bottomNavigationBar(),
                          body: value.currentscree, // Affiche l'écran courant
                        ),
                      );
                    } else {
                      // Sinon, affiche l'écran HomeadminView
                      return HomeadminView();
                    }
                  }
                }
              },
            ),
      routes: {
        "signup": (context) => SignUp(),
        "login": (context) => Login(),
      },
    );
  }
}
