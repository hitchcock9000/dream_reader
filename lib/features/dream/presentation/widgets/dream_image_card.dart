import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class DreamImageCard extends StatelessWidget {
  final String? imageUrl;
  final String? error;
  final bool isLoading;

  static final _customCacheManager = CacheManager(
    Config(
      'dream_image_cache',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 100,
    ),
  );

  const DreamImageCard({
    super.key,
    this.imageUrl,
    this.error,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B61FF).withValues(alpha: 0.4),
            blurRadius: 25.r,
            spreadRadius: 2.r,
          ),
          BoxShadow(
            color: const Color(0xFF00F0FF).withValues(alpha: 0.2),
            blurRadius: 40.r,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.r),
        child: isLoading
            ? Shimmer.fromColors(
                baseColor: const Color(0xFF1A1A2E),
                highlightColor: const Color(0xFF7B61FF),
                child: Container(
                  color: Colors.black,
                  child: const Center(
                    child: Icon(Icons.image, color: Colors.white24, size: 50),
                  ),
                ),
              )
            : error != null
                ? Container(
                    color: Colors.black,
                    padding: EdgeInsets.all(20.r),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color: Colors.amber, size: 40.sp),
                        SizedBox(height: 12.h),
                        Text(
                          "VISUALIZATION FAILED",
                          style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, fontSize: 11.sp),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                : imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: imageUrl!,
                        cacheManager: _customCacheManager, // Use persistent cache
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: const Color(0xFF1A1A2E),
                          highlightColor: const Color(0xFF7B61FF),
                          child: Container(color: Colors.black),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.black,
                          child: const Icon(Icons.error_outline, color: Colors.redAccent),
                        ),
                        fadeOutDuration: const Duration(milliseconds: 500),
                        fadeInDuration: const Duration(milliseconds: 800),
                      )
                    : const SizedBox.shrink(),
      ),
    );
  }
}
