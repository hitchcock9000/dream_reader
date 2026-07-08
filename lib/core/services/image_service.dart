import 'dart:convert';

import 'package:dream_reader/core/config/app_environment.dart';
import 'package:dream_reader/core/logging/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_service.g.dart';

@Riverpod(keepAlive: true)
ImageService imageService(Ref ref) {
  return ImageService();
}

class ImageService {
  ImageService({
    http.Client? client,
    int Function()? seedBuilder,
  })  : _client = client ?? http.Client(),
        _seedBuilder = seedBuilder ?? (() => DateTime.now().millisecondsSinceEpoch);

  static const _url = 'https://api.openai.com/v1/images/generations';

  final http.Client _client;
  final int Function() _seedBuilder;

  String get _apiKey => AppEnvironment.openAiApiKey;

  Future<(String? url, String? error)> generateDreamImage(
    String visualPrompt,
  ) async {
    if (_apiKey.isEmpty) {
      AppLogger.info(
        'OPENAI_API_KEY missing; using fallback image generation provider.',
        scope: 'image',
      );
      return _generatePollinationsImage(visualPrompt);
    }

    try {
      final response = await _client.post(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + _apiKey,
        },
        body: jsonEncode({
          'model': 'dall-e-3',
          'prompt': visualPrompt,
          'n': 1,
          'size': '1024x1024',
          'quality': 'standard',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return ((data['data'] as List).first['url'] as String, null);
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final errorCode = data['error']?['code'];

      if (errorCode == 'billing_hard_limit_reached' ||
          errorCode == 'insufficient_quota') {
        AppLogger.warning(
          'OpenAI quota exceeded; using fallback image provider.',
          scope: 'image',
          error: errorCode,
        );
        return _generatePollinationsImage(visualPrompt);
      }

      final errorMessage =
          (data['error']?['message'] ?? 'Unknown image generation error') as String;
      return (null, errorMessage);
    } catch (error, stackTrace) {
      AppLogger.warning(
        'Primary image generation failed; using fallback provider.',
        scope: 'image',
        error: error,
        context: {'stackTraceCaptured': stackTrace.toString().isNotEmpty},
      );
      return _generatePollinationsImage(visualPrompt);
    }
  }

  Future<(String? url, String? error)> _generatePollinationsImage(
    String prompt,
  ) async {
    try {
      final seed = _seedBuilder();
      final encodedPrompt = Uri.encodeComponent(prompt);
      final url =
          'https://image.pollinations.ai/prompt/$encodedPrompt?seed=$seed&width=1024&height=1024&nologo=true&model=flux';
      return (url, null);
    } catch (error) {
      return (null, 'Fallback image generation failed: $error');
    }
  }
}
