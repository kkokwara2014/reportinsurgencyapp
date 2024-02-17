import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:reportinsurgencyapp/components/my_drawer_header.dart';
import 'package:reportinsurgencyapp/components/my_drawer_list_tile.dart';
import 'package:reportinsurgencyapp/screens/home/feedbacks/feedbacks_page.dart';
import 'package:reportinsurgencyapp/screens/profile/profile.dart';
import 'package:reportinsurgencyapp/services/auth_service.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

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
                  mytitle: "Dashboard"),
              // MyDrawerListTile(
              //     onTap: () {
              //       Navigator.pop(context);
              //       Get.to(() => const AddReport());
              //     },
              //     leadingIcon: Icons.add_circle,
              //     trailingIcon: Icons.arrow_circle_right_outlined,
              //     mytitle: "Report Insurgency"),
              MyDrawerListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => const FeebackPage());
                  },
                  leadingIcon: Icons.feedback_outlined,
                  trailingIcon: Icons.arrow_circle_right_outlined,
                  mytitle: "Feedback"),
              MyDrawerListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => const ProfileScreen());
                  },
                  leadingIcon: Icons.person,
                  trailingIcon: Icons.arrow_circle_right_outlined,
                  mytitle: "Profile"),
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
