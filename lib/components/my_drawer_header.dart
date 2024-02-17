import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reportinsurgencyapp/constants/images.dart';
import 'package:reportinsurgencyapp/services/auth_service.dart';

class MyDrawerHeader extends StatefulWidget {
  const MyDrawerHeader({super.key, required this.currentUser});
  final User? currentUser;

  @override
  State<MyDrawerHeader> createState() => _MyDrawerHeaderState();
}

class _MyDrawerHeaderState extends State<MyDrawerHeader> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.green,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Image.asset(profileImage),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              // widget.currentUser!.email.toString(),
              authService.auth.currentUser!.email.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
