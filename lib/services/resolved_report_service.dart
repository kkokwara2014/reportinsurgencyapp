import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reportinsurgencyapp/models/report_model.dart';

class ResolvedReportService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //resolved reports
  Stream<List<ReportModel>> getResolvedReports() {
    return _db
        .collection("insurgencyreports")
        .where("ishandled", isEqualTo: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ReportModel.fromMap(doc)).toList());
  }
}
