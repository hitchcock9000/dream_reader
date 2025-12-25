import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_generation_service.g.dart';

// TODO: Ensure you pass --dart-define=OPENAI_API_KEY=your_key when running/building
const _openAIKey = String.fromEnvironment('OPENAI_API_KEY');

@Riverpod(keepAlive: true)
ImageGenerationService imageGenerationService(Ref ref) {
  return ImageGenerationService();
}

class ImageGenerationService {
  static const _url = 'https://api.openai.com/v1/images/generations';

  Future<String?> generateImage(String prompt) async {
    if (_openAIKey.isEmpty) {
      debugPrint('ImageGenerationService: No API Key found.');
      return null;
    }

    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_openAIKey',
        },
        body: jsonEncode({
          'model': 'dall-e-3',
          'prompt': "Abstract, mystical, dreamlike, cosmic style. $prompt",
          'n': 1,
          'size': '1024x1024',
          'quality': 'standard',
          'response_format': 'url',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final url = data['data'][0]['url'] as String;
        return url;
      } else {
        debugPrint('Image Generation Failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Image Generation Error: $e');
      return null;
    }
  }
}
