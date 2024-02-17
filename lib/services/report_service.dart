import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reportinsurgencyapp/models/comment_model.dart';
import 'package:reportinsurgencyapp/models/report_model.dart';

class ReportService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  //calling stream of converted data
  Stream<List<ReportModel>> getReports() {
    return _db
        .collection("insurgencyreports")
        .where("ishandled", isEqualTo: false)
        // .orderBy("createdat", descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ReportModel.fromMap(doc)).toList());
  }

  Future<void> addReport(ReportModel reportModel) async {
    _db.collection("insurgencyreports").add(reportModel.toMap());
  }

  Future<void> updateReport(ReportModel reportModel) async {
    _db
        .collection("insurgencyreports")
        .doc(reportModel.id)
        .update(reportModel.toMap());
  }

  Future<void> deleteReport(ReportModel reportModel) async {
    _db.collection("insurgencyreports").doc(reportModel.id).delete();
  }

  //adding comments to report
  Future<void> addComment(CommentModel commentModel) async {
    // _db.collection("comments").doc(reportModel.id).set(commentModel.toMap());
    _db.collection("comments").add(commentModel.toMap());
  }

  Stream<List<CommentModel>> getComments(String? insurgreportid) {
    // final ReportModel reportModel;
    return _db
        .collection("comments")
        .where("insurgreportid", isEqualTo: insurgreportid!)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((comment) => CommentModel.fromMap(comment))
            .toList());
  }
}
