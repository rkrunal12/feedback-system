import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:feedback_system/controller/feedback_provider.dart';
import 'package:feedback_system/model/feedback_form_model.dart';

import 'feedback_screen_action_button.dart';
import 'text_filed_colum.dart';

class OptionEditorSection extends StatefulWidget {
  final bool isReview;
  final FeedbackType ratingFields;
  final String? formId;

  const OptionEditorSection({super.key, required this.isReview, required this.ratingFields, this.formId});

  @override
  State<OptionEditorSection> createState() => _OptionEditorSectionState();
}

class _OptionEditorSectionState extends State<OptionEditorSection> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _getController(String id, String initialValue) {
    if (!_controllers.containsKey(id)) {
      _controllers[id] = TextEditingController(text: initialValue);
    } else if (_controllers[id]!.text != initialValue) {
      // Sync if value changed externally but focus is elsewhere
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _controllers[id]!.text != initialValue) {
          _controllers[id]!.text = initialValue;
        }
      });
    }
    return _controllers[id]!;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isReview || (widget.ratingFields.ratingType != 6 && widget.ratingFields.ratingType != 7 && widget.ratingFields.ratingType != 9)) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: 20),
        Consumer<FeedbackProvider>(
          builder: (context, provider, child) {
            final List<FeedbackOption> options = List.from(widget.ratingFields.feedbackOption ?? []);

            if (options.isEmpty) {
              options.add(FeedbackOption(optionName: "Option 1", status: 1, position: 1));

              WidgetsBinding.instance.addPostFrameCallback((_) {
                final updatedList = provider.selectedForm?.feedbackType?.map((element) {
                  if (element == widget.ratingFields) {
                    element.feedbackOption = options;
                  }
                  return element;
                }).toList();

                if (updatedList != null) {
                  provider.setDataToTheSelecteeForm(provider.selectedForm!.copyWith(feedbackType: updatedList));
                }
              });
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...List.generate(options.length, (index) {
                  final option = options[index];
                  final optionId = option.id?.toString() ?? "${widget.ratingFields.id}_$index";
                  final controller = _getController(optionId, option.optionName ?? "");

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFieldColumn(
                            successMessageController: controller,
                            label: "Option ${index + 1}",
                            onChanged: (val) {
                              final updatedOptions = List<FeedbackOption>.from(options);
                              updatedOptions[index] = updatedOptions[index].copyWith(optionName: val);

                              final updatedList = provider.selectedForm?.feedbackType?.map((element) {
                                if (element == widget.ratingFields) {
                                  element.feedbackOption = updatedOptions;
                                }
                                return element;
                              }).toList();

                              if (updatedList != null) {
                                provider.setDataToTheSelecteeForm(provider.selectedForm!.copyWith(feedbackType: updatedList));
                              }
                            },
                          ),
                        ),
                        if (widget.ratingFields.ratingType != 11) ...[
                          const SizedBox(width: 10),
                          IconButton(
                            onPressed: () async {
                              final removedOption = options[index];
                              _controllers.remove(optionId)?.dispose();

                              final updatedOptions = List<FeedbackOption>.from(options);
                              updatedOptions.removeAt(index);

                              final updatedList = provider.selectedForm?.feedbackType?.map((element) {
                                if (element == widget.ratingFields) {
                                  element.feedbackOption = updatedOptions;
                                }
                                return element;
                              }).toList();

                              if (updatedList != null) {
                                provider.setDataToTheSelecteeForm(provider.selectedForm!.copyWith(feedbackType: updatedList));
                              }

                              if (widget.formId != null && removedOption.id != null) {
                                await provider.deleteQuestion(widget.ratingFields.id!, removedOption.id!);
                              }
                            },
                            icon: const Icon(Icons.delete, color: Colors.blueGrey),
                          ),
                        ],
                      ],
                    ),
                  );
                }),
                if (widget.ratingFields.ratingType != 11)
                  FeedbackScreenActionButton(
                    onTap: () {
                      final updatedOptions = List<FeedbackOption>.from(options);
                      updatedOptions.add(
                        FeedbackOption(optionName: "Option ${updatedOptions.length + 1}", status: 1, position: updatedOptions.length + 1),
                      );

                      final updatedList = provider.selectedForm?.feedbackType?.map((element) {
                        if (element == widget.ratingFields) {
                          element.feedbackOption = updatedOptions;
                        }
                        return element;
                      }).toList();

                      if (updatedList != null) {
                        provider.setDataToTheSelecteeForm(provider.selectedForm!.copyWith(feedbackType: updatedList));
                      }
                    },
                    text: "Add Option",
                    isSelected: true,
                    width: double.infinity,
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
