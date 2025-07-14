import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GeminiController extends GetxController {
    final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  var prompt = ''.obs;
  var systemPrompt = ''.obs;
  var response = ''.obs;
  var isLoading = false.obs;

  Future<void> askGemini() async {
    if (prompt.value.trim().isEmpty || systemPrompt.value.trim().isEmpty) return;

    isLoading.value = true;
    response.value = '';

    try {
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent?key=$_apiKey',
      );

      final body = jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": systemPrompt.value},
              {"text": prompt.value}
            ]
          }
        ]
      });

      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final text = data["candidates"][0]["content"]["parts"][0]["text"];
        response.value = text.trim();
      } else {
        response.value = "Gemini Error: ${res.statusCode}\n${res.body}";
      }
    } catch (e) {
      response.value = "Error: $e";
    }

    isLoading.value = false;
  }
}
