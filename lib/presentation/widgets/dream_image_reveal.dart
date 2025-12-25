import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DreamImageReveal extends StatelessWidget {
  final String imageUrl;

  const DreamImageReveal({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B61FF).withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 0, sigmaY: 0), // Base state (clear)
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF00F0FF)),
            );
          },
        ),
      )
      .animate()
      .custom(
        duration: 4.seconds,
        builder: (context, value, child) {
           // Value goes from 0 to 1
           // We want blur to go from HIGH to LOW (Revealing)
           final blur = (1 - value) * 20; 
           return ImageFiltered(
             imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
             child: child,
           );
        },
      )
      .fadeIn(duration: 1.seconds),
    );
  }
}
