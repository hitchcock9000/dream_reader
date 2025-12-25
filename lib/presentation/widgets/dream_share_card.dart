import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DreamShareCard extends StatelessWidget {
  final String imageUrl;
  final String interpretation;

  const DreamShareCard({
    super.key,
    required this.imageUrl,
    required this.interpretation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400, // Fixed width for consistent export
      padding: const EdgeInsets.all(20),
      color: const Color(0xFF050510), // Dark background
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header
          Text(
            "D R E A M   R E A D E R",
            style: GoogleFonts.poppins(
              color: const Color(0xFF7B61FF),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 20),
          
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              imageUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          
          // Text
          Text(
            interpretation,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          
          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.auto_awesome, color: Color(0xFF00F0FF), size: 16),
              const SizedBox(width: 8),
              Text(
                "Interpreted by AI",
                style: TextStyle(
                  color: const Color(0xFF00F0FF).withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
