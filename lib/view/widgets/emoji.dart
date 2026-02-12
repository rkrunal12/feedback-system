import 'dart:convert';
import 'dart:io';

import 'package:feedback_system/view/widgets/text_filed_colum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rating_and_feedback_collector/rating_and_feedback_collector.dart';
import 'package:svg_flutter/svg_flutter.dart';

import 'package:provider/provider.dart';
import '../../color.dart';
import '../../controller/feedback_provider.dart';
import '../../model/feedback_form_model.dart';

class Emoji extends StatefulWidget {
  final int ratingType;
  final dynamic rating;
  final Function(dynamic)? onRatingChanged;
  final List<String>? customLabels;
  final List<FeedbackOption>? options;
  final String? image;
  final int? index;

  const Emoji({super.key, required this.ratingType, this.rating, this.onRatingChanged, this.customLabels, this.options, this.image, this.index});

  @override
  State<Emoji> createState() => _EmojiState();
}

class _EmojiState extends State<Emoji> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.rating is String ? widget.rating : "");
  }

  @override
  void didUpdateWidget(covariant Emoji oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ratingType == 5 && widget.rating != oldWidget.rating) {
      String newText = widget.rating?.toString() ?? "";
      if (_textController.text != newText) {
        _textController.text = newText;
        _textController.selection = TextSelection.fromPosition(TextPosition(offset: _textController.text.length));
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.index != null) {
      return Selector<FeedbackProvider, (dynamic, String?, int?, List<FeedbackOption>?)>(
        selector: (_, provider) {
          final item = provider.selectedForm?.feedbackType?[widget.index!];
          return (item?.ratingValue, item?.image, item?.ratingType, item?.feedbackOption);
        },
        builder: (context, data, child) {
          final provider = Provider.of<FeedbackProvider>(context, listen: false);
          final feedbackItem = provider.selectedForm?.feedbackType?[widget.index!];
          if (feedbackItem == null) return const SizedBox.shrink();

          return _buildRatingWidget(
            context,
            data.$3 ?? 1,
            data.$1,
            data.$2,
            data.$4?.map((opt) => opt.optionName ?? "").toList() ?? widget.customLabels,
          );
        },
      );
    }

    return _buildRatingWidget(context, widget.ratingType, widget.rating, widget.image, widget.customLabels);
  }

  Widget _buildRatingWidget(BuildContext context, int ratingType, dynamic currentRating, String? currentImage, List<String>? currentLabels) {
    num rate = 0;
    if (currentRating is num) {
      rate = currentRating;
    } else if (currentRating is String) {
      rate = num.tryParse(currentRating) ?? 0;
    }

    switch (ratingType) {
      case 1:
        return StarRatingWidget(rate: rate, onRatingChanged: widget.onRatingChanged);
      case 2:
        final labels = (currentLabels != null && currentLabels.isNotEmpty && currentLabels.length == 5)
            ? currentLabels
            : const ['Very bad', 'Bad', 'Medium', 'Good', 'Excellent'];
        return EmojiRatingWidget(rate: rate, labels: labels, onRatingChanged: widget.onRatingChanged);
      case 3:
        return LikeDislikeRatingWidget(currentRating: currentRating, onRatingChanged: widget.onRatingChanged);
      case 4:
        return NumberRatingWidget(rate: rate, onRatingChanged: widget.onRatingChanged);
      case 5:
        return TextFeedbackRatingWidget(controller: _textController, onRatingChanged: widget.onRatingChanged);
      case 6:
        final options = (currentLabels != null && currentLabels.isNotEmpty) ? currentLabels : ["Option 1", "Option 2", "Option 3", "Option 4"];
        return McqRatingWidget(options: options, currentRating: currentRating, onRatingChanged: widget.onRatingChanged);
      case 7:
        final options = (currentLabels != null && currentLabels.isNotEmpty) ? currentLabels : ["Option 1", "Option 2", "Option 3", "Option 4"];
        List<String> selectedOptions = [];
        if (currentRating is List) {
          selectedOptions = List<String>.from(currentRating);
        } else if (currentRating is String) {
          selectedOptions = [currentRating];
        } else {
          selectedOptions = [];
        }
        return MultipleChoiceRatingWidget(options: options, selectedOptions: selectedOptions, onRatingChanged: widget.onRatingChanged);
      case 8:
        return SliderRatingWidget(rate: rate, onRatingChanged: widget.onRatingChanged);
      case 9:
        final options = (currentLabels != null && currentLabels.isNotEmpty) ? currentLabels : ["Option 1", "Option 2", "Option 3", "Option 4"];
        List<String> currentOrder = [];
        if (currentRating is List) {
          final savedList = List<String>.from(currentRating);
          currentOrder = savedList.where((item) => options.contains(item)).toList();
          for (var option in options) {
            if (!currentOrder.contains(option)) {
              currentOrder.add(option);
            }
          }
        } else {
          currentOrder = List.from(options);
        }
        return ReorderableRatingWidget(currentOrder: currentOrder, onRatingChanged: widget.onRatingChanged);
      case 10:
        return NpsRatingWidget(rate: rate, currentRating: currentRating, onRatingChanged: widget.onRatingChanged);
      case 11:
        return ImageFeedbackRatingWidget(
          rate: rate,
          currentRating: currentRating,
          currentImage: currentImage,
          currentLabels: currentLabels,
          onRatingChanged: widget.onRatingChanged,
        );
      default:
        return const Text("This is default rating");
    }
  }
}

