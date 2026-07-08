import 'package:dream_reader/core/logging/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnvironment {
  const AppEnvironment._();

  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
      AppLogger.info('Loaded .env configuration', scope: 'config');
    } catch (error) {
      AppLogger.warning(
        'No .env file found; falling back to dart-defines.',
        scope: 'config',
        error: error,
        context: {
          'hasGeminiDefine': geminiApiKey.isNotEmpty,
          'hasOpenAiDefine': openAiApiKey.isNotEmpty,
        },
      );
      AppLogger.debug('Environment load fallback complete', scope: 'config');
    }
  }

  static String get geminiApiKey => _readValue(
        key: 'GEMINI_API_KEY',
        dartDefineValue: const String.fromEnvironment('GEMINI_API_KEY'),
      );

  static String get openAiApiKey => _readValue(
        key: 'OPENAI_API_KEY',
        dartDefineValue: const String.fromEnvironment('OPENAI_API_KEY'),
      );

  static bool get hasGeminiKey => geminiApiKey.isNotEmpty;
  static bool get hasOpenAiKey => openAiApiKey.isNotEmpty;

  static String _readValue({
    required String key,
    required String dartDefineValue,
  }) {
    final envValue = dotenv.env[key]?.trim() ?? '';
    if (envValue.isNotEmpty) {
      return envValue;
    }
    return dartDefineValue.trim();
  }
}
