import 'dart:convert';

import 'package:dream_reader/core/config/app_environment.dart';
import 'package:dream_reader/core/errors/app_error.dart';
import 'package:dream_reader/core/logging/logger.dart';
import 'package:dream_reader/domain/entities/dream_response.dart';
import 'package:dream_reader/domain/repositories/dream_analysis_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dream_analysis_repository_impl.g.dart';

@Riverpod(keepAlive: true)
DreamAnalysisRepository dreamAnalysisRepository(Ref ref) {
  return DreamAnalysisRepositoryImpl();
}

abstract class DreamContentGenerator {
  Future<String?> generate(List<Content> prompt);
}

class GeminiDreamContentGenerator implements DreamContentGenerator {
  GeminiDreamContentGenerator({required String apiKey})
      : _model = GenerativeModel(
          model: 'gemini-2.5-flash',
          apiKey: apiKey,
          generationConfig: GenerationConfig(
            responseMimeType: 'application/json',
          ),
        );

  final GenerativeModel _model;

  @override
  Future<String?> generate(List<Content> prompt) async {
    final response = await _model.generateContent(prompt);
    return response.text;
  }
}

class DreamAnalysisRepositoryImpl implements DreamAnalysisRepository {
  DreamAnalysisRepositoryImpl({DreamContentGenerator? generator})
      : _generator = generator ??
            GeminiDreamContentGenerator(apiKey: AppEnvironment.geminiApiKey),
        _requiresApiKey = generator == null;

  final DreamContentGenerator _generator;
  final bool _requiresApiKey;

  @override
  Future<DreamResponse> analyzeDream(String text) async {
    final normalizedText = text.trim();
    if (normalizedText.isEmpty) {
      throw AppError.validation('Dream text cannot be empty.');
    }

    if (_requiresApiKey && !AppEnvironment.hasGeminiKey) {
      throw AppError.configuration(
        'Missing GEMINI_API_KEY. Add it in .env or pass it with --dart-define.',
      );
    }

    final prompt = [
      Content.text('''
You are a mystical and psychological dream analyst.

CRITICAL INSTRUCTIONS:
1. Analyze the user's dream text below.
2. AUTOMATICALLY DETECT the language of the input.
3. Provide your ENTIRE analysis in the SAME language as the input.
4. The detected_language field should be a two-letter ISO language code (e.g., "en", "tr", "es", "fr").
5. The archetypal_theme field MUST ALWAYS be in English (for image generation).

Return a JSON object with exactly these keys:
- interpretation: A 2-3 sentence mystical and poetic interpretation of the dream (in detected language).
- psychological_insight: A 1-2 sentence psychological perspective from a Jungian or modern viewpoint (in detected language).
- dream_guidance: A single powerful, actionable sentence to guide the user in their waking life based on the dream (in detected language).
- archetypal_theme: A descriptive English title and visual prompt (merged) for image generation.
- detected_language: Two-letter ISO language code of the input text (e.g., "en", "tr", "es").

JSON format:
{
  "interpretation": "...",
  "psychological_insight": "...",
  "dream_guidance": "...",
  "archetypal_theme": "...",
  "detected_language": "..."
}
'''),
      Content.text(normalizedText),
    ];

    try {
      final responseText = await _generator.generate(prompt);
      if (responseText == null || responseText.trim().isEmpty) {
        throw AppError.aiResponse('Dream analysis returned an empty response.');
      }

      final cleanedResponse = normalizeModelResponse(responseText);
      final jsonMap = jsonDecode(cleanedResponse) as Map<String, dynamic>;
      return DreamResponse.fromJson(jsonMap);
    } catch (error, stackTrace) {
      if (error is AppError) {
        AppLogger.warning(
          'Dream analysis returned an application error.',
          scope: 'dream-repository',
          error: error.cause ?? error,
        );
        rethrow;
      }

      AppLogger.error(
        'Dream analysis parsing failed.',
        scope: 'dream-repository',
        error: error,
        stackTrace: stackTrace,
      );
      throw AppError.aiResponse(
        'Dream analysis failed because the model response could not be parsed.',
        cause: error,
      );
    }
  }

  @visibleForTesting
  static String normalizeModelResponse(String responseText) {
    if (!responseText.contains('```')) {
      return responseText.trim();
    }

    return responseText.replaceAll(RegExp(r'```json|```'), '').trim();
  }
}
