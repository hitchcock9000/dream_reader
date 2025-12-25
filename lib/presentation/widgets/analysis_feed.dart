import 'package:dream_reader/core/widgets/glass_container.dart';
import 'package:dream_reader/domain/entities/dream_response.dart';
import 'package:dream_reader/presentation/widgets/dream_image_reveal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class AnalysisFeed extends StatelessWidget {
  final DreamResponse? analysis;
  final String? imageUrl;
  final bool isGeneratingImage;
  final VoidCallback? onShare;

  const AnalysisFeed({
    super.key,
    this.analysis,
    this.imageUrl,
    this.isGeneratingImage = false,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    if (analysis == null) return const SizedBox.shrink();

    final List<Widget> items = [];

    // 1. The Dream Image (if ready)
    if (imageUrl != null) {
      items.add(DreamImageReveal(imageUrl: imageUrl!));
    } else if (isGeneratingImage) {
      // Placeholder for image generation
      items.add(
        const GlassContainer(
          opacity: 0.1,
          child: SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF00F0FF)),
                  SizedBox(height: 10),
                  Text("MANIFESTING VISUALS...", style: TextStyle(color: Colors.white70, letterSpacing: 2)),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // 2. Text Content
    items.addAll([
      _FeedItem(
        title: "INTERPRETATION",
        content: analysis!.interpretation,
        icon: Icons.auto_awesome,
        color: const Color(0xFF7B61FF),
      ),
      _FeedItem(
        title: "PSYCHOLOGICAL INSIGHT",
        content: analysis!.psychologicalInsight,
        icon: Icons.psychology,
        color: const Color(0xFF00F0FF),
      ),
      _FeedItem(
        title: "MYSTICAL SYMBOL",
        content: analysis!.mysticalSymbol,
        icon: Icons.star,
        color: const Color(0xFFFF00FF),
      ),
      _FeedItem(
        title: "VISUAL PROMPT",
        content: analysis!.imageGenerationPrompt,
        icon: Icons.image,
        color: Colors.amber,
      ),
    ]);

    // 3. Share Button
    if (imageUrl != null && onShare != null) {
       items.add(
         Center(
           child: ElevatedButton.icon(
             onPressed: onShare,
             icon: const Icon(Icons.share),
             label: const Text("SHARE DREAM CARD"),
             style: ElevatedButton.styleFrom(
               backgroundColor: const Color(0xFF7B61FF),
               foregroundColor: Colors.white,
               padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
             ),
           ).animate().fadeIn(delay: 2.seconds),
         ),
       );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: item,
              ))
          .toList()
          .animate(interval: 200.ms)
          .fadeIn(duration: 800.ms)
          .blur(begin: const Offset(10, 10), end: Offset.zero, duration: 800.ms)
          .slideY(begin: 0.2, end: 0, duration: 800.ms, curve: Curves.easeOutCirc),
    );
  }
}

class _FeedItem extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color color;

  const _FeedItem({
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      opacity: 0.08,
      blur: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.orbitron(
                    color: color,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              color: Colors.white, // Using white text for readability
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
