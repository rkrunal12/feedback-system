import 'dart:developer';

import 'package:feedback_system/view/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

import '../../color.dart';
import '../../controller/feedback_provider.dart';
import '../../model/feedback_form_model.dart';
import 'feedback_screen_action_button.dart';
import 'text_filed_colum.dart';

class ContactListTile extends StatefulWidget {
  const ContactListTile({
    super.key,
    this.contact,
    this.isEditing = false,
    this.onAppliedChange,
    this.onMandatoryChange,
    this.onTitleChange,
    this.onEditingChange,
  });

  final CustomerFeedback? contact;
  final bool? isEditing;
  final void Function(int)? onAppliedChange;
  final void Function(int)? onMandatoryChange;
  final void Function(String)? onTitleChange;
  final void Function(bool)? onEditingChange;

  @override
  State<ContactListTile> createState() => _ContactListTileState();
}

class _ContactListTileState extends State<ContactListTile> {
  final TextEditingController titleController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FeedbackProvider>(listen: false, context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: ColorClass.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: ColorClass.divider, width: 0.5),
      ),
      child: Row(
        children: [
          Checkbox(
            value: widget.contact?.status == 1,
            onChanged: (val) => widget.onAppliedChange?.call(val == true ? 1 : 0),
            activeColor: ColorClass.primaryColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: widget.contact == null || (widget.contact?.isEditing ?? false)
                ? Container(
                    decoration: BoxDecoration(color: ColorClass.white, borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFieldColumn(
                            color: ColorClass.primaryColor,
                            successMessageController: titleController,
                            onChanged: (value) {},
                            label: "Custom name",
                          ),
                        ),
                        const SizedBox(width: 10),
                        FeedbackScreenActionButton(
                          textSize: 12,
                          width: 80,
                          height: 30,
                          onTap: () {
                            if (titleController.text.trim().isNotEmpty) {
                              if (widget.contact == null) {
                                final updatedList = List<CustomerFeedback>.from(provider.selectedForm?.customerFeedback ?? []);
                                updatedList.add(
                                  CustomerFeedback(
                                    fieldName: titleController.text,
                                    status: 1,
                                    isMandatory: 0,
                                    customerInfo: 1,
                                    customerInfoStatus: 1,
                                  ),
                                );
                                provider.setDataToTheSelecteeForm(provider.selectedForm!.copyWith(customerFeedback: updatedList));
                                titleController.clear();
                                provider.setIsAddingField(false);
                              } else {
                                widget.onTitleChange?.call(titleController.text);
                              }
                            } else {
                              CustomeToast.showError("Please enter a field name");
                            }
                          },
                          text: "Save",
                          isSelected: true,
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            if (widget.contact == null) {
                              provider.setIsAddingField(false);
                            } else {
                              widget.onEditingChange?.call(false);
                            }
                          },
                          child: SvgPicture.asset("assets/svg/delete.svg"),
                        ),
                      ],
                    ),
                  )
                : Text(
                    widget.contact?.fieldName ?? "",
                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: ColorClass.black),
                  ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible:
                    widget.contact != null &&
                    provider.getContactFieldIndex(widget.contact!.fieldName ?? "") >= 3 &&
                    !(widget.contact?.isEditing ?? false),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        titleController.text = widget.contact?.fieldName ?? "";
                        widget.onEditingChange?.call(true);
                      },
                      child: SvgPicture.asset("assets/svg/edit.svg"),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        final index = provider.getContactFieldIndex(widget.contact!.fieldName ?? "");
                        log("index $index");
                        if (index != -1) {
                          provider.removeContactField(index);
                        }
                      },
                      child: SvgPicture.asset("assets/svg/delete.svg"),
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: widget.contact?.isMandatory == 1,
                onChanged: (val) => widget.onMandatoryChange?.call(val == true ? 1 : 0),
                activeColor: ColorClass.primaryColor,
              ),
              const SizedBox(width: 5),
              Text(
                "Mandatory",
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: ColorClass.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
