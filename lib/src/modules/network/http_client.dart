import 'package:dio/dio.dart';
import '../../core/failure.dart';
import '../../core/result.dart';
import 'auth_models.dart';
import 'auth_interceptor.dart';

class KappaHttpClient {
  late final Dio _dio;

  KappaHttpClient({required String baseUrl, KappaAuthDelegate? authDelegate}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print('🚀 [KAPPA LOG]: $obj'),
      ),
    );

    if (authDelegate != null) {
      _dio.interceptors.add(KappaAuthInterceptor(_dio, authDelegate));
    }
  }

  Future<Result<T>> request<T>({
    required String path,
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic json)? decoder,
  }) async {
    try {
      final response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method),
      );

      final responseData = response.data;
      if (decoder != null) {
        return Success(decoder(responseData));
      }
      return Success(responseData as T);
    } on DioException catch (e) {
      return Error(_mapDioErrorToFailure(e));
    } catch (e) {
      return Error(ServerFailure('Lỗi không xác định: $e'));
    }
  }

  Failure _mapDioErrorToFailure(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return const NetworkFailure('Kết nối quá hạn');
      case DioExceptionType.badResponse:
        final message = e.response?.data?['message'] ?? 'Lỗi hệ thống';
        return ServerFailure(message, code: e.response?.statusCode.toString());
      default:
        return const NetworkFailure('Không có kết nối internet');
    }
  }
}
