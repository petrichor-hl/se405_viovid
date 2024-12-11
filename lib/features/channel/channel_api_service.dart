import 'package:dio/dio.dart';
import 'package:viovid_app/features/api_client.dart';

class ChannelApiService {
  final Dio dio;

  ChannelApiService(this.dio);

  Future<void> createChannel(Map<String, dynamic> channelData) async {
    print('????????????????????');

    var result = await ApiClient(dio).request<Map<String, dynamic>, Object>(
      url: '/Channel',
      method: ApiMethod.post,
      payload: channelData,
      fromJson: (_) => {},
    );
    print(result);
  }
}
