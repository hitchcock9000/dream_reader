import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AIOrb extends StatelessWidget {
  final bool isListening;
  final bool isLoading;

  const AIOrb({
    super.key,
    required this.isListening,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    // Dynamic color based on state
    final Color primaryColor = isLoading 
        ? const Color(0xFFFF00FF) // Loading Magenta
        : isListening 
            ? const Color(0xFF00F0FF) // Listening Cyan
            : const Color(0xFF7B61FF); // Idle Purple

    return Center(
      child: SizedBox(
        width: 300.w,
        height: 300.w, // Keep it square using width
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Concentric Ripples when listening
            if (isListening) ...[
              for (int i = 0; i < 3; i++)
                Container(
                  width: 150.w,
                  height: 150.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF00F0FF).withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                )
                .animate(onPlay: (c) => c.repeat())
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(2.0, 2.0),
                  duration: (1.5 + i * 0.5).seconds,
                  curve: Curves.easeOut,
                )
                .fadeOut(duration: (1.5 + i * 0.5).seconds),
            ],

            // The Main Orb
            Container(
              width: 150.w,
              height: 150.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.9), // Center highlight
                    primaryColor.withValues(alpha: 0.6),
                    primaryColor,
                    Colors.black.withValues(alpha: 0.8), // Edge shadow for 3D
                  ],
                  stops: const [0.1, 0.3, 0.7, 1.0],
                  center: const Alignment(-0.2, -0.2), // Offset for 3D light source
                ),
                boxShadow: [
                  // Inner glow
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.5),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                  // Outer glow
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.3),
                    blurRadius: 60,
                    spreadRadius: 20,
                  ),
                ],
              ),
            )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveY(
              begin: 0, 
              end: -20, 
              duration: 4.seconds, 
              curve: Curves.easeInOutSine,
            ) // Floating effect
            .animate(
              target: isListening ? 1 : 0,
            )
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.1, 1.1),
              duration: 1.seconds,
              curve: Curves.easeInOut,
            ) // Breathing intensified when listening
            .animate(
              target: isLoading ? 1 : 0,
            )
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.2, 1.2),
              duration: 100.ms,
              curve: Curves.elasticIn,
            ) // High-frequency pulse when loading
            .then()
            .animate(
              target: isLoading ? 1 : 0,
              onPlay: (c) => c.repeat(reverse: true),
            )
            .shimmer(
              duration: 1.seconds,
              color: Colors.white.withValues(alpha: 0.8),
            ), // Intensified shimmer when loading
          ],
        ),
      ),
    );
  }
}
