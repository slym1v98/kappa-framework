import 'package:dio/dio.dart';
import 'auth_models.dart';

class KappaAuthInterceptor extends Interceptor {
  final Dio _dio;
  final KappaAuthDelegate _delegate;
  String? _accessToken;

  KappaAuthInterceptor(this._dio, this._delegate);

  set accessToken(String? token) => _accessToken = token;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_accessToken != null) {
      options.headers['Authorization'] = 'Bearer $_accessToken';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Nếu lỗi 401 (Unauthorized)
    if (err.response?.statusCode == 401) {
      final result = await _delegate.onRefreshToken(_accessToken ?? '');

      return result.fold(
        (failure) {
          _delegate.onUnauthenticated();
          handler.next(err);
        },
        (newToken) async {
          _accessToken = newToken.accessToken;

          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $_accessToken';

          // Thực hiện lại request
          try {
            final response = await _dio.fetch(options);
            handler.resolve(response);
          } catch (e) {
            handler.next(err);
          }
        },
      );
    }
    handler.next(err);
  }
}
