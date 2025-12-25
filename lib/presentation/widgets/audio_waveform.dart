import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AudioWaveform extends StatelessWidget {
  final bool isListening;

  const AudioWaveform({super.key, required this.isListening});

  @override
  Widget build(BuildContext context) {
    if (!isListening) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(10, (index) {
        return _WaveBar(index: index);
      }),
    );
  }
}

class _WaveBar extends StatelessWidget {
  final int index;

  const _WaveBar({required this.index});

  @override
  Widget build(BuildContext context) {
    // Generate a random height delay to make it look organic
    final random = Random();
    final height = 20.0 + random.nextDouble() * 30.0; 
    
    return Container(
      width: 4,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF00F0FF).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(2),
      ),
    )
    .animate(
      onPlay: (c) => c.repeat(reverse: true),
    )
    .scaleY(
      begin: 0.2,
      end: 1.5,
      duration: Duration(milliseconds: 300 + (index * 50)),
      curve: Curves.easeInOut,
    );
  }
}
