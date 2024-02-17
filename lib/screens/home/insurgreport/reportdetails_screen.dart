import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:reportinsurgencyapp/models/comment_model.dart';
import 'package:reportinsurgencyapp/models/report_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InsurgencyReportDetails extends StatefulWidget {
  final ReportModel report;
  const InsurgencyReportDetails({super.key, required this.report});

  @override
  State<InsurgencyReportDetails> createState() =>
      _InsurgencyReportDetailsState();
}

class _InsurgencyReportDetailsState extends State<InsurgencyReportDetails> {
//text input controller
  final commentController = TextEditingController();
  final loggedInUser = FirebaseAuth.instance.currentUser!;

  Stream<List<CommentModel>> commentStream() {
    return FirebaseFirestore.instance
        .collection("comments")
        .where("insurgreportid", isEqualTo: widget.report.id)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((e) => CommentModel.fromMap(e)).toList());
  }

  addComment() async {
    if (commentController.text.isNotEmpty) {
      CommentModel comment = CommentModel(
          insurgreportid: widget.report.id!,
          user: loggedInUser.email!,
          content: commentController.text.trim(),
          createdat: DateTime.now().toIso8601String());
      await FirebaseFirestore.instance
          .collection("comments")
          .add(comment.toMap());
      commentController.clear();
    }
  }

  deleteComment(CommentModel comment) async {
    await FirebaseFirestore.instance
        .collection("comments")
        .doc(comment.id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report Details"),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            //report info
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.report.comment,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatDate(DateTime.parse(widget.report.createdat),
                              [dd, '-', M, '-', yyyy, ' ', hh, ':', mm, am]),
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Transform(
                          transform: Matrix4.identity()..scale(0.8),
                          child: Chip(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            backgroundColor: widget.report.ishandled
                                ? Colors.green
                                : Colors.red,
                            visualDensity: VisualDensity.compact,
                            label: widget.report.ishandled
                                ? const Text(
                                    "Resolved",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  )
                                : const Text(
                                    "Unresolved",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    //comments
                    const Text(
                      "Comments",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                        child: StreamBuilder(
                            stream: commentStream(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.hasData) {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      final comment = snapshot.data![index];
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 8),
                                        margin: const EdgeInsets.only(
                                          top: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(comment.content),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.person,
                                                  size: 16,
                                                  color: Colors.grey.shade600,
                                                ),
                                                Text(
                                                  comment.user,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  formatDate(
                                                      DateTime.parse(
                                                          comment.createdat),
                                                      [
                                                        dd,
                                                        '-',
                                                        M,
                                                        '-',
                                                        yyyy,
                                                        ' ',
                                                        h,
                                                        ':',
                                                        mm,
                                                        '',
                                                        am
                                                      ]),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              } else if (!snapshot.hasData) {
                                return const Text("No Comment!");
                              } else {
                                return Text("");
                              }
                            }))
                  ],
                ),
              ),
            ),

            //text input for comments
            // Padding(
            //   padding: const EdgeInsets.all(4.0),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: TextField(
            //           controller: commentController,
            //           decoration: const InputDecoration(
            //             hintText: "Comment here...",
            //             contentPadding: EdgeInsets.all(12),
            //             border: OutlineInputBorder(),
            //           ),
            //         ),
            //       ),
            //       IconButton(
            //           onPressed: () {
            //             addComment();
            //           },
            //           icon: const Icon(Icons.arrow_circle_up))
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
