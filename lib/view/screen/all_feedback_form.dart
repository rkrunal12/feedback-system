import 'package:feedback_system/controller/feedback_provider.dart';
import 'package:feedback_system/view/widgets/feedback_screen_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';

import '../../color.dart';
import '../../app_pref.dart';
import '../../model/feedback_form_model.dart';
import '../widgets/custom_toast.dart';
import '../widgets/delete_dialoge.dart';
import 'feedback_form_screen.dart';

class AllFeedBackForm extends StatefulWidget {
  const AllFeedBackForm({super.key});

  @override
  State<AllFeedBackForm> createState() => _AllFeedBackFormState();
}

class _AllFeedBackFormState extends State<AllFeedBackForm> {
  final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<FeedbackProvider>(context, listen: false);
      await provider.getFeedbackForms(isFirstTime: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double availableWidth = MediaQuery.sizeOf(context).width - 32;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Feedback Create Form',
                style: GoogleFonts.poppins(fontSize: 20, color: ColorClass.black, fontWeight: FontWeight.w600, height: 1.0, letterSpacing: 0),
              ),
              FeedbackScreenActionButton(
                onTap: () {
                  final FeedbackProvider provider = context.read<FeedbackProvider>();
                  provider.setDataToTheSelecteeForm(
                    FeedbackFormModel(
                      imageReview: 0,
                      reviewStatus: 1,
                      videoReview: 0,
                      shopId: AppPref().getShopId(),
                      formTitle: "We’d Love your feedback!",
                      formSubtitle: "Please rate your experience with us.",
                      feedbackType: [
                        FeedbackType(ratingName: "Service Quality", ratingTitle: "How was the service?", ratingType: 1, status: 1),
                        FeedbackType(ratingName: "Food Quality", ratingTitle: "How was the food?", ratingType: 1, status: 1),
                      ],
                      reviewTitle: "Write a Review",
                      reviewPlaceholder: "Share your thoughts or suggestions",
                      button: "Submit Feedback",
                      customerFeedback: [
                        CustomerFeedback(fieldName: "Name", status: 1, isMandatory: 0, customerInfo: 1, customerInfoStatus: 1),
                        CustomerFeedback(fieldName: "Phone number", status: 1, isMandatory: 0, customerInfo: 1, customerInfoStatus: 1),
                        CustomerFeedback(fieldName: "Email", status: 1, isMandatory: 1, customerInfo: 1, customerInfoStatus: 1),
                      ],
                      responseFeedback: [
                        ResponseFeedback(
                          message: "Thanks for your feedback! Please share your name, number, or email so we can reach you or send special offers.",
                          button: "Done",
                        ),
                      ],
                    ),
                  );
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FeedbackFromScreen()));
                },
                text: '+ Add Feedback Form',
                isSelected: true,
                textSize: 18,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Selector<FeedbackProvider, (List<FeedbackFormModel>, bool)>(
              selector: (context, provider) => (provider.feedbackForms, provider.isFromLoading),
              builder: (context, data, child) {
                final feedbackForms = data.$1;
                final isFromLoading = data.$2;
                final provider = context.read<FeedbackProvider>();
                return Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ColorClass.white,
                    // border: Border.all(color: ColorClass.divider),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: isFromLoading
                      ? const Center(child: CircularProgressIndicator())
                      : feedbackForms.isEmpty
                      ? Center(
                          child: Text(
                            "No Data Found",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: ColorClass.black,
                              fontWeight: FontWeight.w600,
                              height: 1.0,
                              letterSpacing: 0,
                            ),
                          ),
                        )
                      : Scrollbar(
                          controller: _horizontalController,
                          thumbVisibility: availableWidth < 1100,
                          trackVisibility: availableWidth < 1100,
                          thickness: 8,
                          radius: const Radius.circular(10),
                          child: SingleChildScrollView(
                            controller: _horizontalController,
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: availableWidth < 1100 ? 1100 : availableWidth,
                              child: SingleChildScrollView(
                                child: Table(
                                  border: TableBorder.symmetric(
                                    borderRadius: BorderRadius.circular(10),
                                    inside: BorderSide(color: ColorClass.divider, width: 0.5),
                                    outside: BorderSide(color: ColorClass.black.withValues(alpha: 0.5), width: 1),
                                  ),
                                  columnWidths: const {
                                    0: FlexColumnWidth(2),
                                    1: FlexColumnWidth(4),
                                    2: FlexColumnWidth(1),
                                    3: FlexColumnWidth(1),
                                    4: FlexColumnWidth(1.5),
                                  },
                                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                  children: [
                                    TableRow(
                                      decoration: BoxDecoration(
                                        color: ColorClass.primaryColor.withValues(alpha: 0.3),
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                                      ),
                                      children: [
                                        _headerCell("Form Name"),
                                        _headerCell("Feedback page Link"),
                                        _headerCell("Share link"),
                                        _headerCell("Download QR"),
                                        _headerCell("Action"),
                                      ],
                                    ),
                                    ...feedbackForms.map((form) {
                                      return _fromRow(form, provider);
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  TableRow _fromRow(FeedbackFormModel form, FeedbackProvider provider) {
    return TableRow(
      decoration: const BoxDecoration(
        color: ColorClass.white,
        border: Border(bottom: BorderSide(color: ColorClass.divider, width: 0.5)),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Text(
            form.formName ?? "",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: SelectableText(form.feedbackPageLink ?? "www.google.com", style: GoogleFonts.poppins(color: ColorClass.primaryColor)),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 30,
                child: OutlinedButton(
                  onPressed: () async {
                    Clipboard.setData(ClipboardData(text: form.feedbackPageLink ?? "www.google.com"));
                    CustomeToast.showSuccess("Link copy sucessfully");
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    side: BorderSide(color: ColorClass.black, width: 0.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  child: Text("Copy", style: GoogleFonts.poppins(color: ColorClass.black, fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Center(
            child: SizedBox(
              height: 30,
              width: 120,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await provider.generateAndShareQR(form.feedbackPageLink ?? "www.google.com");
                },
                icon: const Icon(Icons.share, size: 18, color: Colors.white),
                label: Text("Share", style: GoogleFonts.poppins(color: Colors.white, fontSize: 14)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorClass.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Center(
            child: SizedBox(
              height: 30,
              width: 120,
              child: ElevatedButton(
                onPressed: () async {
                  final data = await provider.generateAndDownloadQR(form.feedbackPageLink ?? "www.google.com", form.formName ?? "form");
                  if (data.startsWith("error")) {
                    CustomeToast.showError("Error for download QR");
                  } else {
                    CustomeToast.showSuccess("QR downloaded at $data");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorClass.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                ),
                child: Text("Download", style: GoogleFonts.poppins(color: Colors.white, fontSize: 14)),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Selector<FeedbackProvider, (String?, int)>(
                selector: (context, prov) =>
                    (prov.togglingFormId, prov.feedbackForms.firstWhere((f) => f.formId == form.formId, orElse: () => form).status ?? 0),
                builder: (context, data, child) {
                  final togglingId = data.$1;
                  final status = data.$2;
                  return togglingId == form.formId
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : SizedBox(
                          height: 24,
                          child: Switch(
                            value: status == 1,
                            onChanged: provider.isUpdating
                                ? null
                                : (val) async {
                                    await provider.toggleFormStatus(form.formId!, val ? 1 : 0, form.shopId ?? AppPref().getShopId());
                                  },
                            activeTrackColor: ColorClass.primaryColor,
                            thumbColor: const WidgetStatePropertyAll(Colors.white),
                          ),
                        );
                },
              ),
              const SizedBox(width: 16),
              Selector<FeedbackProvider, (bool, String?)>(
                selector: (context, prov) => (prov.isUpdating, prov.loadingFormId),
                builder: (context, data, child) {
                  final isUpdating = data.$1;
                  final loadingId = data.$2;
                  return GestureDetector(
                    onTap: () async {
                      bool success = await provider.setSelectedForm(form.formId);
                      if (success && context.mounted) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackFromScreen(id: form.formId)));
                      }
                    },
                    child: isUpdating && loadingId == form.formId
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : SvgPicture.asset("assets/svg/edit.svg"),
                  );
                },
              ),
              const SizedBox(width: 16),
              Selector<FeedbackProvider, String?>(
                selector: (context, prov) => prov.deletingFormId,
                builder: (context, deletingId, child) {
                  return deletingId == form.formId
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return DeleteDialog(
                                  deleteName: "Form",
                                  onDelete: () async {
                                    await provider.deleteFeedbackForm(int.tryParse(form.formId ?? "0") ?? -1, form.shopId ?? AppPref().getShopId());
                                  },
                                  deleteMessage: "Are you sure you want to delete this form?",
                                );
                              },
                            );
                          },
                          child: SvgPicture.asset("assets/svg/delete.svg"),
                        );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _headerCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        textAlign: TextAlign.center,
      ),
    );
  }
}
