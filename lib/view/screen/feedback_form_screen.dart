import 'package:feedback_system/color.dart';
import 'package:feedback_system/view/screen/customized_from_screen.dart';
import 'package:feedback_system/view/screen/customized_success_screen.dart';
import 'package:feedback_system/view/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

import '../../controller/feedback_provider.dart';
import '../widgets/feedback_screen_action_button.dart';
import 'customized_customer_details.dart';

class FeedbackFromScreen extends StatelessWidget {
  const FeedbackFromScreen({super.key, this.id});

  final String? id;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        final navigator = Navigator.of(context);
        if (!didPop) {
          final provider = Provider.of<FeedbackProvider>(context, listen: false);
          await provider.setSelectedForm(null);
          provider.setCreateFeedbackFormPageIndex(0);
          navigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorClass.appBarColor,
          title: Text(
            '${id == null ? "Create" : "Update"} Feedback Form',
            style: GoogleFonts.poppins(fontSize: 20, color: ColorClass.black, fontWeight: FontWeight.w600, height: 1.0, letterSpacing: 0),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 16),
                          Flexible(
                            child: FeedbackScreenActionButton(
                              width: size <= 1000 ? size * 0.25 : null,
                              text: "Feedback Screen",
                              onTap: () {
                                value.setCreateFeedbackFormPageIndex(0);
                              },
                              isSelected: value.createFeedbackFormPageIndex == 0,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: FeedbackScreenActionButton(
                              width: size <= 1000 ? size * 0.25 : null,
                              text: "Customer Details",
                              onTap: () {
                                value.setCreateFeedbackFormPageIndex(1);
                              },
                              isSelected: value.createFeedbackFormPageIndex == 1,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: FeedbackScreenActionButton(
                              width: size <= 1000 ? size * 0.25 : null,
                              text: "Success Screen",
                              onTap: () {
                                value.setCreateFeedbackFormPageIndex(2);
                              },
                              isSelected: value.createFeedbackFormPageIndex == 2,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: SizedBox(
                          width: size <= 1000 ? size * 0.1 : 150,
                          child: FeedbackScreenActionButton(
                            onTap: () async {
                              final navigator = Navigator.of(context);
                              final form = value.selectedForm;
                              if (form == null) return;

                              if (form.formName == null || form.formName!.trim().isEmpty) {
                                CustomeToast.showError("Please Fill form name");
                                return;
                              }
                              if (form.formTitle == null || form.formTitle!.trim().isEmpty) {
                                CustomeToast.showError("Please Fill form title");
                                return;
                              }
                              if (form.button == null || form.button!.trim().isEmpty) {
                                CustomeToast.showError("Please Fill button text");
                                return;
                              }

                              if (form.feedbackType != null) {
                                for (var rating in form.feedbackType!) {
                                  if (rating.status == 1) {
                                    if (rating.ratingName == null || rating.ratingName!.trim().isEmpty) {
                                      CustomeToast.showError("Please fill name for all active ratings");
                                      return;
                                    }
                                    if (rating.ratingTitle == null || rating.ratingTitle!.trim().isEmpty) {
                                      CustomeToast.showError("Please fill title for all active ratings");
                                      return;
                                    }
                                  }
                                }
                              }

                              if (form.reviewStatus == 1) {
                                if (form.reviewTitle == null || form.reviewTitle!.trim().isEmpty) {
                                  CustomeToast.showError("Please fill review title");
                                  return;
                                }
                                if (form.reviewPlaceholder == null || form.reviewPlaceholder!.trim().isEmpty) {
                                  CustomeToast.showError("Please fill review placeholder");
                                  return;
                                }
                              }

                              if (form.responseFeedback == null ||
                                  form.responseFeedback!.isEmpty ||
                                  form.responseFeedback![0].message == null ||
                                  form.responseFeedback![0].message!.trim().isEmpty) {
                                CustomeToast.showError("Please Fill success message");
                                return;
                              }
                              if (form.responseFeedback![0].button == null || form.responseFeedback![0].button!.trim().isEmpty) {
                                CustomeToast.showError("Please Fill success button text");
                                return;
                              }

                              value.updateFormList();

                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    child: Container(
                                      padding: const EdgeInsets.all(32),
                                      constraints: const BoxConstraints(maxWidth: 400),
                                      decoration: BoxDecoration(
                                        color: ColorClass.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 10)),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SvgPicture.asset("assets/svg/success_dialoge.svg"),
                                          const SizedBox(height: 20),
                                          Text(
                                            "Successfully ${id == null ? "Created" : "Updated"} your Feedback form",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: ColorClass.black,
                                              letterSpacing: -0.5,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          SizedBox(
                                            width: double.infinity,
                                            height: 54,
                                            child: FeedbackScreenActionButton(
                                              onTap: () {
                                                navigator.pop();
                                                navigator.pop();
                                                value.setCreateFeedbackFormPageIndex(0);
                                                value.setSelectedForm(null);
                                              },
                                              color: ColorClass.white,
                                              backgournd: ColorClass.primaryColor,
                                              text: "Continue",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            text: "Submit",
                            isSelected: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(height: 2, width: double.infinity, color: ColorClass.divider),
                Expanded(
                  child: value.createFeedbackFormPageIndex == 0
                      ? const CustomizedFeedbackForm()
                      : value.createFeedbackFormPageIndex == 1
                      ? const CustomizedCustomerDetails()
                      : const CustomizedSuccessScreen(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
