import 'package:dream_reader/core/widgets/glass_container.dart';
import 'package:dream_reader/domain/entities/dream_response.dart';
import 'package:dream_reader/features/dream/presentation/widgets/dream_image_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dream_reader/core/extensions/l10n_extension.dart';

class AnalysisFeed extends StatelessWidget {
  final DreamResponse? analysis;
  final String? imageUrl;
  final String? imageError;
  final bool isImageLoading;
  final VoidCallback? onShare;

  const AnalysisFeed({
    super.key,
    this.analysis,
    this.imageUrl,
    this.imageError,
    this.isImageLoading = false,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    if (analysis == null) return const SizedBox.shrink();

    final size = MediaQuery.of(context).size;
    final double sw = size.width * 0.01;

    final List<Widget> items = [];

    // 1. The Dream Image
    if (imageUrl != null || isImageLoading || imageError != null) {
      items.add(DreamImageCard(
        imageUrl: imageUrl,
        error: imageError,
        isLoading: isImageLoading,
      ));
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
        title: "DREAM GUIDANCE",
        content: analysis!.dreamGuidance,
        icon: Icons.lightbulb,
        color: const Color(0xFFFF00FF),
      ),
      _FeedItem(
        title: "ARCHETYPAL THEME",
        content: analysis!.archetypalTheme,
        icon: Icons.auto_awesome_motion,
        color: Colors.amber,
      ),
    ]);

    // 3. Share Button
    if (imageUrl != null && onShare != null) {
       items.add(
         Center(
           child: Padding(
             padding: EdgeInsets.symmetric(vertical: sw * 4),
             child: ElevatedButton.icon(
               onPressed: onShare,
               icon: const Icon(Icons.share),
               label: Text(context.l10n.shareText),
               style: ElevatedButton.styleFrom(
                 backgroundColor: const Color(0xFF7B61FF),
                 foregroundColor: Colors.white,
                 padding: EdgeInsets.symmetric(
                   horizontal: sw * 8, 
                   vertical: sw * 3,
                 ),
                 textStyle: GoogleFonts.orbitron(
                   fontSize: (sw * 3).clamp(12.0, 16.0),
                   letterSpacing: 1.5,
                 ),
               ),
             ).animate().fadeIn(delay: 2.seconds),
           ),
         ),
       );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: items
          .map((item) => Padding(
                padding: EdgeInsets.only(bottom: sw * 5),
                child: item,
              ))
          .toList()
          .animate(interval: 300.ms)
          .fadeIn(duration: 1000.ms, curve: Curves.easeOut)
          .blur(
            begin: const Offset(15, 15),
            end: Offset.zero,
            duration: 1000.ms,
            curve: Curves.easeOutCubic,
          )
          .slideY(
            begin: 0.15,
            end: 0,
            duration: 1000.ms,
            curve: Curves.easeOutCubic,
          )
          .scale(
            begin: const Offset(0.95, 0.95),
            end: const Offset(1.0, 1.0),
            duration: 1000.ms,
            curve: Curves.easeOutCubic,
          ),
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
    final size = MediaQuery.of(context).size;
    final double sw = size.width * 0.01;

    return GlassContainer(
      opacity: 0.08,
      blur: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon, 
                color: color, 
                size: (sw * 4).clamp(16.0, 22.0),
              ),
              SizedBox(width: sw * 2.5),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.orbitron(
                    color: color,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: (sw * 3).clamp(11.0, 14.0),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: sw * 3),
          Text(
            content,
            style: TextStyle(
              color: Colors.white,
              fontSize: (size.width >= 1024) 
                  ? (sw * 1.5).clamp(16.0, 20.0) 
                  : (sw * 4).clamp(14.0, 17.0),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
