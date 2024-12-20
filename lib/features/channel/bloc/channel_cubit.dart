import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/features/channel/channel_api_service.dart';
import 'package:viovid_app/features/channel/data/channel_repository.dart';

class ChannelCubit extends Cubit<void> {
  final ChannelRepository repository;

  ChannelCubit(this.repository) : super(null);

  Future<Channel> createChannel(Map<String, dynamic> channelData) async {
    try {
      return await repository.createChannel(channelData);
    } catch (e) {
      emit(null); // Emit failure state if needed
      throw e;
    }
  }

  Future<List<Channel>> getListChannel(
      int currentChannelIndex, String searchText) async {
    try {
      final response =
          await repository.getChannels(currentChannelIndex, searchText);
      emit(null); // Emit success state if needed
      return response.items;
    } catch (e) {
      emit(null); // Emit failure state if needed
      return [];
    }
  }

  Future<Channel?> getChannelById(String channelId) async {
    try {
      final response = await repository.getChannelById(channelId);
      emit(null); // Emit success state if needed
      return response;
    } catch (e) {
      emit(null); // Emit failure state if needed
      return null;
    }
  }

  Future<List<Channel>> getListChannelByUser(int currentChannelIndex) async {
    try {
      final response = await repository.getChannelsByUser(currentChannelIndex);
      emit(null); // Emit success state if needed
      return response.items;
    } catch (e) {
      emit(null); // Emit failure state if needed
      return [];
    }
  }

  Future<bool> subscribeChannel(Map<String, dynamic> channelData) async {
    try {
      return await repository.subscribeChannel(channelData);
    } catch (e) {
      emit(null); // Emit failure state if needed
      throw e;
    }
  }

  Future<bool> unsubscribeChannel(Map<String, dynamic> channelData) async {
    try {
      return await repository.unsubscribeChannel(channelData);
    } catch (e) {
      emit(null); // Emit failure state if needed
      throw e;
    }
  }
}
