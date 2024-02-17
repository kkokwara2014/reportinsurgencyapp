import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reportinsurgencyapp/models/feedback_model.dart';

class FeedbackService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

//fetching streams of feedback model from firebase
  Stream<List<FeedbackModel>> feedbackStream() {
    return _db
        .collection("feedbacks")
        .orderBy("createdat", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((feedback) => FeedbackModel.fromMap(feedback))
            .toList());
  }

  //add feedback to firebase
  Future<void> addFeedback(FeedbackModel feedbackModel) async {
    await _db.collection("feedbacks").add(feedbackModel.toMap());
  }

  //update feedback in firebase
  Future<void> updateFeedback(FeedbackModel feedbackModel) async {
    await _db
        .collection("feedbacks")
        .doc(feedbackModel.id)
        .update(feedbackModel.toMap());
  }

  //update feedback in firebase
  Future<void> deleteFeedback(FeedbackModel feedbackModel) async {
    await _db.collection("feedbacks").doc(feedbackModel.id).delete();
  }
}
