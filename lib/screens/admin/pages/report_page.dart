import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reportinsurgencyapp/components/report_list_toassign.dart';
import 'package:reportinsurgencyapp/models/report_model.dart';

class AdminReportPage extends StatefulWidget {
  const AdminReportPage({super.key});

  @override
  State<AdminReportPage> createState() => _AdminReportPageState();
}

class _AdminReportPageState extends State<AdminReportPage> {
  @override
  Widget build(BuildContext context) {
    final reports = Provider.of<List<ReportModel>>(context);
    return Scaffold(
      body: reports.isEmpty
          ? Center(
              child: Text(
                "No Unresolved Reports.",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                ReportModel report = reports[index];

                return ReportListToAssign(report: report);
              }),
    );
  }
}
