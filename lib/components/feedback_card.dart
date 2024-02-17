import 'package:flutter/material.dart';
import 'package:reportinsurgencyapp/models/feedback_model.dart';
import 'package:date_format/date_format.dart';

class FeedbackCard extends StatelessWidget {
  const FeedbackCard({
    super.key,
    required this.feedback,
  });

  final FeedbackModel feedback;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(feedback.body),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.person,
                  size: 18,
                ),
                Text(
                  feedback.user,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(formatDate(DateTime.parse(feedback.createdat),
                [dd, '-', M, '-', yyyy, ' ', h, ':', mm, '', am])),
          ],
        ),
      ),
    );
  }
}