class StarRatingWidget extends StatelessWidget {
  final num rate;
  final Function(dynamic)? onRatingChanged;

  const StarRatingWidget({super.key, required this.rate, this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return RatingBar(
      iconSize: 40,
      currentRating: rate.toDouble(),
      filledIcon: Icons.star,
      halfFilledIcon: Icons.star_half,
      allowHalfRating: true,
      emptyIcon: Icons.star_border,
      filledColor: Colors.amber,
      emptyColor: Colors.grey,
      onRatingChanged: (val) {
        onRatingChanged?.call(val);
      },
    );
  }
}

class EmojiRatingWidget extends StatelessWidget {
  final num rate;
  final List<String> labels;
  final Function(dynamic)? onRatingChanged;

  const EmojiRatingWidget({super.key, required this.rate, required this.labels, this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return EmojiFeedback(
      onChanged: (val) {
        onRatingChanged?.call(val);
      },
      initialRating: rate.toInt(),
      customLabels: labels,
    );
  }
}

class LikeDislikeRatingWidget extends StatelessWidget {
  final dynamic currentRating;
  final Function(dynamic)? onRatingChanged;

  const LikeDislikeRatingWidget({super.key, this.currentRating, this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () => onRatingChanged?.call(true),
          child: SvgPicture.asset(
            "assets/svg/like.svg",
            colorFilter: ColorFilter.mode(currentRating == true ? Colors.green : Colors.grey, BlendMode.color),
          ),
        ),
        InkWell(
          onTap: () => onRatingChanged?.call(false),
          child: SvgPicture.asset(
            "assets/svg/dislike.svg",
            colorFilter: ColorFilter.mode(currentRating == false ? Colors.red : Colors.grey, BlendMode.color),
          ),
        ),
      ],
    );
  }
}

class NumberRatingWidget extends StatelessWidget {
  final num rate;
  final Function(dynamic)? onRatingChanged;

