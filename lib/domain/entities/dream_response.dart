import 'package:freezed_annotation/freezed_annotation.dart';

part 'dream_response.freezed.dart';
part 'dream_response.g.dart';

@freezed
class DreamResponse with _$DreamResponse {
  const factory DreamResponse({
    required String interpretation,
    @JsonKey(name: 'psychological_insight') required String psychologicalInsight,
    @JsonKey(name: 'mystical_symbol') required String mysticalSymbol,
    @JsonKey(name: 'image_generation_prompt') required String imageGenerationPrompt,
  }) = _DreamResponse;

  factory DreamResponse.fromJson(Map<String, dynamic> json) =>
      _$DreamResponseFromJson(json);
}
