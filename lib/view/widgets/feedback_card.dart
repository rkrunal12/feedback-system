import 'package:feedback_system/color.dart';
import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';
import '../../model/feedback_model.dart';

class FeedbackCard extends StatelessWidget {
  final FeedbackModel fb;

  const FeedbackCard({super.key, required this.fb});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset("assets/svg/person.svg", width: 25, height: 25),
              const SizedBox(width: 10),
              Text(
                fb.userName ?? "Unknown User",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, fontStyle: FontStyle.normal, color: ColorClass.black),
              ),
              const SizedBox(width: 8),
              Text("• ${fb.createdDate ?? ""}", style: TextStyle(color: ColorClass.grey, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 20),

          if (fb.custoFeedbackType != null && fb.custoFeedbackType!.isNotEmpty)
            Wrap(
              spacing: 10,
              runSpacing: 6,
              children: fb.custoFeedbackType!.reversed.map((e) {
                Widget content;
                String val = e.value ?? "";
                int intVal = int.tryParse(val) ?? 0;
                double doubleVal = double.tryParse(val) ?? 0.0;

                switch (e.ratingType) {
                  case 1: // Star Rating
                    content = Row(children: List.generate(intVal, (_) => Icon(Icons.star, size: 24, color: ColorClass.gold)));
                    break;
                  case 2: // 
                    List<String> emojis = ['😔', '😞', '😐', '🙂', '😃'];
                    content = Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(emojis.length, (index) {
                        bool isSelected = (index + 1) == intVal;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Opacity(
                            opacity: isSelected ? 1.0 : 0.4,
                            child: Transform.scale(
                              scale: isSelected ? 1.2 : 1.0,
                              child: Text(emojis[index], style: TextStyle(fontSize: 24)),
                            ),
                          ),
                        );
                      }),
                    );
                    break;
                  case 3: // Like/Dislike
                    bool isLike = val == "1";
                    content = Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Opacity(
                          opacity: isLike ? 1.0 : 0.4,
                          child: Icon(Icons.thumb_up, color: Colors.green, size: 24),
                        ),
                        const SizedBox(width: 10),
                        Opacity(
                          opacity: !isLike ? 1.0 : 0.4,
                          child: Icon(Icons.thumb_down, color: Colors.red, size: 24),
                        ),
                      ],
                    );
                    break;
                  case 4: // 1 to 5 Scale
                    content = Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        bool selected = (index + 1) <= intVal;
                        return Container(
                          height: 30,
                          width: 30,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: selected ? ColorClass.primaryColor : Colors.transparent,
                            border: Border.all(color: ColorClass.primaryColor),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text("${index + 1}", style: TextStyle(color: selected ? Colors.white : ColorClass.primaryColor, fontSize: 12)),
                          ),
                        );
                      }),
                    );
                    break;
                  case 5: // Text Input
                    content = Text(val, style: const TextStyle(fontSize: 15));
                    break;
                  case 6: // Multiple Choice
                    content = Chip(
                      label: Text(val, style: const TextStyle(fontSize: 12)),
                      backgroundColor: Colors.grey.shade200,
                      visualDensity: VisualDensity.compact,
                    );
                    break;
                  case 7: // Checkbox (Multiple Selection)
                    List<String> options = val.split(',').map((e) => e.trim()).toList();
                    content = Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: options.map((opt) {
                        return Chip(
                          label: Text(opt, style: const TextStyle(fontSize: 12)),
                          backgroundColor: Colors.grey.shade200,
                          visualDensity: VisualDensity.compact,
                        );
                      }).toList(),
                    );
                    break;
                  case 8: // Slider
                    content = Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 100,
                          child: LinearProgressIndicator(
                            value: doubleVal / 100,
                            color: ColorClass.primaryColor,
                            backgroundColor: Colors.grey.shade300,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text("${doubleVal.round()}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    );
                    break;
                  case 9: // Ranking
                    List<String> rankedItems = val.split(',').map((e) => e.trim()).toList();
                    content = Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: List.generate(rankedItems.length, (index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: ColorClass.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: ColorClass.primaryColor),
                          ),
                          child: Text(
                            "#${index + 1} ${rankedItems[index]}",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: ColorClass.primaryColor),
                          ),
                        );
                      }),
                    );
                    break;
                  case 10: // NPS
                    Color npsColor = intVal >= 9 ? Colors.green : (intVal >= 7 ? Colors.orange : Colors.red);
                    String npsLabel = intVal >= 9 ? "Promoter" : (intVal >= 7 ? "Passive" : "Detractor");
                    content = Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: npsColor.withValues(alpha: 0.1),
                        border: Border.all(color: npsColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "$val/10",
                            style: TextStyle(color: npsColor, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Container(margin: const EdgeInsets.symmetric(horizontal: 8), height: 14, width: 1, color: npsColor),
                          Text(
                            npsLabel,
                            style: TextStyle(color: npsColor, fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ],
                      ),
                    );
                    break;
                  default:
                    content = Text(val, style: const TextStyle(fontSize: 15));
                }

                String label = e.typeName ?? e.ratingName ?? "Rating";
                if (e.ratingType == 10) {
                  // If it doesn't already start with "How", assume it's the entity name and wrap it.
                  if (!label.toLowerCase().trim().startsWith("how")) {
                    label = "How likely are you to recommend $label to a friend or family?";
                  }
                }

                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.all(10),
                  color: ColorClass.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            "$label:  ",
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, fontStyle: FontStyle.normal, color: ColorClass.black),
                          ),
                        ),
                        content,
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          const SizedBox(height: 10),
          if (fb.review != null && fb.review!.isNotEmpty)
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Feedback: ",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: ColorClass.black),
                  ),
                  TextSpan(
                    text: fb.review,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: ColorClass.black),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
