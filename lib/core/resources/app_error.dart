class AppError {
  final int? statusCode;
  final String? code;
  final String message;
  final bool isNetworkError;
  final bool isRetryable;

  const AppError({
    this.statusCode,
    this.code,
    required this.message,
    this.isNetworkError = false,
    this.isRetryable = false,
  });
}