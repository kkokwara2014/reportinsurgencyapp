import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reportinsurgencyapp/models/user_model.dart';

class OfficerService {
  final userRef = FirebaseFirestore.instance;

//returning streams of users
  Stream<List<UserModel>> allOfficers() {
    return userRef
        .collection("users")
        .where("role", isEqualTo: "admin")
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((user) => UserModel.fromMap(user)).toList());
  }
}
