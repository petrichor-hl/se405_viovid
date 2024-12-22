import 'package:dio/dio.dart';
import 'package:viovid_app/features/api_client.dart';
import 'package:viovid_app/features/channel/dtos/channel.dart';

class PagingData<T> {
  final List<T> items;

  PagingData({
    required this.items,
  });

  factory PagingData.fromJson(Map<String, dynamic> json) {
    print("json: $json");
    return PagingData(
      items: List<T>.from(json['items'].map((item) => Channel.fromJson(item))),
    );
  }
}

class ChannelApiService {
  final Dio dio;

  ChannelApiService(this.dio);

  Future<Channel> createChannel(Map<String, dynamic> channelData) async {
    print('creating channel...');
    final result = await ApiClient(dio).request<Map<String, dynamic>, Channel>(
      url: '/Channel',
      method: ApiMethod.post,
      payload: channelData,
      fromJson: (result) => Channel.fromJson(result),
    );
    print(result);
    return result;
  }

  Future<PagingData<Channel>> getChannels({
    required int pageIndex,
    required int pageSize,
    required String searchText,
  }) async {
    print("getting channels...");
    final response = await ApiClient(dio).request<void, PagingData<Channel>>(
      url: '/Channel',
      method: ApiMethod.get,
      queryParameters: {
        'PageIndex': pageIndex,
        'PageSize': pageSize,
        'SearchText': searchText,
      },
      fromJson: (json) => PagingData.fromJson(json),
    );

    print(response);
    return response;
  }

  Future<Channel> getChannelById({
    required String channelId,
  }) async {
    print("getting channel detail...");
    final response = await ApiClient(dio).request<void, Channel>(
      url: '/Channel/$channelId',
      method: ApiMethod.get,
      fromJson: (json) => Channel.fromJson(json),
    );

    print(response);
    return response;
  }

  Future<PagingData<Channel>> getChannelsByUser({
    required int pageIndex,
    required int pageSize,
    required String searchText,
  }) async {
    print("getting channels...");
    final response = await ApiClient(dio).request<void, PagingData<Channel>>(
      url: '/Channel/User',
      method: ApiMethod.get,
      queryParameters: {
        'PageIndex': pageIndex,
        'PageSize': pageSize,
        'SearchText': searchText,
      },
      fromJson: (json) => PagingData.fromJson(json),
    );

    print(response);
    return response;
  }

  Future<bool> subscribeChannel(Map<String, dynamic> channelData) async {
    print(channelData);
    final result = await ApiClient(dio).request<Map<String, dynamic>, bool>(
      url: '/Channel/Subscribe',
      method: ApiMethod.post,
      payload: channelData,
    );
    print(result);
    return result;
  }

  Future<bool> unsubscribeChannel(Map<String, dynamic> channelData) async {
    print(channelData);
    final result = await ApiClient(dio).request<Map<String, dynamic>, bool>(
      url: '/Channel/unsubscribe',
      method: ApiMethod.post,
      payload: channelData,
    );
    print(result);
    return result;
  }
}
