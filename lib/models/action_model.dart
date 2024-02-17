import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ActionModel {
  String? id;
  String insurgreportid;
  String actiontaken;
  String user;
  bool handled;
  String createdat;
  ActionModel({
    this.id,
    required this.insurgreportid,
    required this.actiontaken,
    required this.user,
    required this.handled,
    required this.createdat,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'insurgreportid': insurgreportid,
      'actiontaken': actiontaken,
      'user': user,
      'handled': handled,
      'createdat': createdat,
    };
  }

  factory ActionModel.fromMap(DocumentSnapshot<Map<String, dynamic>> map) {
    return ActionModel(
      id: map.id,
      insurgreportid: map['insurgreportid'] as String,
      actiontaken: map['actiontaken'] as String,
      user: map['user'] as String,
      handled: map['handled'] as bool,
      createdat: map['createdat'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ActionModel.fromJson(String source) => ActionModel.fromMap(
      json.decode(source) as DocumentSnapshot<Map<String, dynamic>>);
}
