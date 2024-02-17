import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:reportinsurgencyapp/models/user_model.dart';
import 'package:reportinsurgencyapp/components/users_list.dart';
import 'package:reportinsurgencyapp/screens/admin/users/add_user.dart';

class AdminUsersPage extends StatelessWidget {
  const AdminUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    var users = Provider.of<List<UserModel>>(context);
    return Scaffold(
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          itemCount: users.length,
          itemBuilder: (context, index) {
            UserModel user = users[index];
            return UserList(user: user);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddUserPage());
        },
        child: const Icon(Icons.person_add_alt),
      ),
    );
  }
}
