import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:feedback_system/controller/feedback_provider.dart';
import 'package:feedback_system/model/feedback_form_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:feedback_system/color.dart';

class ImageRatingSection extends StatelessWidget {
  final FeedbackType ratingFields;

  const ImageRatingSection({super.key, required this.ratingFields});

  @override
  Widget build(BuildContext context) {
    if (ratingFields.ratingType != 11) return const SizedBox.shrink();

    final provider = Provider.of<FeedbackProvider>(context, listen: false);

    return Column(
      children: [
        const SizedBox(height: 10),
        DottedBorder(
          options: RectDottedBorderOptions(color: ColorClass.grey, strokeWidth: 1, dashPattern: [5, 3]),
          child: Material(
            color: ColorClass.white,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () async {
                final result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false, lockParentWindow: true);
                if (result != null && result.files.single.path != null) {
                  final bytes = await File(result.files.single.path!).readAsBytes();
                  final base64Image = 'data:image/png;base64,${base64Encode(bytes)}';

                  final updatedList = provider.selectedForm?.feedbackType?.map((element) {
                    if (element == ratingFields) {
                      element.ratingImage = base64Image;
                    }
                    return element;
                  }).toList();

                  if (updatedList != null) {
                    provider.setDataToTheSelecteeForm(provider.selectedForm!.copyWith(feedbackType: updatedList));
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: ColorClass.divider, width: 0.5),
                  ),
                  child: ratingFields.ratingImage == null
                      ? Center(
                          child: Text("Add Rating Icon", style: TextStyle(color: ColorClass.black)),
                        )
                      : Stack(
                          children: [
                            Center(
                              child: Image(
                                image: (ratingFields.ratingImage!.startsWith("data:") || ratingFields.ratingImage!.length > 1000)
                                    ? MemoryImage(base64Decode(ratingFields.ratingImage!.split(',').last))
                                    : FileImage(File(ratingFields.ratingImage!)) as ImageProvider,
                                fit: BoxFit.contain,
                                gaplessPlayback: true,
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: InkWell(
                                onTap: () {
                                  final updatedList = provider.selectedForm?.feedbackType?.map((element) {
                                    if (element.image == ratingFields.ratingImage) {
                                      element.image = null;
                                    }
                                    return element;
                                  }).toList();

                                  if (updatedList != null) {
                                    provider.setDataToTheSelecteeForm(provider.selectedForm!.copyWith(feedbackType: updatedList));
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
