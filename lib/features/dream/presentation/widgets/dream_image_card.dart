import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart' as cache;
import 'package:dream_reader/core/widgets/glass_container.dart';
import 'package:dream_reader/presentation/widgets/lottie_loading.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DreamImageCard extends StatelessWidget {
  final String? imageUrl;
  final String? error;
  final bool isLoading;

  const DreamImageCard({
    super.key,
    this.imageUrl,
    this.error,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double sw = size.width * 0.01;

    return GlassContainer(
      opacity: 0.08,
      blur: 20,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular((sw * 3).clamp(12.0, 20.0)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Animated gradient placeholder
              if (isLoading || imageUrl == null)
                AnimatedContainer(
                  duration: const Duration(seconds: 3),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1a1a2e),
                        Color(0xFF16213e),
                        Color(0xFF0f3460),
                        Color(0xFF16213e),
                        Color(0xFF1a1a2e),
                      ],
                      stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                    ),
                  ),
                )
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(
                      duration: 3.seconds,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),

              // Lottie loading animation overlay
              if (isLoading)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: (sw * 20).clamp(80.0, 150.0),
                        height: (sw * 20).clamp(80.0, 150.0),
                        child: const LottieLoading(),
                      ),
                      SizedBox(height: sw * 2),
                      Text(
                        'Manifesting your vision...',
                        style: GoogleFonts.orbitron(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: (sw * 2.5).clamp(10.0, 14.0),
                          letterSpacing: 2,
                        ),
                      )
                          .animate(onPlay: (c) => c.repeat(reverse: true))
                          .fadeIn()
                          .shimmer(duration: 2.seconds),
                    ],
                  ),
                ),

              // Actual image with progressive fade-in
              if (imageUrl != null && error == null)
                CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 1500),
                  fadeOutDuration: const Duration(milliseconds: 500),
                  placeholderFadeInDuration: const Duration(milliseconds: 500),
                  cacheManager: cache.CacheManager(
                    cache.Config(
                      'dreamImageCache',
                      stalePeriod: const Duration(days: 7),
                      maxNrOfCacheObjects: 50,
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF1a1a2e),
                          Color(0xFF16213e),
                          Color(0xFF0f3460),
                        ],
                      ),
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat())
                      .shimmer(duration: 2.seconds),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.black.withValues(alpha: 0.5),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image_outlined,
                            color: Colors.white.withValues(alpha: 0.3),
                            size: (sw * 10).clamp(40.0, 80.0),
                          ),
                          SizedBox(height: sw * 2),
                          Text(
                            'Vision could not materialize',
                            style: GoogleFonts.orbitron(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: (sw * 2).clamp(10.0, 12.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Error state
              if (error != null)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.red.withValues(alpha: 0.1),
                        Colors.black.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red.withValues(alpha: 0.7),
                          size: (sw * 8).clamp(40.0, 60.0),
                        ),
                        SizedBox(height: sw * 2),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: sw * 4),
                          child: Text(
                            error!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.orbitron(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: (sw * 2).clamp(10.0, 12.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
