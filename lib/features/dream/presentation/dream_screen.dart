import 'dart:ui' as ui;

import 'package:dream_reader/application/dream_controller.dart';
import 'package:dream_reader/application/dream_state.dart';
import 'package:dream_reader/presentation/widgets/ai_orb.dart';
import 'package:dream_reader/presentation/widgets/analysis_feed.dart';
import 'package:dream_reader/presentation/widgets/dream_share_card.dart';
import 'package:dream_reader/presentation/widgets/lottie_loading.dart';
import 'package:dream_reader/presentation/widgets/nebula_background.dart';
import 'package:dream_reader/presentation/widgets/sacred_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class DreamScreen extends ConsumerStatefulWidget {
  const DreamScreen({super.key});

  @override
  ConsumerState<DreamScreen> createState() => _DreamScreenState();
}

class _DreamScreenState extends ConsumerState<DreamScreen> {
  final GlobalKey _shareKey = GlobalKey();

  Future<void> _captureAndShare() async {
    try {
      final boundary = _shareKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      
      if (boundary == null) {
        debugPrint("Share Error: Boundary not found");
        return;
      }

      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData != null) {
        final pngBytes = byteData.buffer.asUint8List();
        ref.read(dreamControllerProvider.notifier).shareResult(pngBytes);
      }
    } catch (e) {
      debugPrint("Share Capture Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final dreamState = ref.watch(dreamControllerProvider);
    final controller = ref.read(dreamControllerProvider.notifier);

    // Listen for errors to show feedback
    ref.listen<DreamState>(dreamControllerProvider, (previous, next) {
      if (next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.error.toString(),
              style: GoogleFonts.orbitron(
                color: Colors.white,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
            backgroundColor: const Color(0xFF7B61FF).withValues(alpha: 0.9),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(20),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 0. Hidden Share Card
          if (dreamState.analysis != null && dreamState.imageUrl != null)
             Transform.translate(
               offset: const Offset(-2000, -2000),
               child: RepaintBoundary(
                 key: _shareKey,
                 child: DreamShareCard(
                   imageUrl: dreamState.imageUrl!,
                   interpretation: dreamState.analysis!.interpretation,
                 ),
               ),
             ),

          // 1. Cinematic Background
          const NebulaBackground(),

          // 2. UI Layer
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                
                // Header (Premium Typography)
                Text(
                  "D R E A M   R E A D E R",
                  style: GoogleFonts.orbitron(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 12,
                    letterSpacing: 8,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // 3. The AI Agent Orb (with ripples handled internally now)
                AIOrb(
                  isListening: dreamState.isListening,
                  isLoading: dreamState.isLoading,
                ),

                // 4. Results & Transcription
                Expanded(
                  child: Stack(
                    children: [
                      if (dreamState.isLoading)
                        const LottieLoading(),

                      if (dreamState.error != null)
                         Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              "Connection to the Dream Realm failed.\n${dreamState.error}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        ),
                        
                      if (dreamState.analysis != null && !dreamState.isLoading)
                        AnalysisFeed(
                          analysis: dreamState.analysis,
                          imageUrl: dreamState.imageUrl,
                          isGeneratingImage: dreamState.isGeneratingImage,
                          onShare: _captureAndShare,
                        ),
                    ],
                  ),
                ),

                // 5. Shared Input Area
                Padding(
                  padding: const EdgeInsets.only(bottom: 30, top: 20),
                  child: SacredInput(
                    isListening: dreamState.isListening,
                    isLoading: dreamState.isLoading,
                    onStartListening: () => controller.startVoiceInput(),
                    onStopListening: () => controller.stopVoiceInput(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
