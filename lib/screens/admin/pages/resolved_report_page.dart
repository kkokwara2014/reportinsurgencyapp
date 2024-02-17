import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reportinsurgencyapp/components/report_list.dart';
import 'package:reportinsurgencyapp/models/report_model.dart';
import 'package:reportinsurgencyapp/services/resolved_report_service.dart';

class AdminResolvedReportPage extends StatefulWidget {
  const AdminResolvedReportPage({super.key});

  @override
  State<AdminResolvedReportPage> createState() =>
      _AdminResolvedReportPageState();
}

class _AdminResolvedReportPageState extends State<AdminResolvedReportPage> {
  final ResolvedReportService resolvedReport = ResolvedReportService();

  //logged in user
  final loggedInUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<ReportModel>>(
          stream: resolvedReport.getResolvedReports(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    "No Resolved Reports",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                );
              } else {
                return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          ReportModel report = snapshot.data![index];
                          return ReportList(report: report);
                        }));
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
