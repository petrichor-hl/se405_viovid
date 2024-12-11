import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viovid_app/features/channel/data/channel_repository.dart';

class ChannelCubit extends Cubit<void> {
  final ChannelRepository repository;

  ChannelCubit(this.repository) : super(null);

  Future<void> createChannel(Map<String, dynamic> channelData) async {
    try {
      await repository.createChannel(channelData);
      emit(null); // Emit success state if needed
    } catch (e) {
      emit(null); // Emit failure state if needed
    }
  }
}
