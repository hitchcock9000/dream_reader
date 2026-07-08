import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

abstract class SpeechSynthesizer {
  Future<void> configure({
    String defaultLanguage,
    double pitch,
    double speechRate,
  });

  Future<void> speak(String text, {String? languageCode});
}

final speechSynthesizerProvider = Provider<SpeechSynthesizer>(
  (ref) => FlutterSpeechSynthesizer(),
);

class FlutterSpeechSynthesizer implements SpeechSynthesizer {
  FlutterSpeechSynthesizer([FlutterTts? flutterTts])
      : _flutterTts = flutterTts ?? FlutterTts();

  final FlutterTts _flutterTts;

  @override
  Future<void> configure({
    String defaultLanguage = 'tr-TR',
    double pitch = 0.9,
    double speechRate = 0.4,
  }) async {
    await _flutterTts.setLanguage(defaultLanguage);
    await _flutterTts.setPitch(pitch);
    await _flutterTts.setSpeechRate(speechRate);
  }

  @override
  Future<void> speak(String text, {String? languageCode}) async {
    if (languageCode != null && languageCode.isNotEmpty) {
      await _flutterTts.setLanguage(languageCode);
    }
    await _flutterTts.speak(text);
  }
}
