import 'package:freezed_annotation/freezed_annotation.dart';

part 'dream_response.freezed.dart';
part 'dream_response.g.dart';

@freezed
class DreamResponse with _$DreamResponse {
  const factory DreamResponse({
    required String interpretation,
    @JsonKey(name: 'psychological_insight') required String psychologicalInsight,
    @JsonKey(name: 'dream_guidance') required String dreamGuidance,
    @JsonKey(name: 'archetypal_theme') required String archetypalTheme,
    @JsonKey(name: 'detected_language') required String detectedLanguage,
  }) = _DreamResponse;

  factory DreamResponse.fromJson(Map<String, dynamic> json) =>
      _$DreamResponseFromJson(json);
}
