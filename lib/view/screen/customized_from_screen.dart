import 'package:feedback_system/controller/feedback_provider.dart';
import 'package:feedback_system/view/widgets/emoji.dart';
import 'package:feedback_system/view/widgets/feedback_screen_action_button.dart';
import 'package:feedback_system/view/widgets/text_filed_colum.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

import '../../color.dart';
import '../../model/feedback_form_model.dart';
import '../widgets/feedback_rating_config_card.dart';

class CustomizedFeedbackForm extends StatefulWidget {
  const CustomizedFeedbackForm({super.key});

  @override
  State<CustomizedFeedbackForm> createState() => _CustomizedFeedbackFormState();
}

class _CustomizedFeedbackFormState extends State<CustomizedFeedbackForm> {
  final TextEditingController _formNameController = TextEditingController();
  final TextEditingController _formTitleController = TextEditingController();
  final TextEditingController _formSubtitleController = TextEditingController();
  final TextEditingController _formReviewTitleController = TextEditingController();
  final TextEditingController _formReviewPlaceholderController = TextEditingController();
  final TextEditingController _formButtonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<FeedbackProvider>(context, listen: false);
    _formNameController.text = provider.selectedForm?.formName ?? "";
    _formTitleController.text = provider.selectedForm?.formTitle ?? "";
    _formSubtitleController.text = provider.selectedForm?.formSubtitle ?? "";
    _formReviewTitleController.text = provider.selectedForm?.reviewTitle ?? "";
    _formReviewPlaceholderController.text = provider.selectedForm?.reviewPlaceholder ?? "";
    _formButtonController.text = provider.selectedForm?.button ?? "";
  }

  @override
  void dispose() {
    _formNameController.dispose();
    _formTitleController.dispose();
    _formSubtitleController.dispose();
    _formReviewTitleController.dispose();
    _formReviewPlaceholderController.dispose();
    _formButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ColorClass.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: ColorClass.divider, width: 0.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Selector<FeedbackProvider, FeedbackFormModel?>(
                      selector: (context, provider) => provider.selectedForm,
                      builder: (context, selectedForm, _) {
                        if (selectedForm == null) return const SizedBox.shrink();
                        final provider = context.read<FeedbackProvider>();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 5,
                          children: [
                            TextFieldColumn(
                              successMessageController: _formNameController,
                              label: "Form Name",
                              isLable: true,
                              onChanged: (val) {
                                provider.setDataToTheSelecteeForm(selectedForm.copyWith(formName: val.trim()));
                              },
                            ),
                            const SizedBox(height: 5),
                            TextFieldColumn(
                              successMessageController: _formTitleController,
                              label: "Form Title",
                              isLable: true,
                              onChanged: (val) {
                                provider.setDataToTheSelecteeForm(selectedForm.copyWith(formTitle: val));
                              },
                            ),
                            const SizedBox(height: 5),
                            TextFieldColumn(
                              successMessageController: _formSubtitleController,
                              label: "Form Subtitle",
                              isLable: true,
                              onChanged: (val) {
                                provider.setDataToTheSelecteeForm(selectedForm.copyWith(formSubtitle: val));
                              },
                            ),
                            const SizedBox(height: 5),
                            ...selectedForm.feedbackType?.asMap().entries.map((entry) {
                                  final e = entry.value;
                                  return Column(
                                    children: [
                                      FeedbackRatingConfigCard(ratingFields: e, formId: selectedForm.formId),
                                      const SizedBox(height: 20),
                                    ],
                                  );
                                }).toList() ??
                                [],
                            const SizedBox(height: 5),
                            FeedbackScreenActionButton(
                              onTap: () {
                                provider.setDataToTheSelecteeForm(
                                  selectedForm.copyWith(
                                    feedbackType: [
                                      ...selectedForm.feedbackType ?? [],
                                      FeedbackType(ratingName: "Custom Feedback", ratingTitle: "Enter Feedback title", status: 1, ratingType: 1),
                                    ],
                                  ),
                                );
                              },
                              text: "+ Add Question",
                              isSelected: true,
                              width: double.infinity,
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: ColorClass.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: ColorClass.divider, width: 0.5),
                                    ),
                                    child: Selector<FeedbackProvider, int>(
                                      selector: (context, provider) => provider.selectedForm?.imageReview ?? 0,
                                      shouldRebuild: (oldValue, newValue) => oldValue != newValue,
                                      builder: (context, imageReview, child) {
                                        return SwitchListTile(
                                          activeThumbColor: ColorClass.white,
                                          activeTrackColor: ColorClass.primaryColor,
                                          value: imageReview == 1,
                                          onChanged: (value) {
                                            provider.setDataToTheSelecteeForm(selectedForm.copyWith(imageReview: value ? 1 : 0));
                                          },
                                          title: const Text("Allow users to upload image files."),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: ColorClass.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: ColorClass.divider, width: 0.5),
                                    ),
                                    child: Selector<FeedbackProvider, int>(
                                      selector: (context, provider) => provider.selectedForm?.videoReview ?? 0,
                                      shouldRebuild: (oldValue, newValue) => oldValue != newValue,
                                      builder: (context, videoReview, child) {
                                        return SwitchListTile(
                                          activeThumbColor: ColorClass.white,
                                          activeTrackColor: ColorClass.primaryColor,
                                          value: videoReview == 1,
                                          onChanged: (value) {
                                            provider.setDataToTheSelecteeForm(selectedForm.copyWith(videoReview: value ? 1 : 0));
                                          },
                                          title: const Text("Allow users to upload video files."),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            FeedbackRatingConfigCard(
                              isReview: true,
                              ratingFields: FeedbackType(ratingTitle: "Write a review", status: 1, ratingType: 1),
                            ),
                            const SizedBox(height: 15),
                            TextFieldColumn(
                              successMessageController: _formButtonController,
                              label: "Button",
                              onChanged: (val) {
                                provider.setDataToTheSelecteeForm(selectedForm.copyWith(button: val));
                              },
                              isLable: true,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: ColorClass.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: ColorClass.divider, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Preview",
                      style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600, color: ColorClass.black),
                    ),
                  ),
                  Container(color: ColorClass.divider, height: 1),
                  Expanded(
                    child: Selector<FeedbackProvider, FeedbackFormModel?>(
                      selector: (context, provider) => provider.selectedForm,
                      builder: (context, selectedForm, _) {
                        if (selectedForm == null) return const SizedBox.shrink();
                        final provider = context.read<FeedbackProvider>();
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              spacing: 20,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Center(child: SvgPicture.asset("assets/svg/5star.svg", width: 189, height: 49)),
                                Center(
                                  child: Text(
                                    selectedForm.formTitle ?? "",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: ColorClass.black),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    selectedForm.formSubtitle ?? "",
                                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: ColorClass.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                ...selectedForm.feedbackType?.asMap().entries.map((entry) {
                                      final e = entry.value;

                                      return Visibility(
                                        visible: e.status == 1,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: ColorClass.white,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: ColorClass.divider, width: 0.5),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(25.0),
                                              child: Column(
                                                spacing: 20,
                                                children: [
                                                  if (e.ratingType != 10) ...[
                                                    Text(
                                                      e.ratingTitle ?? "",
                                                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: ColorClass.black),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ] else ...[
                                                    Text(
                                                      "How likely are you to recommend ${e.ratingTitle ?? ""} to a friend?",
                                                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: ColorClass.black),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ],
                                                  Emoji(
                                                    index: entry.key,
                                                    ratingType: e.ratingType ?? 1,
                                                    rating: e.ratingValue,
                                                    image: e.image,
                                                    customLabels: e.feedbackOption?.map((opt) => opt.optionName ?? "").toList(),
                                                    onRatingChanged: (value) {
                                                      final updatedFeedbackType = selectedForm.feedbackType!.map((item) {
                                                        if (item == e) {
                                                          return item.copyWith(ratingValue: value);
                                                        }
                                                        return item;
                                                      }).toList();
                                                      provider.setDataToTheSelecteeForm(selectedForm.copyWith(feedbackType: updatedFeedbackType));
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList() ??
                                    [],

                                Visibility(
                                  visible: selectedForm.reviewStatus == 1,
                                  child: TextFieldColumn(
                                    successMessageController: TextEditingController(),
                                    label: selectedForm.reviewTitle ?? "",
                                    onChanged: (val) {},
                                    isLable: true,
                                    minLines: 4,
                                    color: ColorClass.black,
                                    isEnter: false,
                                    hintText: selectedForm.reviewPlaceholder ?? "",
                                  ),
                                ),
                                FeedbackScreenActionButton(onTap: () {}, text: selectedForm.button ?? "", width: double.infinity, isSelected: true),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
