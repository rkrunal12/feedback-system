import 'package:feedback_system/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class TextFieldColumn extends StatelessWidget {
  const TextFieldColumn({
    super.key,
    required this.successMessageController,
    this.onChanged,
    this.label,
    this.isLable,
    this.color,
    this.minLines,
    this.isEdit = true,
    this.isEnter = true,
    this.hintText,
    this.isPhone = false,
    this.isoCode = 'IN',
    this.size,
  });

  final TextEditingController successMessageController;
  final Function(String)? onChanged;
  final String? label;
  final bool? isLable;
  final Color? color;
  final int? minLines;
  final bool isEdit;
  final bool isEnter;
  final String? hintText;
  final bool isPhone;
  final String isoCode;
  final double? size;

  @override
  Widget build(BuildContext context) {
    int? maxLines;
    if (minLines != null) maxLines = minLines! + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isLable == true)
          Text(
            label ?? "Success Message",
            style: GoogleFonts.poppins(fontSize: size ?? 15, fontWeight: FontWeight.w500, color: ColorClass.black),
          ),
        SizedBox(height: isLable == true ? 8 : 0),
        if (isPhone)
          InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {
              onChanged?.call(number.phoneNumber ?? "");
            },
            selectorConfig: const SelectorConfig(
              selectorType: PhoneInputSelectorType.DROPDOWN,
              useBottomSheetSafeArea: true,
              leadingPadding: 10,
              showFlags: true,
              setSelectorButtonAsPrefixIcon: true,
              trailingSpace: false,
            ),
            autoValidateMode: AutovalidateMode.disabled,
            textFieldController: successMessageController,
            formatInput: true,
            spaceBetweenSelectorAndTextField: 0,
            initialValue: PhoneNumber(isoCode: "IN"),
            ignoreBlank: true,
            inputDecoration: InputDecoration(
              hintText: isEnter ? "Enter $label" : hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: color ?? ColorClass.divider, width: 0.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: color ?? ColorClass.divider, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: color ?? ColorClass.divider, width: 0.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: color ?? ColorClass.divider, width: 0.5),
              ),
              counterText: "",
            ),
            keyboardType: TextInputType.number,
          )
        else
          TextField(
            enabled: isEdit,
            minLines: minLines,
            maxLines: maxLines,
            controller: successMessageController,
            decoration: InputDecoration(
              hintText: isEnter ? "Enter ${label?.toLowerCase() ?? ""}" : hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: color ?? ColorClass.divider, width: 0.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: color ?? ColorClass.divider, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: color ?? ColorClass.divider, width: 0.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: color ?? ColorClass.divider, width: 0.5),
              ),
            ),
            onChanged: onChanged,
          ),
      ],
    );
  }
}
