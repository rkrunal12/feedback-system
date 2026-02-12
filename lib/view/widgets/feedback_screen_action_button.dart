import 'package:feedback_system/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackScreenActionButton extends StatelessWidget {
  final bool? isSelected;
  final VoidCallback? onTap;
  final String text;
  final Color? backgournd;
  final double? textSize;
  final double? width;
  final double? height;
  final Color? color;

  const FeedbackScreenActionButton({
    super.key,
    this.isSelected,
    required this.onTap,
    required this.text,
    this.backgournd,
    this.textSize,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 50,
        width: width ?? 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color ?? ColorClass.divider, width: 0.5),
          color: isSelected == true ? ColorClass.primaryColor : backgournd ?? ColorClass.grey,
        ),
        child: Center(
          child: FittedBox(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: textSize ?? 17,
                fontWeight: textSize != null ? FontWeight.w500 : FontWeight.w600,
                color: color ?? (isSelected == true ? ColorClass.white : ColorClass.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
