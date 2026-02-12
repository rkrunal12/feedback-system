import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../color.dart';
import '../../controller/feedback_provider.dart';
import '../../model/feedback_form_model.dart';
import 'feedback_screen_action_button.dart';

class CardActions extends StatelessWidget {
  final bool isReview;
  final FeedbackType ratingFields;
  final String? formId;

  const CardActions({super.key, required this.isReview, required this.ratingFields, this.formId});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Transform.scale(
        scale: 0.8,
        child: Consumer<FeedbackProvider>(
          builder: (context, provider, child) {
            final originalIndex = provider.selectedForm?.feedbackType?.indexWhere((item) => item.ratingTitle == ratingFields.ratingTitle) ?? -1;

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                  visible: originalIndex > 1 && !isReview,
                  child: FeedbackScreenActionButton(
                    text: "Delete",
                    color: ColorClass.red,
                    backgournd: ColorClass.white,
                    textSize: 15,
                    width: 90,
                    height: 40,
                    onTap: () async {
                      final List<FeedbackType> ratings = List.of(provider.selectedForm!.feedbackType ?? []);
                      final removedRating = ratings.removeAt(originalIndex);

                      provider.setDataToTheSelecteeForm(provider.selectedForm!.copyWith(feedbackType: ratings));

                      if (formId != null && removedRating.id != null) {
                        await provider.deleteQuestion(int.tryParse(formId!) ?? 0, removedRating.id!);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Switch(
                  value: !isReview ? (ratingFields.status == 1) : (provider.selectedForm?.reviewStatus == 1),
                  onChanged: (val) {
                    if (isReview) {
                      provider.setDataToTheSelecteeForm(provider.selectedForm!.copyWith(reviewStatus: val ? 1 : 0));
                    } else {
                      final updatedList = provider.selectedForm?.feedbackType?.map((element) {
                        if (element == ratingFields) {
                          element.status = val ? 1 : 0;
                        }
                        return element;
                      }).toList();

                      if (updatedList != null) {
                        provider.setDataToTheSelecteeForm(provider.selectedForm!.copyWith(feedbackType: updatedList));
                      }
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
