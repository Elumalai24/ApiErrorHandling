import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  ApiClient()
      : _dio = Dio(),
        _storage = const FlutterSecureStorage() {
    _dio.options = BaseOptions(
      baseUrl: 'https://api.sampleapis.com/', // Replace with your base URL
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.type == DioExceptionType.connectionTimeout || error.type == DioExceptionType.receiveTimeout) {
            // Handle connection timeout
            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                error: 'Connection timeout, please try again later.',
              ),
            );
          } else if (error.type == DioExceptionType.connectionError) {
            // Handle no network
            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                error: 'No network connection, please check your internet.',
              ),
            );
          } else if (error.response != null) {
            // Handle specific status codes
            switch (error.response?.statusCode) {
              // case 401:
              // // Attempt to refresh token
              //   final success = await _refreshToken();
              //   if (success) {
              //     // Retry the failed request with the new token
              //     final options = error.requestOptions;
              //     options.headers['Authorization'] =
              //     'Bearer ${await _storage.read(key: 'access_token')}';
              //     try {
              //       final response = await _dio.fetch(options);
              //       return handler.resolve(response);
              //     } catch (e) {
              //       return handler.reject(e);
              //     }
              //   } else {
              //     // Handle logout if token refresh fails
              //     await _handleUnauthorized();
              //     return handler.reject(
              //       DioException(
              //         requestOptions: error.requestOptions,
              //         error: 'Unauthorized access. Please log in again.',
              //       ),
              //     );
              //   }
              case 403:
                return handler.reject(
                  DioException(
                    requestOptions: error.requestOptions,
                    error: 'Access denied. You do not have permission.',
                  ),
                );
              case 500:
                return handler.reject(
                  DioException(
                    requestOptions: error.requestOptions,
                    error: 'Server error, please try again later.',
                  ),
                );
              case 503:
                return handler.reject(
                  DioException(
                    requestOptions: error.requestOptions,
                    error: 'Service unavailable, please try again later.',
                  ),
                );
              default:
                return handler.next(error);
            }
          } else {
            // For any other errors
            return handler.next(error);
          }
        },
      ),
    );



  }

  // Public methods to make API calls
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return _dio.put(path, data: data);
  }

  Future<Response> delete(String path, {dynamic data}) async {
    return _dio.delete(path, data: data);
  }

  // Handle token refresh or logout
  Future<void> _handleUnauthorized() async {
    // Example: Clear tokens and navigate to login
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    // Redirect to login screen (if using a navigator, e.g., Get.to(LoginScreen))
  }
}
