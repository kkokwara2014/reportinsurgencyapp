import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CommentModel {
  String? id;
  String insurgreportid;
  String user;
  String content;
  String createdat;
  CommentModel({
    this.id,
    required this.insurgreportid,
    required this.user,
    required this.content,
    required this.createdat,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'insurgreportid': insurgreportid,
      'user': user,
      'content': content,
      'createdat': createdat,
    };
  }

  factory CommentModel.fromMap(DocumentSnapshot<Map<String, dynamic>> map) {
    return CommentModel(
      id: map.id,
      insurgreportid: map['insurgreportid'] as String,
      user: map['user'] as String,
      content: map['content'] as String,
      createdat: map['createdat'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) => CommentModel.fromMap(
      json.decode(source) as DocumentSnapshot<Map<String, dynamic>>);
}
