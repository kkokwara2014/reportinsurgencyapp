import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reportinsurgencyapp/components/mybutton.dart';
import 'package:reportinsurgencyapp/constants/images.dart';
import 'package:reportinsurgencyapp/models/user_model.dart';
import 'package:reportinsurgencyapp/services/user_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final loggedInUser = FirebaseAuth.instance.currentUser;
  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      TextFormField(
                        initialValue: user.nickname,
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: user.email,
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MyButton(onTap: () {}, text: "Update Profile"),
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
      ),
    );
  }
}
