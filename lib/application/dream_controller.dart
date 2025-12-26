import 'package:flutter/foundation.dart';
import 'package:dream_reader/application/dream_state.dart';
import 'package:dream_reader/data/repositories/dream_analysis_repository_impl.dart';
import 'package:dream_reader/data/services/image_generation_service.dart';
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

  void startVoiceInput() async {
    state = state.copyWith(isListening: true, error: null, transcription: '');
    
    final voiceService = ref.read(voiceServiceProvider);
    
    await voiceService.startListening(
      localeId: 'tr-TR',
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
            submitDream(state.transcription);
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

  Future<void> submitDream(String text) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(dreamAnalysisRepositoryProvider);
      final analysis = await repository.analyzeDream(text);
      
      state = state.copyWith(
        isLoading: false, 
        analysis: analysis,
      );
      
      // Start Image Generation in parallel
      generateImage(analysis.imageGenerationPrompt);

      debugPrint('🔊 TTS Started');
      await speakResult(analysis.interpretation);

    } catch (e) {
      debugPrint('❌ Submission Error: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> generateImage(String prompt) async {
    debugPrint('🎨 Generating Image: $prompt');
    state = state.copyWith(isGeneratingImage: true);
    
    try {
      final service = ref.read(imageGenerationServiceProvider);
      final url = await service.generateImage(prompt);
      
      if (url != null) {
        debugPrint('🖼️ Image Received');
        state = state.copyWith(imageUrl: url, isGeneratingImage: false);
      } else {
        state = state.copyWith(isGeneratingImage: false);
      }
    } catch (e) {
      debugPrint('❌ Image Gen Error: $e');
      state = state.copyWith(isGeneratingImage: false);
    }
  }

  Future<void> speakResult(String text) async {
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
