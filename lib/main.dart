import 'package:flutter/material.dart';
import 'package:reportinsurgencyapp/models/feedback_model.dart';
import 'package:reportinsurgencyapp/models/report_model.dart';
import 'package:reportinsurgencyapp/models/user_model.dart';
import 'package:reportinsurgencyapp/screens/auth_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:reportinsurgencyapp/services/feedback_service.dart';
import 'package:reportinsurgencyapp/services/report_service.dart';
import 'package:reportinsurgencyapp/services/user_service.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ReportService report = ReportService();
    // final ResolvedReportService resolvedReport = ResolvedReportService();
    // final ReportService resolvedReports = ReportService();
    final UserService users = UserService();

    final FeedbackService feedbacks = FeedbackService();
    return MultiProvider(
      providers: [
        StreamProvider<List<ReportModel>>(
            create: (context) => report.getReports(), initialData: []),
        // StreamProvider<List<ReportModel>>(
        //     create: (context) => resolvedReport.getResolvedReports(),
        //     initialData: []),
        StreamProvider<List<UserModel>>(
            create: (context) => users.allUsers(), initialData: []),

        StreamProvider<List<FeedbackModel>>(
            create: (context) => feedbacks.feedbackStream(), initialData: []),
        Provider(create: (context) => AuthService()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Report Insurgency App',
        theme: ThemeData(primarySwatch: Colors.green),
        defaultTransition: Transition.leftToRightWithFade,
        home: const AuthScreen(),
      ),
    );
  }
}
