import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reportinsurgencyapp/components/my_textfield.dart';
import 'package:reportinsurgencyapp/components/mybutton.dart';
import 'package:reportinsurgencyapp/models/feedback_model.dart';
import 'package:reportinsurgencyapp/services/feedback_service.dart';

class AddFeedback extends StatefulWidget {
  const AddFeedback({super.key});

  @override
  State<AddFeedback> createState() => _AddFeedbackState();
}

class _AddFeedbackState extends State<AddFeedback> {
  final bodyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final loggedInUser = FirebaseAuth.instance.currentUser!;

  final FeedbackService feedbackService = FeedbackService();

  Future<void> createFeedback() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      FeedbackModel feedbackModel = FeedbackModel(
          user: loggedInUser.email!,
          body: bodyController.text.trim(),
          createdat: DateTime.now().toIso8601String());
      await feedbackService.addFeedback(feedbackModel);
      Navigator.pop(context);
    } catch (e) {
      print(e);
      Navigator.pop(context);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Feedback"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Text(
                  "Tell us where to improve!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                MyTextField(
                    controller: bodyController,
                    inputType: TextInputType.text,
                    prefixicon: Icons.comment,
                    hintText: "Feedback here...",
                    validationString: "Feedback required"),
                const SizedBox(
                  height: 15,
                ),
                MyButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        createFeedback();
                      }
                    },
                    text: "Send Feedback")
              ],
            )),
      ),
    );
  }
}
