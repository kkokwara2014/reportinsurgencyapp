import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:reportinsurgencyapp/models/comment_model.dart';
import 'package:reportinsurgencyapp/models/report_model.dart';
import 'package:reportinsurgencyapp/screens/admin/pages/assign_report.dart';
import 'package:reportinsurgencyapp/screens/home/insurgreport/reportdetails_screen.dart';
import 'package:reportinsurgencyapp/services/officer_service.dart';
import 'package:reportinsurgencyapp/services/report_service.dart';

class ReportListToAssign extends StatefulWidget {
  const ReportListToAssign({
    super.key,
    required this.report,
  });

  final ReportModel report;

  @override
  State<ReportListToAssign> createState() => _ReportListToAssignState();
}

class _ReportListToAssignState extends State<ReportListToAssign> {
  final commentController = TextEditingController();
  final ReportService reportService = ReportService();
  final user = FirebaseAuth.instance.currentUser!;

  OfficerService officerService = OfficerService();

//comment controller
  final commentResolutionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<CommentModel>>(
      create: (context) => reportService.getComments(widget.report.id),
      initialData: [],
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            child: Text(widget.report.user.substring(0, 2).toUpperCase()),
          ),
          title: InkWell(
            onTap: () {
              Get.to(() => InsurgencyReportDetails(report: widget.report));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                widget.report.comment,
                textAlign: TextAlign.justify,
              ),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatDate(DateTime.parse(widget.report.createdat),
                        [dd, '-', M, '-', yyyy]),
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    formatDate(DateTime.parse(widget.report.createdat),
                        [h, ':', nn, am]),
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              // const SizedBox(
              //   height: 3,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //comment count
                  InkWell(
                    onTap: () {
                      Get.to(
                          () => InsurgencyReportDetails(report: widget.report));
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.chat,
                          size: 16,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Consumer<List<CommentModel>>(
                          builder: (context, value, child) => Text(
                            value.length.toString(),
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //make comment button
                  widget.report.isassigned
                      ? Row(
                          children: [
                            Transform(
                              transform: new Matrix4.identity()..scale(0.8),
                              child: Chip(
                                backgroundColor: Colors.grey.shade700,
                                label: Text(
                                  "Assigned",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ),
                            widget.report.officerid == user.email
                                ? TextButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title:
                                                    Text("Comment Resolution"),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(widget.report.comment),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    TextField(
                                                      controller:
                                                          commentResolutionController,
                                                      decoration:
                                                          InputDecoration(
                                                              hintText:
                                                                  "Comment..."),
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  MaterialButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("Cancel"),
                                                  ),
                                                  MaterialButton(
                                                    onPressed: () async {
                                                      if (commentResolutionController
                                                          .text.isNotEmpty) {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "insurgencyreports")
                                                            .doc(widget
                                                                .report.id)
                                                            .update({
                                                          "ishandled": true,
                                                          "officercomment":
                                                              commentResolutionController
                                                                  .text
                                                                  .trim(),
                                                        });
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child: Text("Submit"),
                                                  )
                                                ],
                                              ));
                                    },
                                    child: Text("Resolve"))
                                : SizedBox()
                          ],
                        )
                      : MaterialButton(
                          onPressed: () {
                            Get.to(() =>
                                AssignReportToOfficer(report: widget.report));
                          },
                          child: Text(
                            "Assign...",
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
