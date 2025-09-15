import 'package:currency_converter/src/utils/logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

@riverpod
Dio dio(Ref ref) {
  final dio = Dio();
  if (kDebugMode) {
    dio.interceptors.add(LoggerDioInterceptor());
  }
  //dio.addSentry();
  return dio;
}
