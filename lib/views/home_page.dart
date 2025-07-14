import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/gemini_controller.dart';

class HomePage extends StatelessWidget {
  final GeminiController geminiController = Get.put(GeminiController());
  final TextEditingController textController = TextEditingController();

  final List<Map<String, String>> categories = [
    {
      "title": "Doctor",
      "prompt": "You are a professional doctor. Give health-related answers."
    },
    {
      "title": "Teacher",
      "prompt": "You are a friendly teacher. Explain topics clearly."
    },
    {
      "title": "Ecommerce Assistant",
      "prompt": "You are an ecommerce assistant helping users with product questions and orders."
    },
  ];

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gemini AI Category Assistant')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: "Select Assistant Type"),
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category['prompt'],
                  child: Text(category['title']!),
                );
              }).toList(),
              onChanged: (value) {
                geminiController.systemPrompt.value = value!;
              },
            ),
            SizedBox(height: 12),
            TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: 'Ask something...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => geminiController.prompt.value = value,
            ),
            SizedBox(height: 12),
            Obx(() => ElevatedButton(
              onPressed: geminiController.isLoading.value ? null : geminiController.askGemini,
              child: Text(geminiController.isLoading.value ? 'Loading...' : 'Ask Gemini'),
            )),
            SizedBox(height: 24),
            Obx(() => Expanded(
              child: SingleChildScrollView(
                child: Text(geminiController.response.value),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
