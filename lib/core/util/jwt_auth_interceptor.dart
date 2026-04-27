import 'package:dio/dio.dart';

class JwtAuthInterceptor extends Interceptor {
  final Future<String?> Function() getToken;
  final Set<String> excludedPaths;

  JwtAuthInterceptor({
    required this.getToken,
    Set<String>? excludedPaths,
  }) : excludedPaths = excludedPaths ?? const {};

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isExcluded(options.path) || options.headers.containsKey('Authorization')) {
      handler.next(options);
      return;
    }

    try {
      final token = await getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {
      // If token lookup fails, proceed without auth header.
    }

    handler.next(options);
  }

  bool _isExcluded(String path) {
    return excludedPaths.any((excludedPath) =>
        path == excludedPath || path.endsWith(excludedPath));
  }
}