  const NumberRatingWidget({super.key, required this.rate, this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          child: Row(
            children: List.generate(
              5,
              (index) => Expanded(
                child: InkWell(
                  onTap: () => onRatingChanged?.call(index + 1),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: rate.toInt() >= index + 1 ? ColorClass.primaryColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: ColorClass.primaryColor),
                    ),
                    child: Center(
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: rate.toInt() >= index + 1 ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Very Bad", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
              Text("Excellent", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}

class TextFeedbackRatingWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(dynamic)? onRatingChanged;

  const TextFeedbackRatingWidget({super.key, required this.controller, this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFieldColumn(
        successMessageController: controller,
        label: "your Feedback",
        onChanged: (val) => onRatingChanged?.call(val),
        isEdit: true,
      ),
    );
  }
}

class McqRatingWidget extends StatelessWidget {
  final List<String> options;
  final dynamic currentRating;
  final Function(dynamic)? onRatingChanged;

  const McqRatingWidget({super.key, required this.options, this.currentRating, this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((option) {
        final isSelected = currentRating == option;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            onTap: () => onRatingChanged?.call(option),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? ColorClass.primaryColor.withValues(alpha: 0.05) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? ColorClass.primaryColor : Colors.grey.withValues(alpha: 0.3), width: isSelected ? 1.5 : 1),
              ),
              child: Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: isSelected ? ColorClass.primaryColor : Colors.grey, width: 2),
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: ColorClass.primaryColor),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    option,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isSelected ? ColorClass.primaryColor : Colors.black87,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class MultipleChoiceRatingWidget extends StatelessWidget {
  final List<String> options;
  final List<String> selectedOptions;
  final Function(dynamic)? onRatingChanged;

  const MultipleChoiceRatingWidget({super.key, required this.options, required this.selectedOptions, this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((option) {
        final isSelected = selectedOptions.contains(option);
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            onTap: () {
              final newList = List<String>.from(selectedOptions);
              if (isSelected) {
                newList.remove(option);
              } else {
                newList.add(option);
              }
              onRatingChanged?.call(newList);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? ColorClass.primaryColor.withValues(alpha: 0.05) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? ColorClass.primaryColor : Colors.grey.withValues(alpha: 0.3), width: isSelected ? 1.5 : 1),
              ),
              child: Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: isSelected ? ColorClass.primaryColor : Colors.grey, width: 2),
                      color: isSelected ? ColorClass.primaryColor : Colors.transparent,
                    ),
                    child: isSelected ? const Center(child: Icon(Icons.check, size: 14, color: Colors.white)) : null,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    option,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isSelected ? ColorClass.primaryColor : Colors.black87,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class SliderRatingWidget extends StatelessWidget {
  final num rate;
  final Function(dynamic)? onRatingChanged;

  const SliderRatingWidget({super.key, required this.rate, this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Rate from 1 to 10",
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: ColorClass.black),
            ),
            Text(
              rate.toInt().toString(),
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: ColorClass.primaryColor),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: ColorClass.primaryColor,
            inactiveTrackColor: ColorClass.primaryColor.withValues(alpha: 0.2),
            thumbColor: ColorClass.primaryColor,
            overlayColor: ColorClass.primaryColor.withValues(alpha: 0.1),
            trackHeight: 4.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
          ),
          child: Slider(
            value: rate.toDouble().clamp(1.0, 10.0),
            min: 1.0,
            max: 10.0,
            onChangeEnd: (double value) {
              onRatingChanged?.call(value.toInt());
            },
            onChanged: (double value) {
              onRatingChanged?.call(value.toInt());
            },
          ),
        ),
      ],
    );
  }
}

class ReorderableRatingWidget extends StatelessWidget {
  final List<String> currentOrder;
  final Function(dynamic)? onRatingChanged;

  const ReorderableRatingWidget({super.key, required this.currentOrder, this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      buildDefaultDragHandles: false,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final newList = List<String>.from(currentOrder);
        final String item = newList.removeAt(oldIndex);
        newList.insert(newIndex, item);
        onRatingChanged?.call(newList);
      },
      children: [
        for (int index = 0; index < currentOrder.length; index++)
          Container(
            key: ValueKey(currentOrder[index]),
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: ColorClass.divider, width: 0.5),
            ),
            child: ReorderableDragStartListener(
              index: index,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: Icon(Icons.drag_indicator, color: ColorClass.grey),
                title: Text(
                  currentOrder[index],
                  style: GoogleFonts.poppins(fontSize: 14, color: ColorClass.black, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class NpsRatingWidget extends StatelessWidget {
  final dynamic currentRating;
  final num rate;
  final Function(dynamic)? onRatingChanged;

  const NpsRatingWidget({super.key, this.currentRating, required this.rate, this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 60,
          child: Row(
            children: List.generate(
              11,
              (index) => Expanded(
                child: InkWell(
                  onTap: () => onRatingChanged?.call(index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: (currentRating != null && currentRating.toString().isNotEmpty && rate.toInt() >= index)
                          ? ColorClass.primaryColor
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: ColorClass.primaryColor),
                    ),
                    child: Center(
                      child: Text(
                        "$index",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: (currentRating != null && currentRating.toString().isNotEmpty && rate.toInt() >= index)
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Not likely at all", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
              Text("Extremely likely", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}

class ImageFeedbackRatingWidget extends StatelessWidget {
  final dynamic currentRating;
  final num rate;
  final String? currentImage;
  final List<String>? currentLabels;
  final Function(dynamic)? onRatingChanged;

  const ImageFeedbackRatingWidget({super.key, this.currentRating, required this.rate, this.currentImage, this.currentLabels, this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (idx) {
        final isSelected = (currentRating != null && currentRating.toString().isNotEmpty && rate.toInt() >= idx + 1);

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: InkWell(
              onTap: () => onRatingChanged?.call(idx + 1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    child: _OptimizedImage(image: currentImage, isSelected: isSelected),
                  ),
                  const SizedBox(height: 5),
                  if (currentLabels != null && currentLabels!.length > idx)
                    Text(
                      currentLabels![idx],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(fontSize: 10, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _OptimizedImage extends StatelessWidget {
  final String? image;
  final bool isSelected;

  const _OptimizedImage({required this.image, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    if (image == null || image!.isEmpty) {
      return Icon(Icons.image, color: isSelected ? ColorClass.primaryColor : Colors.grey, size: 30);
    }

    final imageProvider = (image!.startsWith("data:") || image!.length > 1000)
        ? MemoryImage(base64Decode(image!.split(',').last))
        : FileImage(File(image!)) as ImageProvider;

    return Opacity(
      opacity: isSelected ? 1.0 : 0.4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image(image: imageProvider, fit: BoxFit.cover, gaplessPlayback: true),
      ),
    );
  }
}
