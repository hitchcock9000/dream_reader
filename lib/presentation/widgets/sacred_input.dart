import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:dream_reader/presentation/widgets/audio_waveform.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dream_reader/core/widgets/glass_container.dart';
import 'package:dream_reader/application/dream_controller.dart';
import 'package:dream_reader/core/extensions/l10n_extension.dart';

class SacredInput extends ConsumerStatefulWidget {
  final bool isListening;
  final bool isLoading;
  final VoidCallback onStartListening;
  final VoidCallback onStopListening;

  const SacredInput({
    super.key,
    required this.isListening,
    this.isLoading = false,
    required this.onStartListening,
    required this.onStopListening,
  });

  @override
  ConsumerState<SacredInput> createState() => _SacredInputState();
}

class _SacredInputState extends ConsumerState<SacredInput> {
  bool _isManualMode = false;
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submitManual() {
    if (_textController.text.trim().isNotEmpty) {
      final locale = Localizations.localeOf(context);
      ref.read(dreamControllerProvider.notifier).submitDream(
        _textController.text,
        languageCode: locale.languageCode,
      );
      _textController.clear();
      setState(() => _isManualMode = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.isListening) ...[
          Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: const AudioWaveform(isListening: true),
          ),
          Text(
            context.l10n.listeningStatus,
            style: GoogleFonts.orbitron(
              color: Colors.white.withValues(alpha: 0.7),
              letterSpacing: 2.0,
              fontSize: 10.sp,
              fontWeight: FontWeight.w300,
            ),
          ).animate().fadeIn(),
          SizedBox(height: 20.h),
        ],

        if (widget.isLoading) ...[
          Text(
            context.l10n.analyzingStatus,
            style: GoogleFonts.orbitron(
              color: const Color(0xFFFF00FF),
              letterSpacing: 2.0,
              fontSize: 10.sp,
              fontWeight: FontWeight.w300,
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn().shimmer(duration: 1.seconds),
          SizedBox(height: 20.h),
        ],

        if (_isManualMode && !widget.isLoading && !widget.isListening) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: GlassContainer(
              opacity: 0.1,
              child: TextField(
                controller: _textController,
                autofocus: true,
                maxLines: 3,
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
                decoration: InputDecoration(
                  hintText: context.l10n.inputPlaceholder,
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFF00F0FF)),
                    onPressed: _submitManual,
                  ),
                ),
                onSubmitted: (_) => _submitManual(),
              ),
            ),
          ).animate().fadeIn().slideY(begin: 0.1, end: 0),
          SizedBox(height: 10.h),
          TextButton(
            onPressed: () => setState(() => _isManualMode = false),
            child: Text(
              "CANCEL",
              style: GoogleFonts.orbitron(color: Colors.white38, fontSize: 10.sp, letterSpacing: 2),
            ),
          ),
        ] else if (!widget.isListening && !widget.isLoading) ...[
          GestureDetector(
            onTap: widget.onStartListening,
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 280.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: const Color(0xFF7B61FF).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(40.r),
                border: Border.all(
                  color: const Color(0xFF7B61FF).withValues(alpha: 0.5),
                  width: 1.5.w,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7B61FF).withValues(alpha: 0.2),
                    blurRadius: 30.r,
                    spreadRadius: 2.r,
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.mic, color: Colors.white, size: 20.sp),
                    SizedBox(width: 15.w),
                    Text(
                      "RECORD DREAM",
                      style: GoogleFonts.orbitron(
                        color: Colors.white,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 15.h),
          TextButton(
            onPressed: () => setState(() => _isManualMode = true),
            child: Text(
              "OR TYPE YOUR VISION",
              style: GoogleFonts.orbitron(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 10.sp,
                letterSpacing: 2,
              ),
            ),
          ),
        ] else if (widget.isListening) ...[
           GestureDetector(
            onTap: widget.onStopListening,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 80.w,
              height: 80.w, // Circle use width
              decoration: BoxDecoration(
                color: const Color(0xFF00F0FF).withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF00F0FF).withValues(alpha: 0.8),
                  width: 1.5.w,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00F0FF).withValues(alpha: 0.2),
                    blurRadius: 30.r,
                    spreadRadius: 2.r,
                  ),
                ],
              ),
              child: Center(
                child: Icon(Icons.stop, color: const Color(0xFF00F0FF), size: 28.sp),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
