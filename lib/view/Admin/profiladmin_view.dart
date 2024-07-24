import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store/Auth/login.dart';
import 'package:store/helper/LocalStorage.dart';
import 'package:store/model/user_model.dart';
import 'package:store/service/firestore_user.dart';
import 'package:store/view_model/profil_view_model.dart';

class ProfileAdminView extends StatelessWidget {
  late final LocalStorageData localStorageData = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfilViewModel>(
      init: ProfilViewModel(),
      builder: (controller) => Scaffold(
        body: controller.isloading
            ? Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  _buildSliverAppBar(controller),
                  SliverToBoxAdapter(
                    child: _buildProfileInfo(controller, context),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSliverAppBar(ProfilViewModel controller) {
    return SliverAppBar(
      expandedHeight: 250,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://static.vecteezy.com/system/resources/previews/005/907/314/large_2x/blue-user-icon-symbol-or-website-admin-social-profile-login-communication-website-element-concept-illustration-on-white-background-3d-rendering-photo.jpg', // Une image aléatoire de la nature
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
            ),
          ],
        ),
        title: Text(
          controller.userModel.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
    );
  }

  Widget _buildProfileInfo(ProfilViewModel controller, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(controller),
          SizedBox(height: 32),
          _buildProfileOptions(controller, context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(ProfilViewModel controller) {
    return Row(
      children: [
        Hero(
          tag: 'profilePic',
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: controller.userModel.pic.isEmpty
                  ? AssetImage("images/profil.jpeg") as ImageProvider
                  : NetworkImage(controller.userModel.pic),
            ),
          ),
        ),
        SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.userModel.name,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                controller.userModel.email,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileOptions(
      ProfilViewModel controller, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Profile Options",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: 24),
        _buildOptionCard(
          icon: Icons.edit,
          title: "Edit Profile",
          onTap: () => _showEditUserDialog(context, controller),
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(height: 16),
        _buildOptionCard(
          icon: Icons.logout,
          title: "Logout",
          onTap: () {
            controller.singOut();
            Get.offAll(Login());
          },
          color: Colors.redAccent,
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              SizedBox(width: 24),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Icon(Icons.chevron_right, color: color),
            ],
          ),
        ),
      ),
    );
  }

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

  // La méthode _showEditUserDialog reste inchangée
}
