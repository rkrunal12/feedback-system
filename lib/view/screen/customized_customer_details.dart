import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../color.dart';
import '../../controller/feedback_provider.dart';
import '../widgets/contact_list_tile.dart';
import '../widgets/feedback_screen_action_button.dart';
import '../widgets/feedback_time_radio.dart';
import '../widgets/text_filed_colum.dart';
import '../../model/feedback_form_model.dart';

class CustomizedCustomerDetails extends StatefulWidget {
  const CustomizedCustomerDetails({super.key});

  @override
  State<CustomizedCustomerDetails> createState() => _CustomizedCustomerDetailsState();
}

class _CustomizedCustomerDetailsState extends State<CustomizedCustomerDetails> {
  final TextEditingController _fieldController = TextEditingController();

  @override
  void dispose() {
    _fieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FeedbackProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Container(
                width: double.minPositive,
                decoration: BoxDecoration(
                  color: ColorClass.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorClass.divider, width: 0.5),
                ),
                child: Container(
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
                        Text(
                          "Customer Details",
                          style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600, color: ColorClass.black),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: ColorClass.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: ColorClass.divider, width: 0.5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Fields",
                                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: ColorClass.black),
                                      ),
                                    ),
                                    FeedbackScreenActionButton(
                                      height: 40,
                                      width: 120,
                                      text: "Add Field",
                                      color: ColorClass.black,
                                      onTap: () {
                                        provider.setIsAddingField(true);
                                      },
                                      backgournd: ColorClass.white,
                                    ),
                                    const SizedBox(width: 10),
                                    Selector<FeedbackProvider, int?>(
                                      selector: (_, provider) =>
                                          provider.selectedForm?.customerFeedback?.any((e) => e.customerInfoStatus == 1) == true ? 1 : 0,
                                      builder: (context, isContactDetailsEnable, _) {
                                        return Switch(
                                          value: isContactDetailsEnable == 1,
                                          onChanged: (val) {
                                            provider.setDataToTheSelecteeForm(
                                              provider.selectedForm!.copyWith(
                                                customerFeedback: provider.selectedForm?.customerFeedback
                                                    ?.map((e) => e.copyWith(customerInfoStatus: val ? 1 : 0))
                                                    .toList(),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Selector<FeedbackProvider, (List<CustomerFeedback>?, bool)>(
                                  selector: (_, provider) => (provider.selectedForm?.customerFeedback, provider.isAddingField),
                                  builder: (context, data, _) {
                                    final customerFeedback = data.$1;
                                    final isAddingField = data.$2;
                                    return Column(
                                      children: [
                                        ...(customerFeedback?.map((e) {
                                              return ContactListTile(
                                                contact: e,
                                                onAppliedChange: (val) {
                                                  final updatedList = customerFeedback.map((element) {
                                                    if (element == e) {
                                                      return element.copyWith(status: val);
                                                    }
                                                    return element;
                                                  }).toList();
                                                  provider.setDataToTheSelecteeForm(provider.selectedForm!.copyWith(customerFeedback: updatedList));
                                                },
                                                onMandatoryChange: (val) {
                                                  final updatedList = customerFeedback.map((element) {
                                                    if (element == e) {
                                                      return element.copyWith(isMandatory: val);
                                                    }
                                                    return element;
                                                  }).toList();
                                                  provider.setDataToTheSelecteeForm(provider.selectedForm!.copyWith(customerFeedback: updatedList));
                                                },
                                                onTitleChange: (newTitle) {
                                                  final updatedList = customerFeedback.map((element) {
                                                    if (element == e) {
                                                      return element.copyWith(fieldName: newTitle, isEditing: false);
                                                    }
                                                    return element;
                                                  }).toList();
                                                  provider.setDataToTheSelecteeForm(provider.selectedForm!.copyWith(customerFeedback: updatedList));
                                                },
                                                onEditingChange: (isEditing) {
                                                  final updatedList = customerFeedback.map((element) {
                                                    if (element == e) {
                                                      return element.copyWith(isEditing: isEditing);
                                                    }
                                                    return element;
                                                  }).toList();
                                                  provider.setDataToTheSelecteeForm(provider.selectedForm!.copyWith(customerFeedback: updatedList));
                                                },
                                              );
                                            }).toList() ??
                                            []),
                                        if (isAddingField) ...[ContactListTile(isEditing: isAddingField)],
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "When to Collect Customer Contact info",
                                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: ColorClass.black),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(height: 10),
                                Selector<FeedbackProvider, int?>(
                                  selector: (_, provider) => provider.selectedForm?.customerFeedback?.any((e) => e.customerInfo == 1) == true ? 1 : 0,
                                  builder: (context, contactPlace, child) {
                                    return Row(
                                      children: [
                                        Flexible(
                                          child: FeedbackTimeRadioOption(
                                            title: "Before the Feedback",
                                            value: 0,
                                            groupValue: contactPlace ?? 0,
                                            onChanged: (val) {
                                              if (val != null) {
                                                provider.setDataToTheSelecteeForm(
                                                  provider.selectedForm!.copyWith(
                                                    customerFeedback: provider.selectedForm?.customerFeedback
                                                        ?.map((e) => e.copyWith(customerInfo: val))
                                                        .toList(),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Flexible(
                                          child: FeedbackTimeRadioOption(
                                            title: "After the Feedback",
                                            value: 1,
                                            groupValue: contactPlace ?? 0,
                                            onChanged: (val) {
                                              if (val != null) {
                                                provider.setDataToTheSelecteeForm(
                                                  provider.selectedForm!.copyWith(
                                                    customerFeedback: provider.selectedForm?.customerFeedback
                                                        ?.map((e) => e.copyWith(customerInfo: val))
                                                        .toList(),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
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
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Preview",
                      style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600, color: ColorClass.black),
                    ),
                  ),
                  Container(height: 2, width: double.infinity, color: ColorClass.divider),
                  Expanded(
                    child: Selector<FeedbackProvider, (int?, List<CustomerFeedback>?, List<ResponseFeedback>?)>(
                      selector: (_, provider) => (
                        provider.selectedForm?.customerFeedback?.any((e) => e.customerInfoStatus == 1) == true ? 1 : 0,
                        provider.selectedForm?.customerFeedback,
                        provider.selectedForm?.responseFeedback,
                      ),
                      builder: (context, data, child) {
                        final isContactDetailsEnable = data.$1;
                        final customerFeedback = data.$2;
                        final responseFeedback = data.$3;

                        return isContactDetailsEnable == 0
                            ? const Center(child: Text("Contact Details is disable"))
                            : SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    spacing: 16,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      ...(customerFeedback?.map((e) {
                                            if (e.status != 1) return const SizedBox.shrink();
                                            return TextFieldColumn(
                                              hintText: e.fieldName,
                                              successMessageController: TextEditingController(),
                                              isEnter: provider.getContactFieldIndex(e.fieldName ?? "") < 3,
                                              onChanged: (value) {},
                                              label: "${e.fieldName ?? ""}${e.isMandatory == 0 ? " (optional)" : "*"}",
                                              isLable: true,
                                              isPhone:
                                                  e.fieldName?.toLowerCase().contains("phone") == true ||
                                                  e.fieldName?.toLowerCase().contains("mobile") == true,
                                            );
                                          }).toList() ??
                                          []),
                                      FeedbackScreenActionButton(
                                        width: double.infinity,
                                        isSelected: true,
                                        onTap: () {},
                                        text: (responseFeedback != null && responseFeedback.isNotEmpty) ? responseFeedback[0].button ?? "" : "",
                                      ),
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
