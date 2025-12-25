import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieLoading extends StatelessWidget {
  const LottieLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Using a public free Lottie file for "Cosmic" or "Loading"
          // If this URL fails, Lottie will handle errors gracefully or we could wrap in try/catch
          SizedBox(
            height: 200,
            width: 200,
            child: Lottie.network(
              'https://lottie.host/8b488f21-8255-47e0-9467-684274391623/M5FwD38vW0.json', // Example cosmic loader
              errorBuilder: (context, error, stackTrace) {
                return const CircularProgressIndicator(color: Color(0xFFFF00FF));
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "CONSULTING THE COSMOS...",
            style: TextStyle(
              color: Color(0xFFFF00FF), 
              letterSpacing: 3.0,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
