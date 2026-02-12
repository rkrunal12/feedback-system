import 'package:feedback_system/view/widgets/feedback_screen_action_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

import '../../color.dart';
import '../../controller/feedback_provider.dart';
import '../../model/feedback_form_model.dart';
import '../widgets/text_filed_colum.dart';

class CustomizedSuccessScreen extends StatefulWidget {
  const CustomizedSuccessScreen({super.key});

  @override
  State<CustomizedSuccessScreen> createState() => _CustomizedSuccessScreenState();
}

class _CustomizedSuccessScreenState extends State<CustomizedSuccessScreen> {
  final TextEditingController successMessageController = TextEditingController();
  final TextEditingController buttonMessageController = TextEditingController();

  @override
  void dispose() {
    successMessageController.dispose();
    buttonMessageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final provider = Provider.of<FeedbackProvider>(context, listen: false);
    successMessageController.text = provider.selectedForm?.responseFeedback != null && provider.selectedForm!.responseFeedback!.isNotEmpty
        ? provider.selectedForm?.responseFeedback![0].message ?? ""
        : "";
    buttonMessageController.text = provider.selectedForm?.responseFeedback != null && provider.selectedForm!.responseFeedback!.isNotEmpty
        ? provider.selectedForm?.responseFeedback![0].button ?? ""
        : "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FeedbackProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.minPositive,
              decoration: BoxDecoration(
                color: ColorClass.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: ColorClass.divider, width: 0.5),
              ),
              child: Padding(
                padding: EdgeInsetsGeometry.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFieldColumn(
                      isLable: true,
                      label: "Success Message",
                      successMessageController: successMessageController,
                      onChanged: (value) {
                        if (provider.selectedForm != null) {
                          final List<ResponseFeedback> response = List.from(provider.selectedForm?.responseFeedback ?? []);
                          if (response.isEmpty) {
                            response.add(ResponseFeedback(message: value, button: "Done"));
                          } else {
                            response[0] = response[0].copyWith(message: value);
                          }
                          provider.setDataToTheSelecteeForm(provider.selectedForm!.copyWith(responseFeedback: response));
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Button",
                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: ColorClass.black),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: ColorClass.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ColorClass.divider, width: 0.5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFieldColumn(
                          isLable: true,
                          label: "Title",
                          successMessageController: buttonMessageController,
                          onChanged: (value) {
                            if (provider.selectedForm != null) {
                              final List<ResponseFeedback> response = List.from(provider.selectedForm?.responseFeedback ?? []);
                              if (response.isEmpty) {
                                response.add(ResponseFeedback(message: "Success", button: value));
                              } else {
                                response[0] = response[0].copyWith(button: value);
                              }
                              provider.setDataToTheSelecteeForm(provider.selectedForm!.copyWith(responseFeedback: response));
                            }
                          },
                        ),
                      ),
                    ),
                  ],
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
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Preview",
                      style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600, color: ColorClass.black),
                    ),
                  ),
                  Container(height: 2, color: ColorClass.divider),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/svg/success.svg"),
                              const SizedBox(height: 20),
                              Consumer<FeedbackProvider>(
                                builder: (context, provider, child) {
                                  return Column(
                                    children: [
                                      Text(
                                        (provider.selectedForm?.responseFeedback != null && provider.selectedForm!.responseFeedback!.isNotEmpty)
                                            ? provider.selectedForm?.responseFeedback![0].message ?? "Success"
                                            : "Success",
                                        style: GoogleFonts.poppins(fontSize: 16, color: ColorClass.black, fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 20),
                                      Visibility(
                                        visible:
                                            provider.selectedForm?.customerFeedback?.any((e) => e.customerInfo == 1 && e.customerInfoStatus == 1) ??
                                            false,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            spacing: 16,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              ...(provider.selectedForm?.customerFeedback?.map((e) {
                                                    return e.status == 1
                                                        ? TextFieldColumn(
                                                            successMessageController: TextEditingController(),
                                                            onChanged: (value) {},
                                                            label: "${e.fieldName ?? ""}${e.isMandatory == 0 ? " (optional)" : "*"}",
                                                            isLable: true,
                                                            isPhone:
                                                                e.fieldName?.toLowerCase().contains("phone") == true ||
                                                                e.fieldName?.toLowerCase().contains("mobile") == true,
                                                            hintText: e.fieldName,
                                                            isEnter: provider.getContactFieldIndex(e.fieldName ?? "") < 3,
                                                          )
                                                        : const SizedBox.shrink();
                                                  }).toList() ??
                                                  []),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Consumer<FeedbackProvider>(
                                        builder: (context, val, _) {
                                          return Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: FeedbackScreenActionButton(
                                              width: double.infinity,
                                              onTap: () {},
                                              text: (val.selectedForm?.responseFeedback != null && val.selectedForm!.responseFeedback!.isNotEmpty)
                                                  ? val.selectedForm?.responseFeedback![0].button ?? ""
                                                  : "",
                                              isSelected: true,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
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
