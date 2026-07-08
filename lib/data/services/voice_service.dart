import 'package:dream_reader/core/logging/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speech_to_text/speech_to_text.dart';

part 'voice_service.g.dart';

@Riverpod(keepAlive: true)
VoiceService voiceService(Ref ref) {
  return VoiceService();
}

class VoiceService {
  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;

  Function(String)? _activeErrorCallback;

  Future<bool> initialize() async {
    if (!_isInitialized) {
      _isInitialized = await _speechToText.initialize(
        onError: (val) {
          AppLogger.warning(
            'Speech-to-text emitted an error.',
            scope: 'voice',
            error: val.errorMsg,
          );
          _activeErrorCallback?.call(val.errorMsg);
        },
        onStatus: (val) {
          AppLogger.debug(
            'Speech-to-text status update.',
            scope: 'voice',
            context: {'status': val},
          );
        },
        debugLogging: true,
      );
    }
    return _isInitialized;
  }

  Future<void> startListening({
    required Function(String) onResult,
    required Function(bool) onListeningStateChanged,
    required Function(String) onError,
    String localeId = 'tr-TR',
  }) async {
    _activeErrorCallback = onError;
    if (!_isInitialized) {
      final init = await initialize();
      if (!init) {
        onError('Voice service not initialized');
        return;
      }
    }

    onListeningStateChanged(true);

    _speechToText.statusListener = (status) {
      AppLogger.debug(
        'Voice status listener update.',
        scope: 'voice',
        context: {'status': status},
      );
      if (status == 'done' || status == 'notListening') {
        onListeningStateChanged(false);
      }
    };

    await _speechToText.listen(
      onResult: (result) {
        onResult(result.recognizedWords);
      },
      localeId: localeId,
      listenFor: const Duration(seconds: 60),
      pauseFor: const Duration(seconds: 10),
      // ignore: deprecated_member_use
      listenMode: ListenMode.dictation,
      // ignore: deprecated_member_use
      cancelOnError: false,
      // ignore: deprecated_member_use
      partialResults: true,
    );
  }

  Future<void> stopListening() async {
    if (_isInitialized) {
      await _speechToText.stop();
    }
  }

  bool get isListening => _speechToText.isListening;
}
