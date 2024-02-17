import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reportinsurgencyapp/components/my_textfield.dart';
import 'package:reportinsurgencyapp/components/mybutton.dart';
// import 'package:reportinsurgencyapp/screens/auth_screen.dart';
import 'package:reportinsurgencyapp/screens/authentication/signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isVisible = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final resetEmailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  @override
  void dispose() {
    resetEmailController.dispose();
    super.dispose();
  }

  Future signIn() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      // .whenComplete(() => Get.to(() => const AuthScreen()));
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
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 32),
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
                height: 10,
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
                  "Sign In",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //email text field
              MyTextField(
                  controller: emailController,
                  inputType: TextInputType.emailAddress,
                  prefixicon: Icons.email,
                  hintText: "Email",
                  validationString: "Email required"),

              const SizedBox(
                height: 12,
              ),
              //password text field
              TextFormField(
                controller: passwordController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                obscureText: isVisible,
                validator: (val) => val == "" ? "Password required" : null,
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
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16)),
                          ),
                          builder: (context) => Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 16),
                                  height:
                                      MediaQuery.of(context).size.height * .33,
                                  child: Form(
                                    key: _formKey2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Forgot Password?",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              icon: const Icon(
                                                Icons.close,
                                                size: 18,
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Text(
                                          "Enter your email and you will get password reset link.",
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        MyTextField(
                                            controller: resetEmailController,
                                            inputType:
                                                TextInputType.emailAddress,
                                            prefixicon: Icons.email,
                                            hintText: "Email",
                                            validationString: "Email required"),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        MyButton(
                                            onTap: () {
                                              resetPassword();
                                            },
                                            text: "Reset Password")
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              //sign up button
              MyButton(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    //sign user in
                    signIn();
                  }
                },
                text: "Sign In",
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("Don't have account? "),
                  InkWell(
                    onTap: () {
                      Get.to(() => const SignUpScreen());
                    },
                    child: const Text(
                      "Sign Up",
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

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: resetEmailController.text.trim());
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text("Reset password link sent! Please, check your email."),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Ok"),
            )
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(e.message.toString()),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Ok"),
            )
          ],
        ),
      );
    }
  }
}
