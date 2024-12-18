import 'package:dio/dio.dart';
import 'package:viovid_app/features/api_client.dart';

class ChannelApiService {
  final Dio dio;

  ChannelApiService(this.dio);

  Future<void> createChannel(Map<String, dynamic> channelData) async {
    var result = await ApiClient(dio).request<Map<String, dynamic>, Object>(
      url: '/Channel',
      method: ApiMethod.post,
      payload: channelData,
      fromJson: (_) => {},
    );
    print(result);
  }

  Future<Map<String, dynamic>> getChannels({
    required int pageIndex,
    required int pageSize,
    required String searchText,
  }) async {
    final response = await ApiClient(dio)
        .request<Map<String, dynamic>, Map<String, dynamic>>(
      url: '/Channel',
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
