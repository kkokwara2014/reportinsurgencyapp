import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reportinsurgencyapp/components/my_textfield.dart';
import 'package:reportinsurgencyapp/components/mybutton.dart';
import 'package:reportinsurgencyapp/models/user_model.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final nicknameController = TextEditingController();
  final emailController = TextEditingController();

  Future addNewAdmin() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      UserCredential result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(), password: "password");

      if (result.user!.email != null) {
        UserModel userModel = UserModel(
            nickname: nicknameController.text.trim(),
            email: emailController.text.trim(),
            password: "password",
            role: "admin",
            createdat: DateTime.now().toString());
        await FirebaseFirestore.instance
            .collection("users")
            .doc(result.user!.email)
            .set(userModel.toMap());
      }
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("New Admin added.")));
    } on FirebaseAuthException catch (e) {
      print(e);
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Admin"),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Form(
            key: _formKey,
            child: ListView(
              children: [
                MyTextField(
                  controller: nicknameController,
                  inputType: TextInputType.text,
                  prefixicon: Icons.person,
                  hintText: "Nickname",
                  validationString: "Nickname required",
                ),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                  controller: emailController,
                  inputType: TextInputType.emailAddress,
                  prefixicon: Icons.email,
                  hintText: "Email",
                  validationString: "Email required",
                ),
                const SizedBox(
                  height: 10,
                ),
                MyButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        addNewAdmin();
                      }
                    },
                    text: "Add Admin")
              ],
            )),
      ),
    );
  }
}
