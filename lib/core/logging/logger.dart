import 'package:flutter/foundation.dart';

enum AppLogLevel { debug, info, warning, error }

class AppLogger {
  const AppLogger._();

  static void debug(
    String message, {
    String scope = 'app',
    Map<String, Object?>? context,
  }) {
    _log(AppLogLevel.debug, message, scope: scope, context: context);
  }

  static void info(
    String message, {
    String scope = 'app',
    Map<String, Object?>? context,
  }) {
    _log(AppLogLevel.info, message, scope: scope, context: context);
  }

  static void warning(
    String message, {
    String scope = 'app',
    Object? error,
    Map<String, Object?>? context,
  }) {
    _log(
      AppLogLevel.warning,
      message,
      scope: scope,
      error: error,
      context: context,
    );
  }

  static void error(
    String message, {
    String scope = 'app',
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
  }) {
    _log(
      AppLogLevel.error,
      message,
      scope: scope,
      error: error,
      stackTrace: stackTrace,
      context: context,
    );
  }

  static void _log(
    AppLogLevel level,
    String message, {
    required String scope,
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? context,
  }) {
    final buffer = StringBuffer('[${level.name.toUpperCase()}][$scope] $message');

    if (context != null && context.isNotEmpty) {
      buffer.write(' | $context');
    }

    if (error != null) {
      buffer.write(' | error=$error');
    }

    debugPrint(buffer.toString());

    if (stackTrace != null && kDebugMode) {
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
