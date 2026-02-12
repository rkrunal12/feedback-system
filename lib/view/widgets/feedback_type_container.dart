import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:svg_flutter/svg.dart';

import '../../color.dart';

class FeedbackTypeContainer extends StatelessWidget {
  const FeedbackTypeContainer({super.key, required this.title, required this.svg, required this.text, this.textColor});

  final String svg;
  final String text;
  final String title;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        color: ColorClass.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: ColorClass.divider, width: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(svg),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: GoogleFonts.poppins(fontSize: 16, fontStyle: FontStyle.normal, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    text,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      color: textColor ?? ColorClass.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
