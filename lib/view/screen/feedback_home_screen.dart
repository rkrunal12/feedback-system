import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

import '../../color.dart';
import '../../controller/feedback_provider.dart';
import '../widgets/feedback_screen_action_button.dart';
import 'all_feedback_form.dart';
import 'feedback_dashboard.dart';

class FeedbackHomeScreen extends StatefulWidget {
  const FeedbackHomeScreen({super.key});

  @override
  State<FeedbackHomeScreen> createState() => _FeedbackHomeScreenState();
}

class _FeedbackHomeScreenState extends State<FeedbackHomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorClass.white,
      appBar: AppBar(
        backgroundColor: ColorClass.appBarColor,
        title: Text(
          'Feedback Management',
          style: GoogleFonts.poppins(fontSize: 20, color: ColorClass.black, fontWeight: FontWeight.w600),
        ),
        actions: [
          SvgPicture.asset("assets/svg/home.svg"),
          const SizedBox(width: 5),
          SvgPicture.asset("assets/svg/print.svg"),
          const SizedBox(width: 5),
          SvgPicture.asset("assets/svg/wifi.svg"),
          const SizedBox(width: 10),
        ],
      ),
      body: Consumer<FeedbackProvider>(
        builder: (context, value, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 16),
                    FeedbackScreenActionButton(
                      text: "Feedback Dashboard",
                      onTap: () {
                        value.setMainPageIndex(0);
                      },
                      isSelected: value.mainPageIndex == 0,
                    ),
                    const SizedBox(width: 10),
                    FeedbackScreenActionButton(
                      text: "Create Feedback Form",
                      onTap: () {
                        value.setMainPageIndex(1);
                      },
                      isSelected: value.mainPageIndex == 1,
                    ),
                  ],
                ),
              ),
              Container(height: 2, width: double.infinity, color: ColorClass.divider),
              Expanded(child: value.mainPageIndex == 0 ? const FeedbackDashboard() : const AllFeedBackForm()),
            ],
          );
        },
      ),
    );
  }
}
