import 'package:dio/dio.dart';
import 'package:viovid_app/features/api_client.dart';

class PostApiService {
  final Dio dio;

  PostApiService(this.dio);

  Future<void> createPost(Map<String, dynamic> PostData) async {
    var result = await ApiClient(dio).request<Map<String, dynamic>, Object>(
      url: '/Post',
      method: ApiMethod.post,
      payload: PostData,
      fromJson: (_) => {},
    );
    print(result);
  }

  Future<Map<String, dynamic>> getPosts({
    required int pageIndex,
    required int pageSize,
    required String searchText,
  }) async {
    final response = await ApiClient(dio)
        .request<Map<String, dynamic>, Map<String, dynamic>>(
      url: '/Post',
      method: ApiMethod.get,
      queryParameters: {
        'PageIndex': pageIndex,
        'PageSize': pageSize,
        'SearchText': searchText,
      },
      fromJson: (json) => json,
    );

    print(response);
    return response;
  }
}
