import 'package:dream_reader/application/dream_controller.dart';
import 'package:dream_reader/core/services/image_service.dart';
import 'package:dream_reader/core/services/tts_service.dart';
import 'package:dream_reader/data/repositories/dream_analysis_repository_impl.dart';
import 'package:dream_reader/domain/entities/dream_response.dart';
import 'package:dream_reader/domain/repositories/dream_analysis_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeDreamRepository implements DreamAnalysisRepository {
  @override
  Future<DreamResponse> analyzeDream(String text) async {
    return const DreamResponse(
      interpretation: 'You are integrating a major life transition.',
      psychologicalInsight: 'The dream reflects active meaning-making.',
      dreamGuidance: 'Capture the strongest symbol before it fades.',
      archetypalTheme: 'Silver ocean beneath a glowing moon',
      detectedLanguage: 'en',
    );
  }
}

class _FakeImageService extends ImageService {
  @override
  Future<(String? url, String? error)> generateDreamImage(String visualPrompt) async {
    return ('https://example.com/generated-image.png', null);
  }
}

class _FakeSpeechSynthesizer implements SpeechSynthesizer {
  int configureCalls = 0;
  final List<String> spokenTexts = [];
  final List<String?> spokenLanguages = [];

  @override
  Future<void> configure({
    String defaultLanguage = 'tr-TR',
    double pitch = 0.9,
    double speechRate = 0.4,
  }) async {
    configureCalls += 1;
  }

  @override
  Future<void> speak(String text, {String? languageCode}) async {
    spokenTexts.add(text);
    spokenLanguages.add(languageCode);
  }
}

void main() {
  test('submitDream stores analysis and triggers image and speech flows', () async {
    final fakeSpeech = _FakeSpeechSynthesizer();
    final container = ProviderContainer(
      overrides: [
        dreamAnalysisRepositoryProvider.overrideWithValue(_FakeDreamRepository()),
        imageServiceProvider.overrideWithValue(_FakeImageService()),
        speechSynthesizerProvider.overrideWithValue(fakeSpeech),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(dreamControllerProvider.notifier);
    await Future<void>.delayed(Duration.zero);

    await notifier.submitDream('I was floating above the city.');
    await Future<void>.delayed(Duration.zero);

    final state = container.read(dreamControllerProvider);

    expect(fakeSpeech.configureCalls, 1);
    expect(fakeSpeech.spokenTexts, hasLength(1));
    expect(fakeSpeech.spokenLanguages.single, 'en');
    expect(state.analysis, isNotNull);
    expect(state.analysis?.dreamGuidance, contains('Capture the strongest symbol'));
    expect(state.imageUrl, 'https://example.com/generated-image.png');
    expect(state.error, isNull);
    expect(state.isLoading, isFalse);
  });
}
