import 'package:viovid_app/features/channel/channel_api_service.dart';

class ChannelRepository {
  final ChannelApiService apiService;

  ChannelRepository(this.apiService);

  Future<Channel> createChannel(Map<String, dynamic> channelData) async {
    return await apiService.createChannel(channelData);
  }

  Future<PagingData<Channel>> getChannels() async {
    return await apiService.getChannels(
      pageIndex: 0,
      pageSize: 15,
      searchText: '',
    );
  }
}
