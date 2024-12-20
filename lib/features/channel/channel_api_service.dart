import 'package:dio/dio.dart';
import 'package:viovid_app/features/api_client.dart';

class UserChannel {
  final String applicationUserId;
  final String channelId;

  UserChannel({
    required this.applicationUserId,
    required this.channelId,
  });
}

class Channel {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  List<UserChannel> userChannels = [];

  Channel({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.userChannels,
  });

  // Factory method to create a Channel from JSON
  factory Channel.fromJson(Map<String, dynamic> json) {
    print(
      "user chanel: ${json['userChannels']}",
    );
    var userChannels = List.from(json['userChannels'] ?? [])
        .map((item) => UserChannel(
              applicationUserId: item['applicationUserId'],
              channelId: item['channelId'],
            ))
        .toList();
    return Channel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      userChannels: userChannels,
    );
  }
}

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
    final result = await ApiClient(dio).request<Map<String, dynamic>, bool>(
      url: '/Channel/Subscribe',
      method: ApiMethod.post,
      payload: channelData,
    );
    print(result);
    return result;
  }

  Future<bool> unsubscribeChannel(Map<String, dynamic> channelData) async {
    final result = await ApiClient(dio).request<Map<String, dynamic>, bool>(
      url: '/Channel/Unsubscribe',
      method: ApiMethod.post,
      payload: channelData,
    );
    print(result);
    return result;
  }
}
