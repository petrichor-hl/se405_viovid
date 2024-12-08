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

  Future<ResponseType> request<RequestType, ResponseType>({
    required String url,
    required ApiMethod method,
    RequestType? payload, // POST, PUT
    Map<String, dynamic>? queryParameters, // GET
    required ResponseType Function(dynamic) fromJson,
  }) async {
    print('$method - $url - ⏰');
    final response = await dio.request(
      url,
      data: payload,
      queryParameters: queryParameters,
      options: Options(
        method: method.toString().split('.').last, // ApiMethod.get => "get"
        contentType: 'application/json',
      ),
    );
    print('$method - $url - ✅');

    return fromJson(response.data['result']);
  }
}
