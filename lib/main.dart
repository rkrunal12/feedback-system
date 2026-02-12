import 'package:feedback_system/app_pref.dart';
import 'package:feedback_system/controller/feedback_provider.dart';
import 'package:feedback_system/view/screen/feedback_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPref.init();
  runApp(ChangeNotifierProvider(create: (context) => FeedbackProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFF0AA89E),
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF0AA89E)),
        ),
        home: const FeedbackHomeScreen(),
      ),
    );
  }
}
