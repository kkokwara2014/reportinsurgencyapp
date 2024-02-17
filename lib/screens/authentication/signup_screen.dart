import 'package:flutter/material.dart';
import 'package:reportinsurgencyapp/components/mybutton.dart';
import 'package:reportinsurgencyapp/screens/auth_screen.dart';
import 'package:reportinsurgencyapp/screens/authentication/signin_screen.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reportinsurgencyapp/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isVisible = true;
  final nicknameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future signUp() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      if (passwordController.text == confirmpasswordController.text) {
        UserCredential result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim());

        if (result.user!.email != null) {
          UserModel userModel = UserModel(
              nickname: nicknameController.text.trim(),
              email: emailController.text.trim(),
              role: "user",
              createdat: DateTime.now().toString());
          await FirebaseFirestore.instance
              .collection("users")
              .doc(result.user!.email)
              .set(userModel.toMap())
              .whenComplete(() => Get.offAll(() => const AuthScreen()));
        }
        Get.to(() => const AuthScreen());
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password doesn't match.")));
      }
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 32),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(
                height: 30,
              ),
              //app logo
              Center(
                child: Container(
                  height: 180,
                  width: 180,
                  child: Image.asset("assets/images/security.png"),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Center(
                child: Text(
                  "Report Insurgency",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Center(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //nickname text field
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: nicknameController,
                // autofocus: true,
                validator: (value) =>
                    value == "" ? "Please enter Nick Name" : null,
                decoration: const InputDecoration(
                  hintText: "Nick Name",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.name,
              ),
              const SizedBox(
                height: 12,
              ),
              //email text field
              TextFormField(
                controller: emailController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                // autofocus: true,
                validator: (value) => value == "" ? "Please enter Email" : null,
                decoration: const InputDecoration(
                  hintText: "Email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 12,
              ),
              //password text field
              TextFormField(
                controller: passwordController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) =>
                    value == "" ? "Please enter password" : null,
                obscureText: isVisible,
                decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        icon: isVisible
                            ? const Icon(Icons.visibility_off_outlined)
                            : const Icon(Icons.visibility_outlined))),
                keyboardType: TextInputType.text,
              ),

              const SizedBox(
                height: 12,
              ),
              //confirm password text field
              TextFormField(
                controller: confirmpasswordController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) =>
                    value == "" ? "Please confirm password." : null,
                obscureText: isVisible,
                decoration: InputDecoration(
                    hintText: "Confirm Password",
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        icon: isVisible
                            ? const Icon(Icons.visibility_off_outlined)
                            : const Icon(Icons.visibility_outlined))),
                keyboardType: TextInputType.text,
              ),

              const SizedBox(
                height: 10,
              ),

              //sign up button
              MyButton(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    signUp();
                  }
                },
                text: "Sign Up",
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("Already have account? "),
                  InkWell(
                    onTap: () {
                      Get.to(() => const SignInScreen());
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
