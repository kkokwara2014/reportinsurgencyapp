import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:reportinsurgencyapp/components/my_drawer_header.dart';
import 'package:reportinsurgencyapp/components/my_drawer_list_tile.dart';
import 'package:reportinsurgencyapp/screens/admin/users/add_user.dart';
import 'package:reportinsurgencyapp/services/auth_service.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              MyDrawerHeader(currentUser: authService.auth.currentUser),
              MyDrawerListTile(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  leadingIcon: Icons.home,
                  mytitle: "Admin Page"),
              MyDrawerListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => const AddUserPage());
                  },
                  leadingIcon: Icons.person_add,
                  trailingIcon: Icons.arrow_circle_right_outlined,
                  mytitle: "Add User"),
              MyDrawerListTile(
                  onTap: () {
                    Navigator.pop(context);

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Logout?"),
                        content: const Text("Do you want to logout?"),
                        actions: [
                          MaterialButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("No"),
                          ),
                          MaterialButton(
                            onPressed: () {
                              authService.signUserOut();
                              Navigator.pop(context);
                            },
                            child: const Text("Yes"),
                          ),
                        ],
                      ),
                    );
                  },
                  leadingIcon: Icons.power_settings_new_outlined,
                  mytitle: "Sign Out"),
            ],
          ),
        ),
      ),
    );
  }
}
