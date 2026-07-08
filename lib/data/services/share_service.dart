import 'dart:io';

import 'package:dream_reader/core/logging/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

part 'share_service.g.dart';

@Riverpod(keepAlive: true)
ShareService shareService(Ref ref) {
  return ShareService();
}

class ShareService {
  Future<void> shareDreamCard({
    required Uint8List imageBytes,
    required String text,
  }) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = await File('${tempDir.path}/dream_card_$timestamp.png').create();
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: text,
      );

      AppLogger.info('Dream card shared successfully.', scope: 'share');
    } catch (error, stackTrace) {
      AppLogger.error(
        'Dream card sharing failed.',
        scope: 'share',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
