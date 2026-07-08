import 'package:dream_reader/application/dream_state.dart';
import 'package:dream_reader/core/errors/app_error.dart';
import 'package:dream_reader/core/logging/logger.dart';
import 'package:dream_reader/core/services/image_service.dart';
import 'package:dream_reader/core/services/tts_service.dart';
import 'package:dream_reader/data/repositories/dream_analysis_repository_impl.dart';
import 'package:dream_reader/data/services/share_service.dart';
import 'package:dream_reader/data/services/voice_service.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dream_controller.g.dart';

@Riverpod(keepAlive: true)
class DreamController extends _$DreamController {
  late final SpeechSynthesizer _speechSynthesizer;

  @override
  DreamState build() {
    _speechSynthesizer = ref.read(speechSynthesizerProvider);
    _initTts();
    return const DreamState();
  }

  Future<void> _initTts() async {
    try {
      await _speechSynthesizer.configure();
    } catch (error, stackTrace) {
      AppLogger.warning(
        'Text-to-speech configuration failed.',
        scope: 'tts',
        error: error,
        context: {'stackTraceCaptured': stackTrace.toString().isNotEmpty},
      );
    }
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
        final error = AppError.voice(
          'Voice capture failed. Please try again.',
          cause: msg,
        );
        AppLogger.warning(
          'Voice input error received.',
          scope: 'voice',
          error: msg,
          context: {'localeId': localeId},
        );
        state = state.copyWith(
          isListening: false,
          error: error.message,
        );
      },
      onListeningStateChanged: (isListening) {
        state = state.copyWith(isListening: isListening);

        if (!isListening) {
          AppLogger.debug(
            'Voice transcription finished.',
            scope: 'voice',
            context: {'hasTranscription': state.transcription.trim().isNotEmpty},
          );
          if (state.transcription.trim().isNotEmpty) {
            submitDream(state.transcription);
          } else if (state.error == null) {
            state = state.copyWith(
              error: 'No speech detected. Tap the mic and try again.',
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
    final normalizedText = text.trim();
    if (normalizedText.isEmpty) {
      final error = AppError.validation('Dream text cannot be empty.');
      state = state.copyWith(error: error.message, isLoading: false);
      return;
    }

    state = state.copyWith(
      isLoading: true,
      error: null,
      transcription: normalizedText,
      imageError: null,
    );

    try {
      final repository = ref.read(dreamAnalysisRepositoryProvider);
      final analysis = await repository.analyzeDream(normalizedText);

      state = state.copyWith(
        isLoading: false,
        analysis: analysis,
      );

      _generateDreamImage(analysis.archetypalTheme);
      await speakResult(
        analysis.interpretation,
        languageCode: analysis.detectedLanguage,
      );
    } catch (error, stackTrace) {
      final appError = error is AppError
          ? error
          : AppError.unknown('Dream analysis failed. Please try again.', cause: error);
      AppLogger.error(
        'Dream submission failed.',
        scope: 'dream-controller',
        error: appError.cause ?? error,
        stackTrace: stackTrace,
      );
      state = state.copyWith(isLoading: false, error: appError.message);
    }
  }

  Future<void> _generateDreamImage(String prompt) async {
    state = state.copyWith(
      isImageLoading: true,
      imageError: null,
      imageUrl: null,
    );

    try {
      final service = ref.read(imageServiceProvider);
      final (url, error) = await service.generateDreamImage(prompt);

      if (url != null) {
        state = state.copyWith(imageUrl: url, isImageLoading: false);
        return;
      }

      final imageError = AppError.imageGeneration(
        error ?? 'Image generation failed.',
      );
      AppLogger.warning(
        'Image generation returned no URL.',
        scope: 'image',
        error: error,
      );
      state = state.copyWith(
        imageError: imageError.message,
        isImageLoading: false,
      );
    } catch (error, stackTrace) {
      final appError = AppError.imageGeneration(
        'Image generation failed. Please try again.',
        cause: error,
      );
      AppLogger.error(
        'Image generation threw an exception.',
        scope: 'image',
        error: error,
        stackTrace: stackTrace,
      );
      state = state.copyWith(
        imageError: appError.message,
        isImageLoading: false,
      );
    }
  }

  Future<void> speakResult(String text, {String? languageCode}) async {
    try {
      await _speechSynthesizer.speak(text, languageCode: languageCode);
    } catch (error, stackTrace) {
      AppLogger.warning(
        'Text-to-speech playback failed.',
        scope: 'tts',
        error: error,
        context: {
          'hasLanguageCode': languageCode != null && languageCode.isNotEmpty,
          'stackTraceCaptured': stackTrace.toString().isNotEmpty,
        },
      );
    }
  }

  Future<void> shareResult(Uint8List imageBytes) async {
    final analysis = state.analysis;
    if (analysis == null) return;

    state = state.copyWith(isSharingImage: true);

    try {
      final shareText =
          '🌌 Dream Interpretation:\n${analysis.interpretation}\n\n#DreamReader #AIProduct';

      await ref.read(shareServiceProvider).shareDreamCard(
            imageBytes: imageBytes,
            text: shareText,
          );

      state = state.copyWith(isSharingImage: false);
    } catch (error, stackTrace) {
      AppLogger.error(
        'Share flow failed.',
        scope: 'share',
        error: error,
        stackTrace: stackTrace,
      );
      state = state.copyWith(
        isSharingImage: false,
        error: AppError.share(
          'Failed to share dream card. Please try again.',
          cause: error,
        ).message,
      );
    }
  }
}
