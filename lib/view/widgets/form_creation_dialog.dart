import 'package:feedback_system/app_pref.dart';
import 'package:feedback_system/controller/feedback_provider.dart';
import 'package:feedback_system/model/feedback_form_model.dart';
import 'package:feedback_system/view/screen/feedback_form_screen.dart';
import 'package:feedback_system/view/widgets/custom_toast.dart';
import 'package:feedback_system/view/widgets/feedback_screen_action_button.dart';
import 'package:feedback_system/view/widgets/text_filed_colum.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../color.dart';

class FormCreationDialog extends StatelessWidget {
  const FormCreationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController topicController = TextEditingController();

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.25),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Consumer<FeedbackProvider>(
            builder: (context, value, _) {
              return value.isAdding
                  ? SizedBox(height: 200, child: Center(child: Lottie.asset("assets/lottie/Create Post.json")))
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Create your form", style: GoogleFonts.poppins(fontSize: 16, color: Colors.black)),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              value.setDataToTheSelecteeForm(
                                FeedbackFormModel(
                                  shopId: AppPref().getShopId(),
                                  formName: "Manual Feedback Form",
                                  formTitle: "We’d Love your feedback!",
                                  formSubtitle: "Please rate your experience with us.",
                                  feedbackType: [
                                    FeedbackType(
                                      ratingName: "Service Quality",
                                      ratingTitle: "How was the service?",
                                      ratingType: 6,
                                      status: 1,
                                      feedbackOption: [
                                        FeedbackOption(optionName: "Excellent", status: 1),
                                        FeedbackOption(optionName: "Good", status: 1),
                                        FeedbackOption(optionName: "Average", status: 1),
                                        FeedbackOption(optionName: "Poor", status: 1),
                                      ],
                                    ),
                                    FeedbackType(ratingName: "Food Quality", ratingTitle: "How was the food?", ratingType: 1, status: 1),
                                  ],
                                  reviewTitle: "Write a Review",
                                  reviewPlaceholder: "Share your thoughts or suggestions",
                                  button: "Submit Feedback",
                                  reviewStatus: 1,
                                  customerFeedback: [
                                    CustomerFeedback(fieldName: "Name", status: 1, isMandatory: 0, customerInfo: 1, customerInfoStatus: 1),
                                    CustomerFeedback(fieldName: "Phone number", status: 1, isMandatory: 0, customerInfo: 1, customerInfoStatus: 1),
                                    CustomerFeedback(fieldName: "Email", status: 1, isMandatory: 1, customerInfo: 1, customerInfoStatus: 1),
                                  ],
                                  responseFeedback: [
                                    ResponseFeedback(
                                      message:
                                          "Thanks for your feedback! Please share your name, number, or email so we can reach you or send special offers.",
                                      button: "Done",
                                    ),
                                  ],
                                ),
                              );
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const FeedbackFromScreen()));
                            },
                            icon: Icon(Icons.edit, size: 18, color: ColorClass.black),
                            label: Text(
                              "Create Manually",
                              style: GoogleFonts.poppins(color: ColorClass.black, fontWeight: FontWeight.w500),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              side: BorderSide(color: Colors.grey.shade300),
                              alignment: Alignment.centerLeft,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey.shade300)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text("OR AI", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                            ),
                            Expanded(child: Divider(color: Colors.grey.shade300)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextFieldColumn(
                          successMessageController: topicController,
                          hintText: "Enter Topic (E.g. Restauant)",
                          isLable: true,
                          label: "Generate Using AI",
                          isEnter: false,
                          color: ColorClass.primaryColor,
                          size: 14,
                        ),
                        const SizedBox(height: 16),
                        FeedbackScreenActionButton(
                          width: double.infinity,
                          isSelected: true,
                          onTap: () async {
                            final topic = topicController.text.trim();
                            if (topic.isNotEmpty) {
                              final navigator = Navigator.of(context);

                              final form = await value.generateAiForm(topic);

                              value.setDataToTheSelecteeForm(
                                FeedbackFormModel(
                                  shopId: AppPref().getShopId(), // Default shop ID
                                  formId: "${DateTime.now().millisecondsSinceEpoch}",
                                  formName: "AI Generated Form - $topic",
                                  formTitle: "We’d Love your feedback!",
                                  formSubtitle: "Please rate your experience with us.",
                                  feedbackType: [
                                    FeedbackType(ratingName: "Service Quality", ratingTitle: "How was the service?", ratingType: 1, status: 1),
                                    FeedbackType(ratingName: "Food Quality", ratingTitle: "How was the food?", ratingType: 1, status: 1),
                                    ...form,
                                  ],
                                  reviewTitle: "Write a Review",
                                  reviewPlaceholder: "Share your thoughts or suggestions",
                                  button: "Submit Feedback",
                                  reviewStatus: 1,
                                  customerFeedback: [
                                    CustomerFeedback(fieldName: "Name", status: 1, isMandatory: 0, customerInfo: 1, customerInfoStatus: 1),
                                    CustomerFeedback(fieldName: "Phone number", status: 1, isMandatory: 0, customerInfo: 1, customerInfoStatus: 1),
                                    CustomerFeedback(fieldName: "Email", status: 1, isMandatory: 1, customerInfo: 1, customerInfoStatus: 1),
                                  ],
                                  responseFeedback: [
                                    ResponseFeedback(
                                      message:
                                          "Thanks for your feedback! Please share your name, number, or email so we can reach you or send special offers.",
                                      button: "Done",
                                    ),
                                  ],
                                ),
                              );

                              navigator.pop(); // Close dialog
                              navigator.push(MaterialPageRoute(builder: (context) => const FeedbackFromScreen()));
                            } else {
                              CustomeToast.showError("Please enter a topic");
                            }
                          },
                          text: "Generate",
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}
