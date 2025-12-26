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
  Future<DreamResponse> analyzeDream(String text, {String languageCode = 'en'}) async {
    final prompt = [
      Content.text('''
You are a mystical and psychological dream analyst.
The user is providing their dream in the following language: $languageCode.
Your task is to provide a deep, insightful analysis strictly in $languageCode.

Return a JSON object with exactly these keys:
- interpretation: A 2-3 sentence mystical interpretation.
- psychologicalInsight: A 1-2 sentence psychological perspective.
- mysticalSymbol: A single powerful symbol found in the dream.
- imageGenerationPrompt: A descriptive English prompt for DALL-E to generate a surreal, cinematic, and mystical image of the dream. (This key MUST always be in English).

JSON format:
{
  "interpretation": "...",
  "psychologicalInsight": "...",
  "mysticalSymbol": "...",
  "imageGenerationPrompt": "..."
}
'''),
      Content.text(text),
    ];

    try {
      final response = await _model.generateContent(prompt);
      
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
