import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  String? id;
  String nickname;
  String email;
  String role;
  String? userimage;
  String? password;
  String createdat;
  UserModel({
    this.id,
    required this.nickname,
    required this.email,
    required this.role,
    this.userimage,
    this.password,
    required this.createdat,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nickname': nickname,
      'email': email,
      'role': role,
      'userimage': userimage,
      'password': password,
      'createdat': createdat,
    };
  }

  factory UserModel.fromMap(DocumentSnapshot<Map<String, dynamic>> map) {
    return UserModel(
      id: map.id,
      nickname: map['nickname'] as String,
      email: map['email'] as String,
      role: map['role'] as String,
      userimage: map['userimage'] != null ? map['userimage'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      createdat: map['createdat'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(
      json.decode(source) as DocumentSnapshot<Map<String, dynamic>>);
}
