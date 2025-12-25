import 'package:flutter/material.dart';

@immutable
class CosmicColors extends ThemeExtension<CosmicColors> {
  const CosmicColors({
    required this.background,
    required this.surface,
    required this.primary,
    required this.accent,
  });

  final Color background;
  final Color surface;
  final Color primary;
  final Color accent;

  static const light = CosmicColors(
    background: Color(0xFF050510),
    surface: Color(0xFF1A1A2E),
    primary: Color(0xFF7B61FF),
    accent: Color(0xFF00F0FF),
  );
  
  // Since we are doing a specific "Cosmic Dark" style, 
  // we might use the same colors or slight variations for dark mode 
  // if we supported both, but the requirement is specific:
  // Background: #050510, Surface: #1A1A2E, Primary: #7B61FF, Accent: #00F0FF
  // We'll treat this as the default/main palette.

  @override
  CosmicColors copyWith({
    Color? background,
    Color? surface,
    Color? primary,
    Color? accent,
  }) {
    return CosmicColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
    );
  }

  @override
  CosmicColors lerp(ThemeExtension<CosmicColors>? other, double t) {
    if (other is! CosmicColors) {
      return this;
    }
    return CosmicColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
    );
  }
}
