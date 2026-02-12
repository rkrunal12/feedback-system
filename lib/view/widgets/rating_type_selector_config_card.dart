import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/feedback_provider.dart';
import '../../model/feedback_form_model.dart';
import 'feedback_time_radio.dart';

class RatingTypeSelector extends StatelessWidget {
  final FeedbackType ratingFields;
  final ScrollController scrollController;

  const RatingTypeSelector({super.key, required this.ratingFields, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedbackProvider>(
      builder: (context, provider, child) {
        void onRatingChanged(int? val) {
          if (val == null) return;

          final updatedList = provider.selectedForm?.feedbackType?.map((element) {
            if (element == ratingFields) {
              element.ratingType = val;
            }
            return element;
          }).toList();

          if (updatedList != null) {
            provider.setDataToTheSelecteeForm(provider.selectedForm!.copyWith(feedbackType: updatedList));
          }
        }

        final options = [
          FeedbackTimeRadioOption(title: "Star", value: 1, groupValue: ratingFields.ratingType ?? 1, onChanged: onRatingChanged, tarilingSvg: "star"),
          FeedbackTimeRadioOption(
            title: "Emoji",
            value: 2,
            groupValue: ratingFields.ratingType ?? 1,
            onChanged: onRatingChanged,
            tarilingSvg: "emoji",
          ),
          FeedbackTimeRadioOption(
            title: "Like / Dislike",
            value: 3,
            groupValue: ratingFields.ratingType ?? 1,
            onChanged: onRatingChanged,
            tarilingSvg: "likedislike",
          ),
          FeedbackTimeRadioOption(title: "1 to 5", value: 4, groupValue: ratingFields.ratingType ?? 1, onChanged: onRatingChanged),
          FeedbackTimeRadioOption(title: "Text", value: 5, groupValue: ratingFields.ratingType ?? 1, onChanged: onRatingChanged),
          FeedbackTimeRadioOption(
            title: "MCQ",
            value: 6,
            groupValue: ratingFields.ratingType ?? 1,
            onChanged: onRatingChanged,
            tarilingSvg: "choice",
          ),
          FeedbackTimeRadioOption(
            title: "Multiple choice",
            value: 7,
            groupValue: ratingFields.ratingType ?? 1,
            onChanged: onRatingChanged,
            tarilingSvg: "check",
          ),
          FeedbackTimeRadioOption(
            title: "Slider",
            value: 8,
            groupValue: ratingFields.ratingType ?? 1,
            onChanged: onRatingChanged,
            tarilingSvg: "slider",
          ),
          FeedbackTimeRadioOption(
            title: "Ranking",
            value: 9,
            groupValue: ratingFields.ratingType ?? 1,
            onChanged: onRatingChanged,
            tarilingSvg: "rank",
          ),
          FeedbackTimeRadioOption(
            title: "NPS (Net Promoter Score)",
            value: 10,
            groupValue: ratingFields.ratingType ?? 1,
            onChanged: onRatingChanged,
            tarilingSvg: "nps",
          ),
          FeedbackTimeRadioOption(title: "Image", value: 11, groupValue: ratingFields.ratingType ?? 1, onChanged: onRatingChanged),
        ];

        return Row(
          children: [
            IconButton(
              onPressed: () {
                scrollController.animateTo(
                  (scrollController.offset - 155).clamp(0.0, scrollController.position.maxScrollExtent),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              icon: const Icon(Icons.arrow_back_ios, size: 20),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(spacing: 5, children: options),
              ),
            ),
            IconButton(
              onPressed: () {
                scrollController.animateTo(
                  (scrollController.offset + 255).clamp(0.0, scrollController.position.maxScrollExtent),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                );
              },
              icon: const Icon(Icons.arrow_forward_ios, size: 20),
            ),
          ],
        );
      },
    );
  }
}
