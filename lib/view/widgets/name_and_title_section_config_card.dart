import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/feedback_provider.dart';
import '../../model/feedback_form_model.dart';
import 'text_filed_colum.dart';

class NameAndTitleSection extends StatelessWidget {
  final bool isReview;
  final FeedbackType ratingFields;
  final TextEditingController nameController;
  final TextEditingController titleController;
  final TextEditingController placeholderController;

  const NameAndTitleSection({super.key, 
    required this.isReview,
    required this.ratingFields,
    required this.nameController,
    required this.titleController,
    required this.placeholderController,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FeedbackProvider>(context, listen: false);

    return Column(
      children: [
        if (!isReview) ...[
          TextFieldColumn(
            successMessageController: nameController,
            label: "Reason for question (e.g.,for food quality, for price)",
            isLable: true,
            onChanged: (val) {
              final updatedList = provider.selectedForm?.feedbackType?.map((element) {
                if (element == ratingFields) {
                  element.ratingName = val;
                }
                return element;
              }).toList();

              if (updatedList != null) {
                provider.setDataToTheSelecteeForm(provider.selectedForm!.copyWith(feedbackType: updatedList));
              }
            },
          ),
          const SizedBox(height: 15),
        ],

        /// TITLE FIELD
        TextFieldColumn(
          successMessageController: titleController,
          label: "Title",
          isLable: true,
          onChanged: (val) {
            if (isReview) {
              provider.setDataToTheSelecteeForm(provider.selectedForm!.copyWith(reviewTitle: val));
            } else {
              final updatedList = provider.selectedForm?.feedbackType?.map((element) {
                if (element == ratingFields) {
                  element.ratingTitle = val;
                }
                return element;
              }).toList();

              if (updatedList != null) {
                provider.setDataToTheSelecteeForm(provider.selectedForm!.copyWith(feedbackType: updatedList));
              }
            }
          },
        ),

        if (isReview) ...[
          const SizedBox(height: 15),
          TextFieldColumn(
            successMessageController: placeholderController,
            label: "Placeholder",
            onChanged: (val) {
              provider.setDataToTheSelecteeForm(provider.selectedForm!.copyWith(reviewPlaceholder: val));
            },
            isLable: true,
          ),
        ],
      ],
    );
  }
}
