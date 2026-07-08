enum AppErrorCode {
  configuration,
  validation,
  aiResponse,
  network,
  voice,
  imageGeneration,
  share,
  unknown,
}

class AppError implements Exception {
  const AppError({
    required this.code,
    required this.message,
    this.cause,
  });

  final AppErrorCode code;
  final String message;
  final Object? cause;

  factory AppError.configuration(String message, {Object? cause}) =>
      AppError(code: AppErrorCode.configuration, message: message, cause: cause);

  factory AppError.validation(String message, {Object? cause}) =>
      AppError(code: AppErrorCode.validation, message: message, cause: cause);

  factory AppError.aiResponse(String message, {Object? cause}) =>
      AppError(code: AppErrorCode.aiResponse, message: message, cause: cause);

  factory AppError.network(String message, {Object? cause}) =>
      AppError(code: AppErrorCode.network, message: message, cause: cause);

  factory AppError.voice(String message, {Object? cause}) =>
      AppError(code: AppErrorCode.voice, message: message, cause: cause);

  factory AppError.imageGeneration(String message, {Object? cause}) => AppError(
        code: AppErrorCode.imageGeneration,
        message: message,
        cause: cause,
      );

  factory AppError.share(String message, {Object? cause}) =>
      AppError(code: AppErrorCode.share, message: message, cause: cause);

  factory AppError.unknown(String message, {Object? cause}) =>
      AppError(code: AppErrorCode.unknown, message: message, cause: cause);

  @override
  String toString() => message;
}
