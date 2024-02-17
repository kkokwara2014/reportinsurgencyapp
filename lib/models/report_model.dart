// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  String? id;
  String comment;
  String user;
  bool ishandled;
  bool isassigned;
  String? officerid;
  String? officercomment;
  String createdat;
  ReportModel({
    this.id,
    required this.comment,
    required this.user,
    required this.ishandled,
    required this.isassigned,
    this.officerid,
    this.officercomment,
    required this.createdat,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'comment': comment,
      'user': user,
      'ishandled': ishandled,
      'isassigned': isassigned,
      'officerid': officerid,
      'officercomment': officercomment,
      'createdat': createdat,
    };
  }

  factory ReportModel.fromMap(DocumentSnapshot<Map<String, dynamic>> map) {
    return ReportModel(
      id: map.id,
      comment: map['comment'] as String,
      user: map['user'] as String,
      ishandled: map['ishandled'] as bool,
      isassigned: map['isassigned'] as bool,
      officerid: map['officerid'] != null ? map['officerid'] as String : null,
      officercomment: map['officercomment'] != null
          ? map['officercomment'] as String
          : null,
      createdat: map['createdat'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReportModel.fromJson(String source) => ReportModel.fromMap(
      json.decode(source) as DocumentSnapshot<Map<String, dynamic>>);
}
