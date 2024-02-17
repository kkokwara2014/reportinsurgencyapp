import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class FeedbackModel {
  String? id;
  String user;
  String body;
  String createdat;
  FeedbackModel({
    this.id,
    required this.user,
    required this.body,
    required this.createdat,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user,
      'body': body,
      'createdat': createdat,
    };
  }

  factory FeedbackModel.fromMap(DocumentSnapshot<Map<String, dynamic>> map) {
    return FeedbackModel(
      id: map.id,
      user: map['user'] as String,
      body: map['body'] as String,
      createdat: map['createdat'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FeedbackModel.fromJson(String source) => FeedbackModel.fromMap(
      json.decode(source) as DocumentSnapshot<Map<String, dynamic>>);
}
