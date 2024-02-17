import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reportinsurgencyapp/components/admin_drawer.dart';
import 'package:reportinsurgencyapp/constants/images.dart';
import 'package:reportinsurgencyapp/screens/admin/pages/profile_page.dart';
import 'package:reportinsurgencyapp/screens/admin/pages/report_page.dart';
import 'package:reportinsurgencyapp/screens/admin/pages/resolved_report_page.dart';
import 'package:reportinsurgencyapp/screens/admin/pages/users_page.dart';
import 'package:reportinsurgencyapp/services/auth_service.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int currentIndex = 0;

  final pages = const [
    AdminReportPage(),
    AdminResolvedReportPage(),
    AdminUsersPage(),
    AdminProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    final currentUser2 = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Page"),
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
      ),
      drawer: const AdminDrawer(),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          currentIndex: currentIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.check_circle), label: "Resolved"),
            BottomNavigationBarItem(
                icon: Icon(Icons.group_outlined), label: "Users"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ]),
    );
  }
}
