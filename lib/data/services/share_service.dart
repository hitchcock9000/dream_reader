import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

part 'share_service.g.dart';

@Riverpod(keepAlive: true)
ShareService shareService(Ref ref) {
  return ShareService();
}

class ShareService {
  Future<void> shareDream({
    required Uint8List imageBytes,
    required String text,
  }) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/dream_card.png').create();
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: text,
      );
    } catch (e) {
      debugPrint('Share Error: $e');
    }
  }
}
