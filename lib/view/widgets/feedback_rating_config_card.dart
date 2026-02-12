import 'package:feedback_system/controller/feedback_provider.dart';
import 'package:feedback_system/model/feedback_form_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../color.dart';
import 'card_action_config_card.dart';
import 'image_rating_section_config_card.dart';
import 'open_editor_section_config_card.dart';
import 'name_and_title_section_config_card.dart';
import 'rating_type_selector_config_card.dart';

class FeedbackRatingConfigCard extends StatefulWidget {
  final FeedbackType ratingFields;
  final bool isReview;
  final String? formId;

  const FeedbackRatingConfigCard({super.key, required this.ratingFields, this.isReview = false, this.formId});

  @override
  State<FeedbackRatingConfigCard> createState() => _FeedbackRatingConfigCardState();
}

class _FeedbackRatingConfigCardState extends State<FeedbackRatingConfigCard> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController placeholderController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<FeedbackProvider>(context, listen: false);

    if (widget.isReview) {
      titleController.text = provider.selectedForm?.reviewTitle ?? "";
      placeholderController.text = provider.selectedForm?.reviewPlaceholder ?? "";
    } else {
      titleController.text = widget.ratingFields.ratingTitle ?? "";
      nameController.text = widget.ratingFields.ratingName ?? "";
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    placeholderController.dispose();
    nameController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isReview) ...[
          Text(
            "Write a review",
            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: ColorClass.black),
          ),
        ],
        const SizedBox(height: 5),
        Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorClass.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: ColorClass.divider, width: 0.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NameAndTitleSection(
                      isReview: widget.isReview,
                      ratingFields: widget.ratingFields,
                      nameController: nameController,
                      titleController: titleController,
                      placeholderController: placeholderController,
                    ),

                    /// RATING TYPE OPTIONS (horizontal radio list)
                    if (!widget.isReview) ...[
                      const SizedBox(height: 15),
                      Text(
                        "Rating type",
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: ColorClass.black),
                      ),
                      const SizedBox(height: 10),
                      RatingTypeSelector(ratingFields: widget.ratingFields, scrollController: _scrollController),
                    ],

                    OptionEditorSection(isReview: widget.isReview, ratingFields: widget.ratingFields, formId: widget.formId),

                    ImageRatingSection(ratingFields: widget.ratingFields),
                  ],
                ),
              ),
            ),

            CardActions(isReview: widget.isReview, ratingFields: widget.ratingFields, formId: widget.formId),
          ],
        ),
      ],
    );
  }
}
