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
    required TResponse Function(dynamic) fromJson,
  }) async {
    try {
      print('dio: ${dio.options.baseUrl}');
      print('$method - $url - ⏰');
      print('url $url');
      print('payload $payload');
      print('queryParameters $queryParameters');

      final response = await dio.request(
        url,
        data: payload,
        queryParameters: queryParameters,
        options: Options(
          method: method.toString().split('.').last, // ApiMethod.get => "get"
          contentType: 'application/json',
          headers: {
            'Authorization':
                'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySWQiOiJiODRhZGVhNi02NmFmLTRkZjUtYmM1NS04ZDUxNzMyZDFmMDMiLCJqdGkiOiI5ZTljMjIwMi03OWRhLTQxMDMtODQwNi1jNjI4N2JkYzU0ZjUiLCJpYXQiOiIxNi8xMi8yMDI0IDU6MDg6NTQgQ0giLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJkb3F1YW4wMjA5MDNAZ21haWwuY29tIiwidG9rZW5WZXJzaW9uIjoiMCIsImV4cCI6MTczNDM3OTczNCwiaXNzIjoiaHR0cDovLzI1LjI1LjI4LjcxOjUyNjIiLCJhdWQiOiIqIn0.paM1aYD7F4sN5vAzkxXgMB2QMePmSlpgIP8LhcE1k8E',
          },
        ),
      );

      print('response ${response.data}');
      print('$method - $url - ✅');

      return fromJson(response.data);
    } on DioError catch (e) {
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
