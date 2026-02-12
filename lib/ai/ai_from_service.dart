import 'dart:convert';
import 'dart:developer' as dev;

import 'package:http/http.dart' as http;

import '../model/feedback_form_model.dart';

class AiFormService {
  final String apiKey = "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";
  final String apiUrl = "https://api.groq.com/openai/v1/chat/completions";

  Future<List<FeedbackType>> generateAiForm(String topic) async {
    final String systemPrompt =
        """
      You are a smart JSON Form Generator API.
      Your task is to generate a structured feedback form for the topic: "$topic".
      Generate 10 high quality questions covering different aspects of the topic.
      
      CRITICAL INSTRUCTION:
      - Randomize the 'ratingType' selection for every request. 
      - Do NOT use a fixed sequence (like 4, 1, 7, 10...). 
      - Ensure a diverse mix of rating types (Stars, Emojis, Sliders, Text, etc.) is used in each form.
      - Select the strongly relevant rating type for the question, but avoid repetition where possible.
      - ALSO: Generate DIFFERENT questions every time. Even if the topic is exactly the same, do NOT output the same set of questions.
      - Vary the phrasing, focus, and specific aspects of the topic being asked about. Be creative!
      - Avoid generic default questions if possible; tailor them uniquely to this specific request.

      Output Format:
      Respond ONLY with a valid JSON object containing a list named 'questions'.
      Do not include markdown formatting (no ```json), backticks, or conversational text.
      
      Field Definitions per Question:
      - rating_name (String): Unique identifier (e.g., 'Service Quality').
      - rating_title (String): The question text (e.g., 'How was the service?').
      - rating_type (int): The input type ID (see mapping below).
      - status (int): Always 1.
      - feedbackoption (List<Object>): Required for choice (6) and checkbox (7).
        - Each object should have: option_name (String), status (int), position (int).

      Rating Type Mapping:
      1: Star Rating
      2: Emoji Rating
      3: Like/Dislike
      4: 1 to 5 Scale
      5: Text Input
      6: Multiple Choice
      7: Checkbox
      8: Slider
      9: Ranking
      10: NPS (Net Promoter Score) - Title is the entity name (e.g., 'our restaurant', 'this hotel', 'our services'). VARY this phrase each time (e.g., use 'our brand', 'this experience', etc.) instead of always using 'our [topic]'. The UI automatically adds 'How likely are you to recommend...'.
    """;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $apiKey', 'Content-Type': 'application/json'},
        body: jsonEncode({
          "model": "llama-3.3-70b-versatile",
          "messages": [
            {"role": "system", "content": systemPrompt},
            {"role": "user", "content": "Generate for topic: $topic"},
          ],
          "response_format": {"type": "json_object"},
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final String content = decoded['choices'][0]['message']['content'];

        dev.log("FORM JSON: $content");

        final List<dynamic> questionsList = jsonDecode(content)['questions'];
        return questionsList.map((q) => FeedbackType.fromJson(q)).toList();
      } else {
        throw Exception("Failed to connect: ${response.statusCode}");
      }
    } catch (e) {
      dev.log("ERROR: $e");
      rethrow;
    }
  }
}
