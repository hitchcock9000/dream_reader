import 'package:dream_reader/domain/entities/dream_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dream_state.freezed.dart';

@freezed
class DreamState with _$DreamState {
  const factory DreamState({
    @Default(false) bool isLoading,
    @Default(false) bool isListening,
    @Default('') String transcription,
    DreamResponse? analysis,
    String? error,
    String? imageUrl,
    String? imageError,
    @Default(false) bool isImageLoading,
  }) = _DreamState;
}
