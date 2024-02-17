import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reportinsurgencyapp/components/report_list.dart';
import 'package:reportinsurgencyapp/models/report_model.dart';
import 'package:reportinsurgencyapp/services/report_service.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final reportController = TextEditingController();
  final ReportService reportService = ReportService();

  //logged in user
  final loggedInUser = FirebaseAuth.instance.currentUser!;

  //saving report to firebase firestore
  Future saveReport() async {
    if (reportController.text.isNotEmpty) {
      try {
        final insurgreport = ReportModel(
            comment: reportController.text.trim(),
            user: loggedInUser.email.toString(),
            ishandled: false,
            isassigned: false,
            createdat: DateTime.now().toString());

        // await _db.collection("insurgencyreports").add(insurgreport.toMap());
        await reportService.addReport(insurgreport);

        reportController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Report added successfully."),
          ),
        );
      } catch (e) {
        print(e);
      }
    }
  }

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
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: reports.length,
                        itemBuilder: (context, index) {
                          ReportModel report = reports[index];
                          return ReportList(report: report);
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: reportController,
                            decoration: const InputDecoration(
                              hintText: "Got something to say?",
                              contentPadding: EdgeInsets.all(12),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              saveReport();
                            },
                            icon: const Icon(
                              Icons.send,
                              color: Colors.green,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
