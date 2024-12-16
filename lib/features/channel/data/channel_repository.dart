import 'package:viovid_app/features/channel/channel_api_service.dart';

class ChannelRepository {
  final ChannelApiService apiService;

  ChannelRepository(this.apiService);

  Future<void> createChannel(Map<String, dynamic> channelData) async {
    await apiService.createChannel(channelData);
  }

  Future<Map<String, dynamic>> getChannels() async {
    return await apiService.getChannels(
      pageIndex: 0,
      pageSize: 15,
      searchText: '',
    );
  }
}
