import 'package:viovid_app/features/channel/channel_api_service.dart';

class ChannelRepository {
  final ChannelApiService apiService;

  ChannelRepository(this.apiService);

  Future<Channel> createChannel(Map<String, dynamic> channelData) async {
    return await apiService.createChannel(channelData);
  }

  Future<PagingData<Channel>> getChannels(int currentChannelIndex) async {
    return await apiService.getChannels(
      pageIndex: currentChannelIndex,
      pageSize: 15,
      searchText: '',
    );
  }

  Future<PagingData<Channel>> getChannelsByUser(int currentChannelIndex) async {
    return await apiService.getChannelsByUser(
      pageIndex: currentChannelIndex,
      pageSize: 15,
      searchText: '',
    );
  }

  Future<bool> subscribeChannel(Map<String, dynamic> channelData) async {
    return await apiService.subscribeChannel(channelData);
  }

  Future<bool> unsubscribeChannel(Map<String, dynamic> channelData) async {
    return await apiService.unsubscribeChannel(channelData);
  }
}
