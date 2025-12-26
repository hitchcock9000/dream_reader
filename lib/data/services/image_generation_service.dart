import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'image_generation_service.g.dart';

// Retrieve API Key from .env
final _openAIKey = dotenv.get('OPENAI_API_KEY', fallback: '');

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
