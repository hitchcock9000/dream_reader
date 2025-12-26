import 'package:flutter/foundation.dart';
import 'package:dream_reader/application/dream_state.dart';
import 'package:dream_reader/data/repositories/dream_analysis_repository_impl.dart';
import 'package:dream_reader/core/services/image_service.dart';
import 'package:dream_reader/data/services/share_service.dart';
import 'package:dream_reader/data/services/voice_service.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dream_controller.g.dart';

@Riverpod(keepAlive: true)
class DreamController extends _$DreamController {
  late final FlutterTts _flutterTts;
  
  @override
  DreamState build() {
    _flutterTts = FlutterTts();
    _initTts();
    return const DreamState();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("tr-TR");
    await _flutterTts.setPitch(0.9);
    await _flutterTts.setSpeechRate(0.4); // Deep, mystical voice
  }

  void startVoiceInput(String localeId) async {
    state = state.copyWith(isListening: true, error: null, transcription: '');
    
    final voiceService = ref.read(voiceServiceProvider);
    
    await voiceService.startListening(
      localeId: localeId,
      onResult: (text) {
        state = state.copyWith(transcription: text);
      },
      onError: (msg) {
        debugPrint('🎙️ Voice Error: $msg');
        state = state.copyWith(
          isListening: false,
          error: "Voice connection lost: $msg. Please try again.",
        );
      },
      onListeningStateChanged: (isListening) {
        state = state.copyWith(isListening: isListening);
        
        // Automatic Handshake Logic
        if (!isListening) {
          debugPrint('🎙️ Transcription Finished: ${state.transcription}');
          if (state.transcription.trim().isNotEmpty) {
            submitDream(state.transcription, languageCode: localeId.split('-').first);
          } else if (state.error == null) {
            // Only show "No speech detected" if there wasn't a harder error already
            state = state.copyWith(
              error: "I didn't catch that. Tap the mic and try again!",
            );
          }
        }
      },
    );
  }

  void stopVoiceInput() {
    ref.read(voiceServiceProvider).stopListening();
  }

  Future<void> submitDream(String text, {String languageCode = 'en'}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(dreamAnalysisRepositoryProvider);
      final analysis = await repository.analyzeDream(text, languageCode: languageCode);
      
      state = state.copyWith(
        isLoading: false, 
        analysis: analysis,
      );
      
      // Start Image Generation in parallel
      _generateDreamImage(analysis.imageGenerationPrompt);

      debugPrint('🔊 TTS Started');
      await speakResult(analysis.interpretation, languageCode: languageCode);

    } catch (e) {
      debugPrint('❌ Submission Error: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> _generateDreamImage(String prompt) async {
    debugPrint('🎨 Generating DALL-E 3 Image: $prompt');
    state = state.copyWith(
      isImageLoading: true,
      imageError: null,
      imageUrl: null,
    );
    
    try {
      final service = ref.read(imageServiceProvider);
      final (url, error) = await service.generateDreamImage(prompt);
      
      if (url != null) {
        debugPrint('🖼️ Image Received');
        state = state.copyWith(imageUrl: url, isImageLoading: false);
      } else {
        debugPrint('❌ Image Error: $error');
        state = state.copyWith(imageError: error, isImageLoading: false);
      }
    } catch (e) {
      debugPrint('❌ Image Gen Exception: $e');
      state = state.copyWith(imageError: e.toString(), isImageLoading: false);
    }
  }

  Future<void> speakResult(String text, {String? languageCode}) async {
    if (languageCode != null) {
      // Find a matching locale for TTS
      // Most languages work with just the language code, but we can be specific
      await _flutterTts.setLanguage(languageCode);
    }
    await _flutterTts.speak(text);
  }
  
  Future<void> shareResult(Uint8List imageBytes) async {
    final analysis = state.analysis;
    if (analysis == null) return;
    
    final shareText = "🌌 Dream Interpretation:\n${analysis.interpretation}\n\n#DreamReader #CosmicInsights";
    
    await ref.read(shareServiceProvider).shareDream(
      imageBytes: imageBytes, 
      text: shareText
    );
  }
}
