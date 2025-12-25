// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dream_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DreamResponse _$DreamResponseFromJson(Map<String, dynamic> json) {
  return _DreamResponse.fromJson(json);
}

/// @nodoc
mixin _$DreamResponse {
  String get interpretation => throw _privateConstructorUsedError;
  @JsonKey(name: 'psychological_insight')
  String get psychologicalInsight => throw _privateConstructorUsedError;
  @JsonKey(name: 'mystical_symbol')
  String get mysticalSymbol => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_generation_prompt')
  String get imageGenerationPrompt => throw _privateConstructorUsedError;

  /// Serializes this DreamResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DreamResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DreamResponseCopyWith<DreamResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DreamResponseCopyWith<$Res> {
  factory $DreamResponseCopyWith(
          DreamResponse value, $Res Function(DreamResponse) then) =
      _$DreamResponseCopyWithImpl<$Res, DreamResponse>;
  @useResult
  $Res call(
      {String interpretation,
      @JsonKey(name: 'psychological_insight') String psychologicalInsight,
      @JsonKey(name: 'mystical_symbol') String mysticalSymbol,
      @JsonKey(name: 'image_generation_prompt') String imageGenerationPrompt});
}

/// @nodoc
class _$DreamResponseCopyWithImpl<$Res, $Val extends DreamResponse>
    implements $DreamResponseCopyWith<$Res> {
  _$DreamResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DreamResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? interpretation = null,
    Object? psychologicalInsight = null,
    Object? mysticalSymbol = null,
    Object? imageGenerationPrompt = null,
  }) {
    return _then(_value.copyWith(
      interpretation: null == interpretation
          ? _value.interpretation
          : interpretation // ignore: cast_nullable_to_non_nullable
              as String,
      psychologicalInsight: null == psychologicalInsight
          ? _value.psychologicalInsight
          : psychologicalInsight // ignore: cast_nullable_to_non_nullable
              as String,
      mysticalSymbol: null == mysticalSymbol
          ? _value.mysticalSymbol
          : mysticalSymbol // ignore: cast_nullable_to_non_nullable
              as String,
      imageGenerationPrompt: null == imageGenerationPrompt
          ? _value.imageGenerationPrompt
          : imageGenerationPrompt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DreamResponseImplCopyWith<$Res>
    implements $DreamResponseCopyWith<$Res> {
  factory _$$DreamResponseImplCopyWith(
          _$DreamResponseImpl value, $Res Function(_$DreamResponseImpl) then) =
      __$$DreamResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String interpretation,
      @JsonKey(name: 'psychological_insight') String psychologicalInsight,
      @JsonKey(name: 'mystical_symbol') String mysticalSymbol,
      @JsonKey(name: 'image_generation_prompt') String imageGenerationPrompt});
}

/// @nodoc
class __$$DreamResponseImplCopyWithImpl<$Res>
    extends _$DreamResponseCopyWithImpl<$Res, _$DreamResponseImpl>
    implements _$$DreamResponseImplCopyWith<$Res> {
  __$$DreamResponseImplCopyWithImpl(
      _$DreamResponseImpl _value, $Res Function(_$DreamResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of DreamResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? interpretation = null,
    Object? psychologicalInsight = null,
    Object? mysticalSymbol = null,
    Object? imageGenerationPrompt = null,
  }) {
    return _then(_$DreamResponseImpl(
      interpretation: null == interpretation
          ? _value.interpretation
          : interpretation // ignore: cast_nullable_to_non_nullable
              as String,
      psychologicalInsight: null == psychologicalInsight
          ? _value.psychologicalInsight
          : psychologicalInsight // ignore: cast_nullable_to_non_nullable
              as String,
      mysticalSymbol: null == mysticalSymbol
          ? _value.mysticalSymbol
          : mysticalSymbol // ignore: cast_nullable_to_non_nullable
              as String,
      imageGenerationPrompt: null == imageGenerationPrompt
          ? _value.imageGenerationPrompt
          : imageGenerationPrompt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DreamResponseImpl implements _DreamResponse {
  const _$DreamResponseImpl(
      {required this.interpretation,
      @JsonKey(name: 'psychological_insight')
      required this.psychologicalInsight,
      @JsonKey(name: 'mystical_symbol') required this.mysticalSymbol,
      @JsonKey(name: 'image_generation_prompt')
      required this.imageGenerationPrompt});

  factory _$DreamResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$DreamResponseImplFromJson(json);

  @override
  final String interpretation;
  @override
  @JsonKey(name: 'psychological_insight')
  final String psychologicalInsight;
  @override
  @JsonKey(name: 'mystical_symbol')
  final String mysticalSymbol;
  @override
  @JsonKey(name: 'image_generation_prompt')
  final String imageGenerationPrompt;

  @override
  String toString() {
    return 'DreamResponse(interpretation: $interpretation, psychologicalInsight: $psychologicalInsight, mysticalSymbol: $mysticalSymbol, imageGenerationPrompt: $imageGenerationPrompt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DreamResponseImpl &&
            (identical(other.interpretation, interpretation) ||
                other.interpretation == interpretation) &&
            (identical(other.psychologicalInsight, psychologicalInsight) ||
                other.psychologicalInsight == psychologicalInsight) &&
            (identical(other.mysticalSymbol, mysticalSymbol) ||
                other.mysticalSymbol == mysticalSymbol) &&
            (identical(other.imageGenerationPrompt, imageGenerationPrompt) ||
                other.imageGenerationPrompt == imageGenerationPrompt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, interpretation,
      psychologicalInsight, mysticalSymbol, imageGenerationPrompt);

  /// Create a copy of DreamResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DreamResponseImplCopyWith<_$DreamResponseImpl> get copyWith =>
      __$$DreamResponseImplCopyWithImpl<_$DreamResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DreamResponseImplToJson(
      this,
    );
  }
}

abstract class _DreamResponse implements DreamResponse {
  const factory _DreamResponse(
      {required final String interpretation,
      @JsonKey(name: 'psychological_insight')
      required final String psychologicalInsight,
      @JsonKey(name: 'mystical_symbol') required final String mysticalSymbol,
      @JsonKey(name: 'image_generation_prompt')
      required final String imageGenerationPrompt}) = _$DreamResponseImpl;

  factory _DreamResponse.fromJson(Map<String, dynamic> json) =
      _$DreamResponseImpl.fromJson;

  @override
  String get interpretation;
  @override
  @JsonKey(name: 'psychological_insight')
  String get psychologicalInsight;
  @override
  @JsonKey(name: 'mystical_symbol')
  String get mysticalSymbol;
  @override
  @JsonKey(name: 'image_generation_prompt')
  String get imageGenerationPrompt;

  /// Create a copy of DreamResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DreamResponseImplCopyWith<_$DreamResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
