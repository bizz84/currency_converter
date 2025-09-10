import 'dart:developer';

import 'package:dio/dio.dart';

/// A simple interceptor used to log all network requests
/// For more details, see: https://github.com/bizz84/flutter-tips-and-tricks/blob/main/tips/0152-log-status-code-emoji/index.md
class LoggerDioInterceptor implements Interceptor {
  final stopwatches = <String, Stopwatch>{};

  static const _name = 'Http';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final url = '${options.baseUrl}${options.path}';
    stopwatches[url] = Stopwatch()..start();
    log('🌍 Making request: $url', name: _name);
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final url =
        '${response.requestOptions.baseUrl}${response.requestOptions.path}';
    _logMessageAndClearStopwatch(
      response.statusCode,
      url,
      '⬅️ Received response',
    );
    if (response.requestOptions.queryParameters.isNotEmpty) {
      log(
        'Query params: ${response.requestOptions.queryParameters}',
        name: _name,
      );
    }
    if (response.data != null) {
      log('Response: ${response.data}', name: _name);
    }
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final url = err.requestOptions.uri.toString();
    _logMessageAndClearStopwatch(null, url, '❌ Received error');
    log('${err.stackTrace}', name: _name);
    if (err.response?.data != null) {
      log('❌ Response Error: ${err.response?.data}', name: _name);
    }
    return handler.next(err);
  }

  void _logMessageAndClearStopwatch(
    int? statusCode,
    String url,
    String message,
  ) {
    final stopwatch = stopwatches[url];
    if (stopwatch != null) {
      stopwatch.stop();
      _logResponse(statusCode, stopwatch.elapsedMilliseconds, url);
      stopwatches.remove(url);
    } else {
      log(message, name: _name);
    }
  }

  void _logResponse(int? statusCode, int milliseconds, String url) {
    final emoji = switch (statusCode) {
      != null && >= 200 && < 300 => '✅',
      != null && >= 300 && < 400 => '🟠',
      _ => '❌',
    };
    if (statusCode != null) {
      log('$emoji $statusCode $emoji | ${milliseconds}ms | $url', name: _name);
    } else {
      log('$emoji | ${milliseconds}ms | $url', name: _name);
    }
  }
}
