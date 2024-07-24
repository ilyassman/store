import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store/model/user_model.dart';
import 'package:store/view_model/users_view_model.dart';
import 'package:shimmer/shimmer.dart';

class UserpageView extends StatefulWidget {
  const UserpageView({super.key});

  @override
  State<UserpageView> createState() => _UserpageViewState();
}

class _UserpageViewState extends State<UserpageView> {
  @override
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UsersViewModel>(
      init: UsersViewModel(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text('Users'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  controller.updateSearchQuery(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search users...',
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
            _showAddUserDialog(context, controller);
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
            ? ShimmerLoading()
            : ListView.builder(
                itemCount: controller.filteredUsers.length,
                itemBuilder: (context, index) {
                  return UserListItem(
                      controller: controller,
                      user: controller.filteredUsers[index]);
                },
              ),
      ),
    );
  }

  void _showAddUserDialog(BuildContext context, UsersViewModel controller) {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _oldpasswordController = TextEditingController();
    final _usernameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add User'),
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
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Confirm Password'),
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
                final email = _emailController.text;
                final oldpassword = _oldpasswordController.text;
                final password = _passwordController.text;
                final username = _usernameController.text;
                controller.addUser(
                    UserModel(
                        userId: "",
                        email: email,
                        name: username,
                        pic:
                            "https://ui-avatars.com/api/?background=random&name=${username}",
                        type: 1),
                    password);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ShimmerLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Adjust this number based on your needs
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: CircleAvatar(radius: 25),
              title: Container(
                width: double.infinity,
                height: 16,
                color: Colors.white,
              ),
              subtitle: Container(
                width: double.infinity,
                height: 12,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}

class UserListItem extends StatelessWidget {
  final UserModel user;
  final UsersViewModel controller;

  UserListItem({required this.user, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(user.userId),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        controller.deletUser(user.userId);
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
      child: GetBuilder<UsersViewModel>(
        init: UsersViewModel(),
        builder: (controller) => InkWell(
          onLongPress: () async {
            await controller.getUser(user.userId);
            _showEditUserDialog(context, controller);
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.pic!),
                radius: 25,
              ),
              title: Text(
                user.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${user.email}',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditUserDialog(BuildContext context, UsersViewModel controller) {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _oldpasswordController = TextEditingController();
    final _usernameController = TextEditingController();
    _emailController.text = controller.user.email;
    _usernameController.text = controller.user.name;

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
                final email = _emailController.text;
                final oldpassword = _oldpasswordController.text;
                final password = _passwordController.text;
                final username = _usernameController.text;
                controller.updateUser(controller.user.userId, email, username);

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
