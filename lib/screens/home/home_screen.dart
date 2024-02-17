// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reportinsurgencyapp/components/app_drawer.dart';
import 'package:reportinsurgencyapp/constants/images.dart';
import 'package:reportinsurgencyapp/models/report_model.dart';
import 'package:reportinsurgencyapp/screens/home/reports/report_screen.dart';
import 'package:reportinsurgencyapp/screens/home/reports/resolved_report_screen.dart';
import 'package:reportinsurgencyapp/services/auth_service.dart';
import 'package:reportinsurgencyapp/services/report_service.dart';
// import 'package:reportinsurgencyapp/services/report_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    final currentUser2 = Provider.of<AuthService>(context, listen: false);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Insurgency Reports"),
          elevation: 0,
          actions: [
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Logout?"),
                    content: const Text("Do you want to logout?"),
                    actions: [
                      MaterialButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("No"),
                      ),
                      MaterialButton(
                        onPressed: () {
                          // currentUser.signOut();
                          currentUser2.signUserOut();
                          Navigator.pop(context);
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.only(right: 15),
                width: 50,
                height: 50,
                child: Image.asset(profileImage),
              ),
            )
          ],
          bottom: TabBar(tabs: [
            Tab(
              text: "Reports",
              icon: Icon(Icons.report_gmailerrorred),
            ),
            Tab(
              text: "Resolved Reports",
              icon: Icon(Icons.check_circle),
            ),
          ]),
        ),
        drawer: const AppDrawer(),
        body: TabBarView(children: [
          ReportScreen(),
          ResolvedReportScreen(),
        ]),
      ),
    );
  }
}
