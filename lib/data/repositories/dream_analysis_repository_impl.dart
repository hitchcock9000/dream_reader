import 'dart:convert';
import 'package:dream_reader/domain/entities/dream_response.dart';
import 'package:dream_reader/domain/repositories/dream_analysis_repository.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'dream_analysis_repository_impl.g.dart';

// Retrieve API Key from .env
final _apiKey = dotenv.get('GEMINI_API_KEY', fallback: '');

@Riverpod(keepAlive: true)
DreamAnalysisRepository dreamAnalysisRepository(Ref ref) {
  return DreamAnalysisRepositoryImpl();
}

class DreamAnalysisRepositoryImpl implements DreamAnalysisRepository {
  late final GenerativeModel _model;

  DreamAnalysisRepositoryImpl() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
      ),
    );
  }

  @override
  Future<DreamResponse> analyzeDream(String dreamText) async {
    final systemPrompt = '''
      You are an expert dream interpreter with knowledge of psychology (Jungian and Freudian), mysticism, and symbolism.
      Analyze the user's dream and return a JSON object with the following fields:
      - interpretation: A detailed interpretation of the dream.
      - psychological_insight: Psychological themes and insights derived from the dream.
      - mystical_symbol: A key symbol from the dream and its mystical meaning.
      - image_generation_prompt: A vivid, valid prompt to generate an image representing the essence of the dream (optimized for an image generation AI).
      
      JSON keys must be: "interpretation", "psychological_insight", "mystical_symbol", "image_generation_prompt".
    ''';

    final content = [
      Content.multi([
        TextPart(systemPrompt),
        TextPart('Dream to analyze: "$dreamText"'),
      ])
    ];

    try {
      final response = await _model.generateContent(content);
      
      if (response.text == null) {
        throw Exception('Failed to generate analysis: Empty response.');
      }

      final jsonMap = jsonDecode(response.text!) as Map<String, dynamic>;
      return DreamResponse.fromJson(jsonMap);
    } catch (e) {
      throw Exception('Dream analysis failed: $e');
    }
  }
}
