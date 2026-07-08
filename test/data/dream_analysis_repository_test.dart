import 'package:dream_reader/core/errors/app_error.dart';
import 'package:dream_reader/data/repositories/dream_analysis_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class _FakeDreamContentGenerator implements DreamContentGenerator {
  _FakeDreamContentGenerator(this.response);

  final String response;

  @override
  Future<String?> generate(List<Content> prompt) async => response;
}

void main() {
  group('DreamAnalysisRepositoryImpl', () {
    test('parses fenced json responses', () async {
      final repository = DreamAnalysisRepositoryImpl(
        generator: _FakeDreamContentGenerator('''
```json
{
  "interpretation": "You are processing change.",
  "psychological_insight": "Your mind is integrating uncertainty.",
  "dream_guidance": "Write the dream down before noon.",
  "archetypal_theme": "Moonlit staircase over the sea",
  "detected_language": "en"
}
```
'''),
      );

      final result = await repository.analyzeDream('I was climbing stairs over water.');

      expect(result.interpretation, 'You are processing change.');
      expect(result.detectedLanguage, 'en');
      expect(result.archetypalTheme, contains('Moonlit staircase'));
    });

    test('rejects empty dream text', () async {
      final repository = DreamAnalysisRepositoryImpl(
        generator: _FakeDreamContentGenerator('{}'),
      );

      expect(
        () => repository.analyzeDream('   '),
        throwsA(
          isA<AppError>().having(
            (error) => error.code,
            'code',
            AppErrorCode.validation,
          ),
        ),
      );
    });
  });
}
