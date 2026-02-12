import 'dart:convert';
import 'dart:developer' as dev;

import 'package:http/http.dart' as http;

import '../model/feedback_form_model.dart';

class AiFormService {
  final String apiKey = "AABBCC";
  final String apiUrl = "https://api.groq.com/openai/v1/chat/completions";

  Future<List<FeedbackType>> generateAiForm(String topic) async {
    final String systemPrompt =
        """
      You are a JSON Form Generator. topic $topic. 
      Respond ONLY with a valid JSON object containing a list named 'questions'.
      Mapping: 1:rating, 2:emoji, 3:like/dislike, 4:1to5, 5:text, 6:choice, 7:checkbox, 8:slider, 9:ranking, 10:NPS.
      Return type as INT. Use fields: rating_name(related to the question), rating_title(actual question), rating_type, status, feedbackoption (list of objects with option_name, status, position).
      No conversational text or markdown backticks.
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
