// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dream_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DreamResponseImpl _$$DreamResponseImplFromJson(Map<String, dynamic> json) =>
    _$DreamResponseImpl(
      interpretation: json['interpretation'] as String,
      psychologicalInsight: json['psychological_insight'] as String,
      dreamGuidance: json['dream_guidance'] as String,
      archetypalTheme: json['archetypal_theme'] as String,
      detectedLanguage: json['detected_language'] as String,
    );

Map<String, dynamic> _$$DreamResponseImplToJson(_$DreamResponseImpl instance) =>
    <String, dynamic>{
      'interpretation': instance.interpretation,
      'psychological_insight': instance.psychologicalInsight,
      'dream_guidance': instance.dreamGuidance,
      'archetypal_theme': instance.archetypalTheme,
      'detected_language': instance.detectedLanguage,
    };
