import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:reportinsurgencyapp/models/comment_model.dart';
import 'package:reportinsurgencyapp/models/report_model.dart';
import 'package:reportinsurgencyapp/screens/home/insurgreport/reportdetails_screen.dart';
import 'package:reportinsurgencyapp/services/report_service.dart';

class AssignReportToOfficer extends StatefulWidget {
  const AssignReportToOfficer({super.key, required this.report});
  final ReportModel report;

  @override
  State<AssignReportToOfficer> createState() => _AssignReportToOfficerState();
}

class _AssignReportToOfficerState extends State<AssignReportToOfficer> {
  final ReportService reportService = ReportService();
  final user = FirebaseAuth.instance.currentUser!;
  String selectedOfficer = "0";
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assign Report to Officer"),
        elevation: 0,
      ),
      body: StreamProvider<List<CommentModel>>(
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
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //comment count
                    InkWell(
                      onTap: () {
                        Get.to(() =>
                            InsurgencyReportDetails(report: widget.report));
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
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Text("Select Officer to Handle this Report"),
                const SizedBox(
                  height: 5,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //list of officers
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .where("role", isEqualTo: "admin")
                                .snapshots(),
                            builder: (context, snapshot) {
                              List<DropdownMenuItem> officerItems = [];

                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                final officers =
                                    snapshot.data!.docs.reversed.toList();

                                officerItems.add(
                                  DropdownMenuItem(
                                    value: "0",
                                    child: Text("Select Officer"),
                                  ),
                                );

                                for (var officer in officers) {
                                  officerItems.add(DropdownMenuItem(
                                      value: officer.id,
                                      child: Text(officer['email'])));
                                }
                              }

                              return DropdownButton(
                                items: officerItems,
                                onChanged: (officer) {
                                  setState(() {
                                    selectedOfficer = officer;
                                  });
                                  print(officer);
                                },
                                value: selectedOfficer,
                                isExpanded: false,
                              );
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (selectedOfficer != "0") {
                                await FirebaseFirestore.instance
                                    .collection("insurgencyreports")
                                    .doc(widget.report.id)
                                    .update({
                                  'isassigned': true,
                                  'officerid': selectedOfficer,
                                });
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "${selectedOfficer} assigned to a report.")));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text("Please, select an Officer")));
                              }
                            }
                          },
                          child: Text("Assign"),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
