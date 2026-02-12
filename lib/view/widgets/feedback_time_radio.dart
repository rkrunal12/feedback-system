import 'package:feedback_system/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';

class FeedbackTimeRadioOption extends StatelessWidget {
  final String title;
  final int value;
  final int groupValue;
  final ValueChanged<int?> onChanged;
  final String? tarilingSvg;

  const FeedbackTimeRadioOption({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.tarilingSvg,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(value);
      },
      child: Container(
        constraints: const BoxConstraints(minWidth: 150),
        decoration: BoxDecoration(
          color: ColorClass.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ColorClass.divider, width: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
          child: RadioGroup<int>(
            groupValue: groupValue,
            onChanged: onChanged,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 20,
              children: [
                Radio<int>(value: value, activeColor: ColorClass.primaryColor),
                Text(
                  title,
                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF3F3F3F)),
                ),
                if (tarilingSvg != null) ...[
                  SvgPicture.asset("assets/svg/$tarilingSvg.svg"),
                ] else if (value == 11) ...[
                  Icon(Icons.image, color: ColorClass.primaryColor, size: 20),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
