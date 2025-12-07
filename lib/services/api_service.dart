import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

class ApiService {
  late Dio _dio;
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token to requests
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString(AppConfig.tokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          // Handle errors globally
          if (error.response?.statusCode == 401) {
            // Token expired or invalid - handle logout
            _handleUnauthorized();
          }
          return handler.next(error);
        },
      ),
    );
  }

  void _handleUnauthorized() {
    // Clear token and navigate to login
    // This should be handled by auth service
  }

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final fullUrl = '${AppConfig.baseUrl}$path';
    debugPrint('🔵 DEBUG ApiService: POST $path');
    debugPrint('🔵 DEBUG ApiService: Full URL: $fullUrl');
    debugPrint('🔵 DEBUG ApiService: Data: $data');
    
    try {
      debugPrint('🔵 DEBUG ApiService: Envoi de la requête...');
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      debugPrint('✅ DEBUG ApiService: Response status: ${response.statusCode}');
      debugPrint('✅ DEBUG ApiService: Response data: ${response.data}');
      return response;
    } on DioException catch (e) {
      debugPrint('🔴 DEBUG ApiService: DioException: ${e.type}');
      debugPrint('🔴 DEBUG ApiService: Error message: ${e.message}');
      debugPrint('🔴 DEBUG ApiService: Response: ${e.response?.data}');
      debugPrint('🔴 DEBUG ApiService: Status code: ${e.response?.statusCode}');
      throw _handleError(e);
    } catch (e) {
      debugPrint('🔴 DEBUG ApiService: Other exception: $e');
      debugPrint('🔴 DEBUG ApiService: Type: ${e.runtimeType}');
      rethrow;
    }
  }

  // PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    String errorMessage = 'Une erreur est survenue';
    
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final data = error.response!.data;
      
      if (data is Map && data.containsKey('message')) {
        errorMessage = data['message'] as String;
      } else {
        switch (statusCode) {
          case 400:
            errorMessage = 'Requête invalide';
            break;
          case 401:
            errorMessage = 'Non autorisé';
            break;
          case 403:
            errorMessage = 'Accès interdit';
            break;
          case 404:
            errorMessage = 'Ressource non trouvée';
            break;
          case 500:
            errorMessage = 'Erreur serveur';
            break;
          default:
            errorMessage = 'Erreur inconnue';
        }
      }
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      errorMessage = 'Timeout de connexion';
    } else if (error.type == DioExceptionType.connectionError) {
      errorMessage = 'Erreur de connexion';
    }

    return Exception(errorMessage);
  }
}

