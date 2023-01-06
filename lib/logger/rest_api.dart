import 'package:dio/dio.dart';
import 'package:e_commerce_app/models/logger/failure.dart';

class NetworkUtil {
  factory NetworkUtil() => _networkUtil;

  NetworkUtil.internal();

  static final NetworkUtil _networkUtil = NetworkUtil.internal();

  Dio _getHttpClient() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://applogsmonitorr.azurewebsites.net/api',
        contentType: 'application/json',
        headers: <String, dynamic>{'Accept': 'application/json'},
        connectTimeout: 60 * 1000,
        receiveTimeout: 60 * 1000,
      ),
    );

    return dio;
  }

  Future<Map<String, dynamic>> postReq(
    String url, {
    required String body,
  }) async {
    try {
      final response = await _getHttpClient().post<dynamic>(
        url,
        data: body,
      );

      final responseBody = response.data as Map<String, dynamic>;
      if (responseBody.isEmpty) return <String, dynamic>{};
      return responseBody;
    } on DioError catch (err) {
      if (DioErrorType.response == err.type) {
        if (err.response?.statusCode == 422) {
          final errors = ECommerceAppValidationError.fromJson(
              err.response?.data as Map<String, dynamic>);
          throw Failure(errors: errors.errors, message: 'Validation failed');
        }

        if (err.response?.statusCode == 403) {
          final data = err.response!.data as Map<String, dynamic>;
          throw Failure(
            message: err.response!.statusMessage!,
            errors: [
              ECommerceAppFieldValidationError(
                  'pin', [data['message'] as String])
            ],
          );
        }

        if (err.response?.statusCode == 401) {
          throw Failure(message: 'Unauthenticated');
        }
      } else if (DioErrorType.connectTimeout == err.type) {
        throw Failure(message: 'No internet connection');
      }
      throw Failure(message: 'Server error');
    }
  }
}
