import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:reportinsurgencyapp/constants/images.dart';
import 'package:reportinsurgencyapp/models/user_model.dart';
import 'package:reportinsurgencyapp/screens/auth_screen.dart';
import 'package:reportinsurgencyapp/screens/profile/edit_profile.dart';
import 'package:reportinsurgencyapp/screens/profile/widgets/profile_listtile.dart';
import 'package:reportinsurgencyapp/services/auth_service.dart';
import 'package:reportinsurgencyapp/services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final loggedInUser = FirebaseAuth.instance.currentUser;
  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    final currentUser2 = Provider.of<AuthService>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        elevation: 0,
      ),
      body: FutureBuilder(
          future: userService.userDetail(loggedInUser!.email.toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              final UserModel user = snapshot.data as UserModel;
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                child: Column(
                  children: [
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(profileImage),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      user.nickname,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(user.email),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(() => EditProfileScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: StadiumBorder(),
                        ),
                        child: Text("Edit Profile"),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Divider(),
                    const SizedBox(
                      height: 5,
                    ),
                    ProfileListTile(
                      onTap: () {},
                      caption: "Settings",
                      leadingIcon: Icons.settings,
                      hasTrailingIcon: true,
                    ),
                    ProfileListTile(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10.0)),
                          ),
                          builder: ((context) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                height: 180,
                                // decoration: BoxDecoration(
                                //   borderRadius: BorderRadius.only(
                                //       topLeft: Radius.circular(25),
                                //       topRight: Radius.circular(25)),
                                // ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "App Information",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(
                                              Icons.close,
                                              size: 20,
                                            ))
                                      ],
                                    ),
                                    Divider(),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text("Insurgency Report App"),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text("Version 1.0"),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text("2023"),
                                  ],
                                ),
                              )),
                        );
                      },
                      caption: "Information",
                      leadingIcon: Icons.info_outline,
                      hasTrailingIcon: false,
                    ),
                    ProfileListTile(
                      onTap: () {
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
                                  Navigator.pop(context);
                                  currentUser2.signUserOut().then((value) =>
                                      Get.offAll(() => AuthScreen()));
                                },
                                child: const Text("Yes"),
                              ),
                            ],
                          ),
                        );
                      },
                      caption: "Logout",
                      leadingIcon: Icons.power_settings_new,
                      hasTrailingIcon: false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Divider(),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Container(
                    //       padding: const EdgeInsets.all(8),
                    //       decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(16),
                    //           color: Colors.grey.shade500),
                    //       child: Text.rich(TextSpan(children: [
                    //         TextSpan(
                    //           text: "Joined ",
                    //           style: TextStyle(color: Colors.white),
                    //         ),
                    //         TextSpan(
                    //           text:
                    //               "${formatDate(DateTime.parse(user.createdat), [
                    //                 dd,
                    //                 ' ',
                    //                 M,
                    //                 ' ',
                    //                 yyyy
                    //               ])}",
                    //           style: TextStyle(color: Colors.white),
                    //         ),
                    //       ])),
                    //     )
                    //   ],
                    // )
                  ],
                ),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: Text("No Data"),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
