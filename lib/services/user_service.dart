import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reportinsurgencyapp/models/user_model.dart';

class UserService {
  final userRef = FirebaseFirestore.instance.collection("users");

//returning streams of users
  Stream<List<UserModel>> allUsers() {
    return userRef.snapshots().map((snapshot) =>
        snapshot.docs.map((user) => UserModel.fromMap(user)).toList());
  }

  //getting single user detail
  Future<UserModel> userDetail(String email) async {
    final snapshot = await userRef.where("email", isEqualTo: email).get();
    final userInfo = snapshot.docs.map((doc) => UserModel.fromMap(doc)).single;
    return userInfo;
  }

//adding user
  Future<void> addUser(UserModel userModel) async {
    UserCredential result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: userModel.email, password: userModel.nickname);

    if (result.user!.email != null) {
      await userRef.doc(userModel.email).set(userModel.toMap());
    }
  }

//adding user
  Future<void> updateUser(UserModel userModel) async {
    userRef.doc(userModel.email).update(userModel.toMap());
  }

  //delete user
  Future<void> deleteUser(UserModel userModel) async {
    userRef.doc(userModel.email).delete();
  }
}
