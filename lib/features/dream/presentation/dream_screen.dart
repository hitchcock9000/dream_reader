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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dream_reader/core/extensions/l10n_extension.dart';

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
                fontSize: 12.sp,
                letterSpacing: 1.2,
              ),
            ),
            backgroundColor: const Color(0xFF7B61FF).withValues(alpha: 0.9),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
            margin: EdgeInsets.all(20.w),
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double vh = constraints.maxHeight;
                // Compact mode if height is small (e.g. mobile landscape or small browser)
                final bool isCompact = vh < 600;

                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: vh,
                        maxWidth: 700, // Fixed max width for desktop/tablet
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: isCompact ? 10.h : 20.h),
                            
                            // Header (Premium Typography)
                            Text(
                              context.l10n.appTitle,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.orbitron(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: isCompact ? 10.sp : 14.sp,
                                letterSpacing: isCompact ? 4 : 8,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          
                          SizedBox(height: isCompact ? 10.h : 30.h),
                          
                          // 3. The AI Agent Orb
                          SizedBox(
                            height: isCompact ? 180.h : 300.h,
                            child: AIOrb(
                              isListening: dreamState.isListening,
                              isLoading: dreamState.isLoading,
                            ),
                          ),

                          // 4. Results & Transcription
                          // Using a fixed height or minHeight for the feed area to avoid infinite scroll issues in Column
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: 200.h,
                              maxHeight: isCompact ? 400.h : 1000.h,
                            ),
                            child: Stack(
                              children: [
                                if (dreamState.isLoading)
                                  const LottieLoading(),

                                if (dreamState.error != null)
                                   Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(24.w),
                                      child: Text(
                                        "${context.l10n.errorConnection}\n${dreamState.error}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(color: Colors.redAccent),
                                      ),
                                    ),
                                  ),
                                  
                                if (dreamState.analysis != null && !dreamState.isLoading)
                                  AnalysisFeed(
                                    analysis: dreamState.analysis,
                                    imageUrl: dreamState.imageUrl,
                                    imageError: dreamState.imageError,
                                    isImageLoading: dreamState.isImageLoading,
                                    onShare: _captureAndShare,
                                  ),
                              ],
                            ),
                          ),

                          // 5. Shared Input Area
                          Padding(
                            padding: EdgeInsets.only(bottom: 30.h, top: 20.h),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 600.w),
                              child: SacredInput(
                                isListening: dreamState.isListening,
                                isLoading: dreamState.isLoading,
                                onStartListening: () {
                                  final locale = Localizations.localeOf(context);
                                  final localeId = "${locale.languageCode}-${locale.countryCode ?? locale.languageCode.toUpperCase()}";
                                  controller.startVoiceInput(localeId);
                                },
                                onStopListening: () => controller.stopVoiceInput(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
              },
            ),
          ),
    ],
  ),
);
  }
}
