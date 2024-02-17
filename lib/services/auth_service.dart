import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reportinsurgencyapp/models/user_model.dart';

class AuthService {
  final auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<void> signupUser(
      String email, String password, UserModel userModel) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      await _db.collection("users").doc(user!.uid).set(userModel.toMap());
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  Future<void> signInUser(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  Future<void> signUserOut() async {
    await auth.signOut();
  }

  Stream<User?> get signedInUser {
    return auth.authStateChanges();
  }
}
