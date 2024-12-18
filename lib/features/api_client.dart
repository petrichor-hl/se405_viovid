import 'dart:developer';
import 'package:dio/dio.dart';

enum ApiMethod {
  get,
  post,
  put,
  delete,
}

class ApiClient {
  final Dio dio;

  ApiClient(this.dio);

  Future<TResponse> request<TRequest, TResponse>({
    required String url,
    required ApiMethod method,
    TRequest? payload,
    Map<String, dynamic>? queryParameters,
    TResponse Function(dynamic)? fromJson,
  }) async {
    try {
      // print('dio: ${dio.options.baseUrl}');
      // print('$method - $url - ⏰');
      // print('url $url');
      // print('payload $payload');
      // print('queryParameters $queryParameters');

      log('$method - $url - ⏰');
      final response = await dio.request(
        url,
        data: payload,
        queryParameters: queryParameters,
        options: Options(
          method: method.toString().split('.').last, // ApiMethod.get => "get"
          contentType: 'application/json',
        ),
      );

      // print('response ${response.data}');
      log('$method - $url - ✅');

      return fromJson != null
          ? fromJson(response.data['result'])
          : response.data['result'];
    } on DioException catch (e) {
      if (e.response != null) {
        print('DioError response: ${e.response}');
        print('DioError response data: ${e.response?.data}');
        print('DioError response status code: ${e.response?.statusCode}');
      } else {
        print('DioError message: ${e.message}');
      }
      rethrow;
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }
}
