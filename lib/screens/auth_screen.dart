import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reportinsurgencyapp/models/user_model.dart';
import 'package:reportinsurgencyapp/screens/admin/admin_home.dart';
import 'package:reportinsurgencyapp/screens/authentication/signin_screen.dart';
import 'package:reportinsurgencyapp/screens/home/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return StreamBuilder<UserModel>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(snapshot.data!.email)
                    .snapshots()
                    .map((user) => UserModel.fromMap(user)),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final userData = snapshot.data;
                    if (userData!.role == 'admin') {
                      return const AdminHomePage();
                    } else {
                      return const HomeScreen();
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Material(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    return const Material(
                      child: Center(child: Text("No Data!")),
                    );
                  }
                });
          }
          return const SignInScreen();
        });
  }
}
