import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:reportinsurgencyapp/models/feedback_model.dart';
import 'package:reportinsurgencyapp/components/feedback_card.dart';
import 'package:reportinsurgencyapp/screens/home/feedbacks/add_feedback.dart';

class FeebackPage extends StatelessWidget {
  const FeebackPage({super.key});

  @override
  Widget build(BuildContext context) {
    final feebacks = Provider.of<List<FeedbackModel>>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedbacks"),
        elevation: 0,
      ),
      body: ListView.builder(
          itemCount: feebacks.length,
          itemBuilder: (context, index) {
            FeedbackModel feedback = feebacks[index];
            return FeedbackCard(feedback: feedback);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddFeedback());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
