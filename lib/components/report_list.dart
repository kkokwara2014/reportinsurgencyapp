import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:reportinsurgencyapp/components/my_textfield.dart';
import 'package:reportinsurgencyapp/models/comment_model.dart';
import 'package:reportinsurgencyapp/models/report_model.dart';
import 'package:reportinsurgencyapp/screens/home/insurgreport/reportdetails_screen.dart';
import 'package:reportinsurgencyapp/services/report_service.dart';

class ReportList extends StatefulWidget {
  const ReportList({
    super.key,
    required this.report,
  });

  final ReportModel report;

  @override
  State<ReportList> createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
  final commentController = TextEditingController();
  final ReportService reportService = ReportService();
  final user = FirebaseAuth.instance.currentUser!;

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
                  widget.report.ishandled
                      ? Transform(
                          transform: new Matrix4.identity()..scale(0.8),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Resolution"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.report.officercomment
                                          .toString()),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                          "Officer: ${widget.report.officerid}")
                                    ],
                                  ),
                                  actions: [
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Ok"),
                                    )
                                  ],
                                ),
                              );
                            },
                            child: Chip(
                              backgroundColor: Colors.green,
                              label: Text(
                                "Resolved",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                        )
                      : MaterialButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text("Make Comment"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.report.comment,
                                            textAlign: TextAlign.justify,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          MyTextField(
                                              controller: commentController,
                                              inputType: TextInputType.text,
                                              prefixicon: Icons.comment,
                                              hintText: "Comment here...",
                                              validationString:
                                                  "Comment required"),
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
                                            if (commentController
                                                .text.isNotEmpty) {
                                              final CommentModel commentModel =
                                                  CommentModel(
                                                      insurgreportid:
                                                          widget.report.id!,
                                                      user: user.email!,
                                                      content: commentController
                                                          .text
                                                          .trim(),
                                                      createdat: DateTime.now()
                                                          .toIso8601String());
                                              await reportService
                                                  .addComment(commentModel);

                                              //clear the input box
                                              commentController.clear();
                                              //pop the dialog window
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Text("Send"),
                                        ),
                                      ],
                                    ));
                          },
                          child: Text(
                            "Comment",
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
