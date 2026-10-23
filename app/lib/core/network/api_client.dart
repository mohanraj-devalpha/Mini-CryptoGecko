import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'device_id_store.dart';

class AppException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;

  const AppException(this.message, {this.code, this.statusCode});

  @override
  String toString() => message;
}

class SlowRequestNotifier extends ChangeNotifier {
  bool _isWakingUp = false;
  bool get isWakingUp => _isWakingUp;

  void setWakingUp(bool value) {
    if (_isWakingUp != value) {
      _isWakingUp = value;
      notifyListeners();
    }
  }
}

class ApiClient {
  final Dio dio;
  final DeviceIdStore deviceIdStore;
  final SlowRequestNotifier slowRequestNotifier;

  ApiClient({
    required this.dio,
    required this.deviceIdStore,
    required this.slowRequestNotifier,
  });

  static String resolveDefaultBaseUrl() {
    const defined = String.fromEnvironment('API_BASE_URL');
    if (defined.isNotEmpty) return defined;
    return 'https://coinscope-api.onrender.com';
  }

  factory ApiClient.create({
    String? baseUrl,
    DeviceIdStore? deviceIdStore,
    SlowRequestNotifier? slowNotifier,
  }) {
    final effectiveBaseUrl = baseUrl ?? resolveDefaultBaseUrl();
    final effectiveStore = deviceIdStore ?? DeviceIdStore();
    final effectiveSlowNotifier = slowNotifier ?? SlowRequestNotifier();

    final dio = Dio(
      BaseOptions(
        baseUrl: effectiveBaseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Interceptor for Device-ID and Slow Request tracking
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final deviceId = await effectiveStore.getDeviceId();
          options.headers['X-Device-Id'] = deviceId;

          // Start timer for > 5s slow request (server cold start waking up)
          Timer? wakeTimer = Timer(const Duration(seconds: 5), () {
            effectiveSlowNotifier.setWakingUp(true);
          });
          options.extra['wake_timer'] = wakeTimer;

          return handler.next(options);
        },
        onResponse: (response, handler) {
          final timer = response.requestOptions.extra['wake_timer'] as Timer?;
          timer?.cancel();
          effectiveSlowNotifier.setWakingUp(false);
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          final timer = error.requestOptions.extra['wake_timer'] as Timer?;
          timer?.cancel();
          effectiveSlowNotifier.setWakingUp(false);

          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: _mapDioError(error),
              response: error.response,
              type: error.type,
            ),
          );
        },
      ),
    );

    return ApiClient(
      dio: dio,
      deviceIdStore: effectiveStore,
      slowRequestNotifier: effectiveSlowNotifier,
    );
  }

  static AppException _mapDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const AppException(
        'Connection timed out. Server may be waking up, please retry.',
        code: 'TIMEOUT',
      );
    }

    if (error.type == DioExceptionType.connectionError) {
      return const AppException(
        'Unable to connect to server. Check your internet connection.',
        code: 'NO_INTERNET',
      );
    }

    final resp = error.response;
    if (resp != null) {
      final statusCode = resp.statusCode;
      final data = resp.data;

      if (data is Map<String, dynamic> && data['error'] != null) {
        final errObj = data['error'];
        final msg = errObj['message'] ?? 'An error occurred';
        final code = errObj['code']?.toString() ?? 'ERROR';
        return AppException(msg.toString(), code: code, statusCode: statusCode);
      }

      if (statusCode == 404) {
        return const AppException('Requested resource not found', code: 'NOT_FOUND', statusCode: 404);
      } else if (statusCode != null && statusCode >= 500) {
        return AppException('Server encountered an issue. Please try again later.', code: 'SERVER_ERROR', statusCode: statusCode);
      }
    }

    return AppException(
      error.message ?? 'An unexpected network error occurred.',
      code: 'NETWORK_ERROR',
    );
  }
}
